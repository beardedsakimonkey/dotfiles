(import-macros {: au : opt-local} :macros)

(vim.cmd "augroup my/autocmds | au!")

(local efm
       "%C%[%^^]%#,%E%>Parse error in %f:%l,%E%>Compile error in %f:%l,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#")

(local ns (vim.api.nvim_create_namespace :my/autocmds))

;; Adapted from gpanders' config
(fn on-fnl-err [output]
  (if (string.match output :macros.fnl)
      (print output)
      (print output))
  (let [lines (vim.split output "\n")
        {: items} (vim.fn.getqflist {: efm : lines})]
    (each [_ v (ipairs items)]
      (set v.text (v.text:gsub "^\n" "")))
    (local results (vim.diagnostic.fromqflist items))
    (vim.diagnostic.set ns (tonumber (vim.fn.expand :<abuf>)) results)))

(fn write! [text filename]
  (local handle (assert (io.open filename :w+)))
  (handle:write text)
  (handle:close))

;; In .nvim/config, recompile fennel on write
(fn compile-config-fennel []
  (vim.diagnostic.reset ns (tonumber (vim.fn.expand :<abuf>)))
  (let [config-dir (vim.fn.stdpath :config)
        src (vim.fn.expand "<afile>:p")
        dest (src:gsub :.fnl$ :.lua)
        compile? (and (vim.startswith src config-dir)
                      (not (vim.endswith src :macros.fnl)))]
    (if compile?
        (let [cmd (string.format "fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile %s"
                                 (vim.fn.fnameescape src))]
          ;; Change dir so macros.fnl gets read
          (vim.cmd (.. "lcd " config-dir))
          ;; TODO: pcall this so that the subsequent lcd runs even if it fails
          (local output (vim.fn.system cmd))
          (if (not= 0 vim.v.shell_error) (on-fnl-err output)
              (write! output dest))
          (vim.cmd "lcd -")
          (when (not (vim.startswith src (.. config-dir :/after/ftplugin)))
            (vim.cmd (.. "luafile " dest)))
          (when (and (= 0 vim.v.shell_error)
                     (= src (.. config-dir :/lua/plugins.fnl)))
            (vim.cmd :PackerCompile))))))

(fn compile-udir-fennel []
  (let [dir :/Users/tim/code/udir/
        src (vim.fn.expand "<afile>:p")
        ;; Don't use abs path because it appears in output of `lambda`
        src2 (src:gsub (.. "^" dir) "")
        dest (src2:gsub :.fnl$ :.lua)
        compile? (vim.startswith src dir)]
    (when compile?
      (vim.cmd (.. "lcd " dir))
      (let [cmd (string.format "fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile %s > %s"
                               (vim.fn.fnameescape src2)
                               (vim.fn.fnameescape dest))]
        (local output (vim.fn.system cmd))
        (if vim.v.shell_error (on-fnl-err output)))
      (vim.cmd "lcd -"))))

(fn handle-large-buffers []
  (let [size (vim.fn.getfsize (vim.fn.expand :<afile>))]
    (when (or (> size (* 1024 1024)) (= size -2))
      (vim.cmd "syntax clear")
      (opt-local foldmethod :manual)
      (opt-local foldenable false)
      (opt-local swapfile false)
      (opt-local undofile false))))

;; Make files with a shebang executable on first write
(fn maybe-make-executable []
  (local first-line (. (vim.api.nvim_buf_get_lines 0 0 1 false) 1))
  (if (first-line:match "^#!%S+")
      (let [path (vim.fn.expand "<afile>:p:S")]
        ;; NOTE: libuv operations say that the file doesn't exist yet..
        (vim.cmd (.. "sil !chmod +x " path)))))

(fn setup-make-executable []
  (au BufWritePost <buffer> maybe-make-executable :++once))

(fn maybe-create-directories []
  (let [afile (vim.fn.expand :<afile>)
        create? (not (afile:match "://"))
        new (vim.fn.expand "<afile>:p:h")]
    (if create? (vim.fn.mkdir new :p))))

(fn highlight-text []
  (vim.highlight.on_yank {:higroup :IncSearch
                          :timeout 150
                          :on_visual false
                          :on_macro true}))

(fn source-colorscheme []
  (do
    (vim.cmd (.. "source " (vim.fn.expand "<afile>:p")))
    (if vim.g.colors_name
        (vim.cmd (.. "colorscheme " vim.g.colors_name)))))

(fn source-tmux-cfg []
  (vim.fn.system (.. "tmux source-file " (vim.fn.expand "<afile>:p"))))

(fn restore-cursor-position []
  (let [last-cursor-pos (vim.api.nvim_buf_get_mark 0 "\"")]
    (if (not (vim.endswith vim.bo.filetype :commit))
        (pcall vim.api.nvim_win_set_cursor 0 last-cursor-pos))))

(fn setup-formatting []
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

(au BufWritePost *.fnl compile-config-fennel)
(au BufWritePost *.fnl compile-udir-fennel)
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

(macro set-lines [lines]
  `(vim.api.nvim_buf_set_lines 0 0 -1 true ,lines))

;; Templates
(fn template-sh []
  (set-lines ["#!/bin/bash"]))

(fn template-h []
  (let [file-name (vim.fn.expand "<afile>:t")
        guard (string.upper (file-name:gsub "%." "_"))]
    (set-lines [(.. "#ifndef " guard) (.. "#define " guard) "" "#endif"])))

(au BufNewFile *.sh template-sh)
(au BufNewFile *.h template-h)

(vim.cmd "augroup END")

