(import-macros {: autocmd : augroup : opt-local} :macros)

(local ns (vim.api.nvim_create_namespace :my/autocmds))

;; Adapted from gpanders' config
(fn on-fnl-err [output]
  (let [lines (vim.split output "\n")
        {: items} (vim.fn.getqflist {:efm "%C%[%^^]%#,%E%>Parse error in %f:%l,%E%>Compile error in %f:%l,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#"
                                     : lines})]
    (each [_ v (ipairs items)]
      (set v.text (v.text:gsub "^\n" "")))
    (local results (vim.diagnostic.fromqflist items))
    (vim.diagnostic.set ns (tonumber (vim.fn.expand :<abuf>)) results)
    ;; Don't echo until nvim has rendered diagnostics
    (vim.schedule #(vim.api.nvim_echo [[output :WarningMsg]] true {}))))

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
               (.. (vim.fn.stdpath :data) :/site/pack/packer/start/snap/)]
        src (vim.fn.expand "<afile>:p")
        ?root (tbl_find #(vim.startswith src $1) roots)
        ;; Avoid abs path because it appears in output of `lambda`
        src (if ?root (src:gsub (.. "^" ?root) "") src)
        dest (src:gsub :.fnl$ :.lua)
        compile? (and ?root (not (vim.endswith src :macros.fnl)))]
    (vim.diagnostic.reset ns (tonumber (vim.fn.expand :<abuf>)))
    (if compile?
        (let [cmd (.. "fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile "
                      (vim.fn.shellescape src))]
          ;; Change dir so macros.fnl gets read
          (when ?root
            (vim.cmd (.. "lcd " (vim.fn.fnameescape ?root))))
          (local output (vim.fn.system cmd))
          (if (not= 0 vim.v.shell_error) (on-fnl-err output)
              (write-file output dest))
          (when (and (= 0 vim.v.shell_error) (= ?root config-dir))
            (if (not (vim.startswith src :after/ftplugin))
                (vim.cmd (.. "luafile " (vim.fn.fnameescape dest))))
            (if (= src :lua/plugins.fnl) (vim.cmd :PackerCompile)))
          (when (= src :colors/navajo.fnl)
            (vim.cmd (.. "luafile " (vim.fn.fnameescape dest)))
            (if vim.g.colors_name
                (vim.cmd (.. "colorscheme " vim.g.colors_name))))
          (when ?root
            (vim.cmd "lcd -"))))))

(fn handle-large-buffers []
  (local size (vim.fn.getfsize (vim.fn.expand :<afile>)))
  (when (or (> size (* 1024 1024)) (= size -2))
    (vim.cmd "syntax clear")))

(fn maybe-make-executable []
  (local first-line (. (vim.api.nvim_buf_get_lines 0 0 1 false) 1))
  (when (first-line:match "^#!%S+")
    (local path (vim.fn.shellescape (vim.fn.expand "<afile>:p")))
    ;; NOTE: libuv operations say that the file doesn't exist yet..
    (vim.cmd (.. "sil !chmod +x " path))))

(fn maybe-create-directories []
  (let [afile (vim.fn.expand :<afile>)
        create? (not (afile:match "://"))
        new (vim.fn.fnameescape (vim.fn.expand "<afile>:p:h"))]
    (if create? (vim.fn.mkdir new :p))))

;; (fn source-colorscheme []
;;   (vim.cmd (.. "source " (vim.fn.fnameescape (vim.fn.expand "<afile>:p"))))
;;   (if vim.g.colors_name
;;       (vim.cmd (.. "colorscheme " vim.g.colors_name))))

(fn source-tmux-cfg []
  (local file (vim.fn.shellescape (vim.fn.expand "<afile>:p")))
  (vim.fn.system (.. "tmux source-file " file)))

(fn restore-cursor-position []
  (local last-cursor-pos (vim.api.nvim_buf_get_mark 0 "\""))
  (if (not (vim.endswith vim.bo.filetype :commit))
      (pcall vim.api.nvim_win_set_cursor 0 last-cursor-pos)))

(fn setup-formatoptions []
  (opt-local formatoptions += :jcn)
  (opt-local formatoptions -= [:r :o :t]))

(fn update-user-js []
  (local cmd
         "/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/updater.sh")
  (local opts {:args [cmd :-d :-s :-b]})

  (fn on-exit [code _]
    (assert (= 0 code))
    (print "Updated user.js"))

  (local (_handle _pid) (assert (vim.loop.spawn cmd opts on-exit))))

(fn strip-trailing-newline [str]
  (if (= "\n" (str:sub -1)) (str:sub 1 -2) str))

(fn edit-url []
  (local stdout (vim.loop.new_pipe))
  (local stderr (vim.loop.new_pipe))

  (fn on-exit [exit-code signal]
    (if (not= 0 exit-code)
        (print (string.format "spawn failed (exit code %d, signal %d)"
                              exit-code signal))))

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

;; fnlfmt: skip
(augroup :my/autocmds
         (autocmd BufWritePost *.fnl compile-fennel)
         (autocmd BufReadPre * handle-large-buffers)
         (autocmd BufNewFile * #(autocmd :my/autocmds BufWritePost <buffer> maybe-make-executable :++once))
         (autocmd [BufWritePre FileWritePre] * maybe-create-directories)
         (autocmd TextYankPost * #(vim.highlight.on_yank {:on_visual false}))
         ;; (autocmd BufWritePost */colors/*.vim source-colorscheme)
         (autocmd BufWritePost *tmux.conf source-tmux-cfg)
         (autocmd BufWritePost */.config/nvim/plugin/*.vim "source <afile>:p")
         (autocmd BufReadPost * restore-cursor-position)
         (autocmd VimResized * "wincmd =")
         (autocmd FileType * setup-formatoptions)
         (autocmd [FocusGained BufEnter] * :checktime)
         (autocmd BufWritePost user-overrides.js update-user-js)
         (autocmd BufNewFile [http://* https://*] edit-url)
         (autocmd BufNewFile *.sh #(set-lines ["#!/bin/bash"]))
         (autocmd BufNewFile *.h template-h)
         (autocmd BufNewFile main.c template-c))

