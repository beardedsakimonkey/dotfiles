(local {: s\ : f\ : $HOME : $TMUX : exists? : system : find} (require :util))

(import-macros {: autocmd : augroup : opt-local : map} :macros)

(local ns (vim.api.nvim_create_namespace :my/autocmds))

(fn source-lua []
  (local name (vim.fn.expand "<afile>:p"))
  (when (and (vim.startswith name (vim.fn.stdpath :config))
             (= nil (name:match :after/ftplugin)))
    (vim.cmd (.. "luafile " (f\ name)))))

;; Adapted from gpanders' config
(fn on-fnl-err [output]
  (let [lines (vim.split output "\n")
        {: items} (vim.fn.getqflist {:efm "%C%[%^^]%#,%E%>Parse error in %f:%l:%c,%E%>Compile error in %f:%l:%c,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#"
                                     : lines})]
    (each [_ v (ipairs items)]
      (set v.text (v.text:gsub "^\n" "")))
    (local diagnostics (vim.diagnostic.fromqflist items))
    ;; qflist columns are 1-indexed
    (each [_ d (ipairs diagnostics)]
      (set d.col (+ 1 d.col)))
    (vim.diagnostic.set ns (tonumber (vim.fn.expand :<abuf>)) diagnostics)

    (fn no-codes [s]
      (s:gsub "\027%[[0-9]m" ""))

    ;; Don't echo until nvim has rendered diagnostics
    (vim.schedule #(vim.notify (no-codes output) vim.log.levels.WARN))))

(fn write-file [text filename]
  (local handle (assert (io.open filename :w+)))
  (handle:write text)
  (handle:close))

(fn compile-fennel [src buf]
  ;; Compile with an in-process `fennel` so that the compilation environment
  ;; matches the runtime environment. This allows us to use plugins without having
  ;; to configure globals and package.path.
  (local fennel (require :fennel))
  (local linter (.. (vim.fn.stdpath :config) :/linter.fnl))
  (local plugins (if (exists? linter)
                     ;; Adapted from launcher.fnl
                     [(fennel.dofile linter
                                     {:env :_COMPILER
                                      :useMetadata true
                                      :compiler-env _G})]
                     []))
  (local opts {:filename src : plugins :allowedGlobals []})
  ;; Enable checking that globals exist
  (each [global-name (pairs _G)]
    (table.insert opts.allowedGlobals global-name))
  (local fnl-str (-> (vim.api.nvim_buf_get_lines buf 0 -1 true)
                     (table.concat "\n")))
  (xpcall #(fennel.compile-string fnl-str opts) fennel.traceback))

(fn build-fennel []
  (let [buf (tonumber (vim.fn.expand :<abuf>))
        config-dir (.. (vim.fn.stdpath :config) "/")
        roots [config-dir
               (.. (vim.fn.stdpath :data) :/site/pack/packer/start/nvim-udir/)
               (.. (vim.fn.stdpath :data) :/site/pack/packer/start/snap/)
               :/Users/tim/code/test/
               (.. (vim.fn.stdpath :data)
                   :/site/pack/packer/opt/nvim-antifennel/)]
        src-abs (vim.fn.expand "<afile>:p")
        ?root (find #(vim.startswith src-abs $1) roots)
        ;; Avoid abs path because it appears in output of `lambda`
        src (if (and ?root (vim.startswith src-abs ?root))
                (src-abs:sub (+ 1 (length ?root)))
                src-abs)
        dest (src:gsub :.fnl$ :.lua)
        compile? (and ?root (not (vim.endswith src :macros.fnl))
                      (not (vim.endswith src :linter.fnl)))]
    (vim.diagnostic.reset ns buf)
    (when compile?
      ;; Change dir so macros.fnl gets read
      (when ?root
        (vim.cmd (.. "lcd " (f\ ?root))))
      (local (ok? output) (compile-fennel src buf))
      ;; Instruct formatter to avoid formatting
      (vim.api.nvim_buf_set_var buf :comp_err (not ok?))
      (if (not ok?)
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

(fn create-missing-dirs []
  (let [afile (vim.fn.expand :<afile>)
        create? (not (afile:match "://"))
        new (f\ (vim.fn.expand "<afile>:p:h"))]
    (if create? (vim.fn.mkdir new :p))))

(fn source-tmux []
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

(fn edit-url []
  (local buf (tonumber (vim.fn.expand :<abuf>)))
  (var afile (vim.fn.expand :<afile>))
  ;; (set afile (afile:gsub "^https://github%.com/"
  ;;                        "https://raw.githubusercontent.com/"))

  (fn strip-trailing-newline [str]
    (if (= "\n" (str:sub -1)) (str:sub 1 -2) str))

  (fn cb [stdout stderr exit-code]
    (local lines (-> (if (= 0 exit-code) stdout stderr)
                     (strip-trailing-newline)
                     (vim.split "\n")))
    (vim.schedule #(vim.api.nvim_buf_set_lines buf 0 -1 true lines)))

  (system [:curl :--location :--silent :--show-error afile] cb))

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
         (.. $HOME
             :/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh))
  (if (exists? zsh)
      (do
        (local cmd (.. "source " zsh " && fast-theme "
                       (vim.fn.expand "<afile>:p")))
        (local output (vim.fn.system cmd))
        (when (not= 0 vim.v.shell_error)
          (vim.api.nvim_err_writeln output)))
      (vim.api.nvim_err_writeln "zsh script not found")))

(var sh-repeat? false)
(map n :g.
     (fn []
       (set sh-repeat? (not sh-repeat?))
       (print "shell repeat" (if sh-repeat? :enabled :disabled))))

(fn repeat-shell-cmd []
  (local is-tmux? (not= nil $TMUX))
  (when (and is-tmux? sh-repeat?)
    (vim.fn.system "tmux if -F -t '{last}' '#{m:*sh,#{pane_current_command}}' \"send-keys -t '{last}' Up Enter\"")))

;; fnlfmt: skip
(augroup :my/autocmds
         (autocmd BufReadPre * handle-large-buffer)
         (autocmd FileType * setup-formatoptions)
         (autocmd [BufWritePre FileWritePre] * create-missing-dirs)
         (autocmd BufWritePost *.lua source-lua)
         (autocmd BufWritePost *.fnl build-fennel)
         (autocmd BufWritePost */.config/nvim/plugin/*.vim "source <afile>:p")
         (autocmd BufWritePost *.rs repeat-shell-cmd)
         (autocmd BufWritePost *tmux.conf source-tmux)
         (autocmd BufWritePost user-overrides.js update-user-js)
         (autocmd BufWritePost */.zsh/overlay.ini fast-theme)
         (autocmd BufNewFile * #(autocmd :my/autocmds BufWritePost <buffer> maybe-make-executable :++once))
         (autocmd BufNewFile [http://* https://*] edit-url)
         (autocmd BufNewFile *.sh #(set-lines ["#!/bin/bash"]))
         (autocmd BufNewFile *.h template-h)
         (autocmd BufNewFile main.c template-c)
         (autocmd VimResized * "wincmd =")
         (autocmd [FocusGained BufEnter] * :checktime)
         (autocmd TextYankPost * #(vim.highlight.on_yank {:on_visual false})))

