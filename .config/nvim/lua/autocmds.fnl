(local {: s\ : f\ : f-exists?} (require :util))
(import-macros {: autocmd : augroup : opt-local} :macros)

(local ns (vim.api.nvim_create_namespace :my/autocmds))

;; Adapted from gpanders' config
(fn on-fnl-err [output]
  (let [lines (vim.split output "\n")
        {: items} (vim.fn.getqflist {:efm "%C%[%^^]%#,%E%>Parse error in %f:%l:%c,%E%>Compile error in %f:%l:%c,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#"
                                     : lines})]
    (each [_ v (ipairs items)]
      (set v.text (v.text:gsub "^\n" "")))
    (local results (vim.diagnostic.fromqflist items))
    (vim.diagnostic.set ns (tonumber (vim.fn.expand :<abuf>)) results)

    (fn no-codes [s]
      (s:gsub "\027%[[0-9]m" ""))

    ;; Don't echo until nvim has rendered diagnostics
    (vim.schedule #(vim.api.nvim_echo [[(no-codes output) :WarningMsg]] true {}))))

(fn write-file [text filename]
  (local handle (assert (io.open filename :w+)))
  (handle:write text)
  (handle:close))

(fn tbl_find [pred? seq]
  (var ?res nil)
  (each [_ v (ipairs seq) :until (not= nil ?res)]
    (when (pred? v)
      (set ?res v)))
  ?res)

(fn compile-fennel []
  (let [config-dir (.. (vim.fn.stdpath :config) "/")
        roots [config-dir
               (.. (vim.fn.stdpath :data) :/site/pack/packer/start/nvim-udir/)
               (.. (vim.fn.stdpath :data) :/site/pack/packer/start/snap/)
               (.. (vim.fn.stdpath :data)
                   :/site/pack/packer/opt/nvim-antifennel/)]
        src (vim.fn.expand "<afile>:p")
        ?root (tbl_find #(vim.startswith src $1) roots)
        ;; Avoid abs path because it appears in output of `lambda`
        src (if (and ?root (vim.startswith src ?root))
                (src:sub (+ 1 (length ?root)))
                src)
        dest (src:gsub :.fnl$ :.lua)
        compile? (and ?root (not (vim.endswith src :macros.fnl)))
        buf (tonumber (vim.fn.expand :<abuf>))]
    (vim.diagnostic.reset ns buf)
    (when compile?
      (local linter (.. (os.getenv :HOME) :/bin/linter.fnl))
      (local cmd (: "fennel %s --globals 'vim' --compile %s" :format
                    (if (f-exists? linter)
                        (.. "--plugin " (s\ linter))
                        "") (s\ src)))
      ;; Change dir so macros.fnl gets read
      (when ?root
        (vim.cmd (.. "lcd " (f\ ?root))))
      (local output (vim.fn.system cmd))
      (local err? (not= 0 vim.v.shell_error))
      ;; Instruct formatter to avoid formatting
      (vim.api.nvim_buf_set_var buf :comp_err err?)
      (if err?
          (on-fnl-err output)
          (do
            (write-file output dest)
            (when (= config-dir ?root)
              (when (not (vim.startswith src :after/ftplugin))
                (vim.cmd (.. "luafile " (f\ dest))))
              (when (= :lua/plugins.fnl src)
                (vim.cmd :PackerCompile))
              (when (and (= :colors/navajo.fnl src) vim.g.colors_name)
                (vim.cmd (.. "colorscheme " vim.g.colors_name))))))
      (when ?root
        (vim.cmd "lcd -")))))

(fn handle-large-buffer []
  (local size (vim.fn.getfsize (vim.fn.expand :<afile>)))
  (when (or (> size (* 1024 1024)) (= size -2))
    (vim.cmd "syntax clear")))

(fn maybe-make-executable []
  (local first-line (. (vim.api.nvim_buf_get_lines 0 0 1 false) 1))
  (when (first-line:match "^#!%S+")
    (local path (s\ (vim.fn.expand "<afile>:p")))
    ;; NOTE: libuv operations say that the file doesn't exist yet..
    (vim.cmd (.. "sil !chmod +x " path))))

(fn maybe-create-directories []
  (let [afile (vim.fn.expand :<afile>)
        create? (not (afile:match "://"))
        new (f\ (vim.fn.expand "<afile>:p:h"))]
    (if create? (vim.fn.mkdir new :p))))

(fn source-tmux-cfg []
  (local file (s\ (vim.fn.expand "<afile>:p")))
  (vim.fn.system (.. "tmux source-file " file)))

(fn setup-formatoptions []
  (opt-local formatoptions += :jcn)
  (when (not= :markdown (vim.fn.expand :<amatch>))
    (opt-local formatoptions -= :t))
  (opt-local formatoptions -= [:r :o]))

(fn update-user-js []
  (vim.loop.spawn "/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/updater.sh"
                  {:args [:-d :-s :-b]}
                  (fn [code]
                    (assert (= 0 code))
                    (print "Updated user.js"))))

(fn strip-trailing-newline [str]
  (if (= "\n" (str:sub -1)) (str:sub 1 -2) str))

(fn edit-url []
  (local stdout (vim.loop.new_pipe))
  (local stderr (vim.loop.new_pipe))

  (fn on-exit [code signal]
    (if (not= 0 code)
        (print (string.format "spawn failed (exit code %d, signal %d)" code
                              signal))))

  (vim.loop.spawn :curl
                  {:stdio [nil stdout stderr]
                   :args [; follow redirects
                          :--location
                          :--silent
                          :--show-error
                          (vim.fn.expand :<afile>)]} on-exit)

  (fn on-stdout/err [?err ?data]
    (assert (not ?err) ?err)
    (when (not= nil ?data)
      (local lines (vim.split (strip-trailing-newline ?data) "\n"))
      (vim.schedule (fn []
                      ;; FIXME: this doesn't handle when chunks end in the
                      ;; middle of a line. maybe just batch everything into a
                      ;; single buf_set_lines
                      (local start (if vim.bo.modified -1 0))
                      (vim.api.nvim_buf_set_lines 0 start -1 false lines)))))

  (vim.loop.read_start stdout on-stdout/err)
  (vim.loop.read_start stderr on-stdout/err))

(macro set-lines [lines]
  `(vim.api.nvim_buf_set_lines 0 0 -1 true ,lines))

(fn template-h []
  (let [file-name (vim.fn.expand "<afile>:t")
        guard (string.upper (file-name:gsub "%." "_"))]
    (set-lines [(.. "#ifndef " guard) (.. "#define " guard) "" "#endif"])))

;; fnlfmt: skip
(fn template-c []
  (local str "#include <stdio.h>

int main(int argc, char *argv[]) {
\tprintf(\"hi\\n\");
}")
  (set-lines (vim.split str "\n")))

(fn fast-theme []
  (local zsh
         (.. (os.getenv :HOME)
             :/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh))
  (if (f-exists? zsh)
      (do
        (local cmd (.. "source " zsh " && fast-theme "
                       (vim.fn.expand "<afile>:p")))
        (local output (vim.fn.system cmd))
        (when (not= 0 vim.v.shell_error)
          (vim.api.nvim_err_writeln output)))
      (vim.api.nvim_err_writeln "zsh script not found")))

;; fnlfmt: skip
(augroup :my/autocmds
         (autocmd BufReadPre * handle-large-buffer)
         (autocmd FileType * setup-formatoptions)
         (autocmd [BufWritePre FileWritePre] * maybe-create-directories)
         (autocmd BufWritePost */.zsh/overlay.ini fast-theme)
         (autocmd BufWritePost *.fnl compile-fennel)
         (autocmd BufWritePost *tmux.conf source-tmux-cfg)
         (autocmd BufWritePost */.config/nvim/plugin/*.vim "source <afile>:p")
         (autocmd BufWritePost user-overrides.js update-user-js)
         (autocmd BufNewFile * #(autocmd :my/autocmds BufWritePost <buffer> maybe-make-executable :++once))
         (autocmd BufNewFile [http://* https://*] edit-url)
         (autocmd BufNewFile *.sh #(set-lines ["#!/bin/bash"]))
         (autocmd BufNewFile *.h template-h)
         (autocmd BufNewFile main.c template-c)
         (autocmd VimResized * "wincmd =")
         (autocmd [FocusGained BufEnter] * :checktime)
         (autocmd TextYankPost * #(vim.highlight.on_yank {:on_visual false})))

