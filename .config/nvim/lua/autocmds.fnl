(import-macros {: au : opt-local} :macros)

(vim.cmd "augroup my/autocmds | au!")

(local ns (vim.api.nvim_create_namespace :my/autocmds))

;; Adapted from gpanders' config
(fn on-fnl-err [output]
  (print output)
  (let [lines (vim.split output "\n")
        {: items} (vim.fn.getqflist {:efm "%C%[%^^]%#,%E%>Parse error in %f:%l,%E%>Compile error in %f:%l,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#"
                                     : lines})]
    (each [_ v (ipairs items)]
      (set v.text (v.text:gsub "^\n" "")))
    (local results (vim.diagnostic.fromqflist items))
    (vim.diagnostic.set ns (tonumber (vim.fn.expand :<abuf>)) results)))

(fn write! [text filename]
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
        roots [config-dir :/Users/tim/code/udir/]
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
            (vim.cmd (.. "lcd " ?root)))
          (local output (vim.fn.system cmd))
          (if (not= 0 vim.v.shell_error) (on-fnl-err output)
              (write! output dest))
          (when (and (= 0 vim.v.shell_error) (= ?root config-dir))
            (if (not (vim.startswith src :after/ftplugin))
                (vim.cmd (.. "luafile " (vim.fn.fnameescape dest))))
            (if (= src :lua/plugins.fnl) (vim.cmd :PackerCompile)))
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

(fn setup-make-executable []
  (au BufWritePost <buffer> maybe-make-executable :++once))

(fn maybe-create-directories []
  (let [afile (vim.fn.expand :<afile>)
        create? (not (afile:match "://"))
        new (vim.fn.fnameescape (vim.fn.expand "<afile>:p:h"))]
    (if create? (vim.fn.mkdir new :p))))

(fn highlight-text []
  (vim.highlight.on_yank {:higroup :IncSearch
                          :timeout 150
                          :on_visual false
                          :on_macro true}))

(fn source-colorscheme []
  (vim.cmd (.. "source " (vim.fn.fnameescape (vim.fn.expand "<afile>:p"))))
  (if vim.g.colors_name
      (vim.cmd (.. "colorscheme " vim.g.colors_name))))

(fn source-tmux-cfg []
  (local file (vim.fn.shellescape (vim.fn.expand "<afile>:p")))
  (vim.fn.system (.. "tmux source-file " file)))

(fn restore-cursor-position []
  (local last-cursor-pos (vim.api.nvim_buf_get_mark 0 "\""))
  (if (not (vim.endswith vim.bo.filetype :commit))
      (pcall vim.api.nvim_win_set_cursor 0 last-cursor-pos)))

(fn setup-formatting []
  (opt-local formatoptions += :jcn)
  (opt-local formatoptions -= [:r :o :t]))

;;
;; Update user.js
;;
(fn update-user-js []
  (local cmd
         "/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/updater.sh")
  (local opts {:args [cmd :-d :-s :-b]})

  (fn on-exit [code _]
    (assert (= 0 code))
    (print "Updated user.js"))

  (local (_handle _pid) (assert (vim.loop.spawn cmd opts on-exit))))

;;
;; Edit url
;;
(fn strip-trailing-newline [str]
  (if (= "\n" (str:sub -1)) (str:sub 1 -2) str))

(fn edit-url []
  (local stdout (vim.loop.new_pipe))
  (local stderr (vim.loop.new_pipe))

  (fn on-exit [exit-code signal]
    (if (not= 0 exit-code)
        (print (string.format "spawn failed (exit code %d, signal %d)"
                              exit-code signal))))

  (local opts {:stdio [nil stdout stderr]
               :args [; follow redirects
                      :--location
                      :--silent
                      :--show-error
                      (vim.fn.expand :<afile>)]})
  (local (_handle _pid) (vim.loop.spawn :curl opts on-exit))

  (fn on-stdout/err [?err ?data]
    (assert (not ?err) ?err)
    (when (not= nil ?data)
      (local lines (vim.split (strip-trailing-newline ?data) "\n"))
      (vim.schedule (fn []
                      (local start (if vim.bo.modified -1 0))
                      (vim.api.nvim_buf_set_lines 0 start -1 false lines)))))

  (vim.loop.read_start stdout on-stdout/err)
  (vim.loop.read_start stderr on-stdout/err))

;;
;; Templates
;;
(macro set-lines [lines]
  `(vim.api.nvim_buf_set_lines 0 0 -1 true ,lines))

(fn template-sh []
  (set-lines ["#!/bin/bash"]))

(fn template-h []
  (let [file-name (vim.fn.expand "<afile>:t")
        guard (string.upper (file-name:gsub "%." "_"))]
    (set-lines [(.. "#ifndef " guard) (.. "#define " guard) "" "#endif"])))

(au BufWritePost *.fnl compile-fennel)
(au BufReadPre * handle-large-buffers)
(au BufNewFile * setup-make-executable)
(au [BufWritePre FileWritePre] * maybe-create-directories)
(au TextYankPost * highlight-text)
(au BufWritePost */colors/*.vim source-colorscheme)
(au BufWritePost *tmux.conf source-tmux-cfg)
(au BufReadPost * restore-cursor-position)
;; Resize splits when vim is resized
(au VimResized * "wincmd =")
(au FileType * setup-formatting)
;; Reload file if changed on disk
(au [FocusGained BufEnter] * :checktime)
(au BufWritePost user-overrides.js update-user-js)
(au BufNewFile [http://* https://*] edit-url)
(au BufNewFile *.sh template-sh)
(au BufNewFile *.h template-h)

(vim.cmd "augroup END")

