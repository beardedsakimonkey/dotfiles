(import-macros {: au : setlocal!} :macros)
(local uv vim.loop)

;; Only use this augroup in this file.
(vim.cmd "augroup mine | au!")

;; In .nvim/config, recompile fennel on write
(fn compile-config-fennel []
  (let [config-dir (vim.fn.stdpath :config)
        src (vim.fn.expand "<afile>:p")
        dest (pick-values 1 (src:gsub :.fnl$ :.lua))
        compile? (and (vim.startswith src config-dir)
                      (not (vim.endswith src :macros.fnl)))]
    (if compile?
        (let [cmd (string.format "fennel --compile %s > %s"
                                 (vim.fn.fnameescape src)
                                 (vim.fn.fnameescape dest))]
          ;; Change dir so macros.fnl gets read
          (vim.cmd (.. "lcd " config-dir))
          (local output (vim.fn.system cmd))
          ;; TODO: pcall this so that the subsequent lcd runs even if it fails
          (if vim.v.shell_error (print output))
          (vim.cmd "lcd -")
          (vim.cmd (.. "luafile " dest))))))

(au BufWritePost *.fnl compile-config-fennel)

(fn compile-udir-fennel []
  (let [dir :/Users/tim/code/udir/
        src (vim.fn.expand "<afile>:p")
        ;; Don't use abs path because it appears in output of `lambda`
        src2 (pick-values 1 (src:gsub (.. "^" dir) ""))
        dest (pick-values 1 (src2:gsub :.fnl$ :.lua))
        compile? (vim.startswith src dir)]
    (when compile?
      (vim.cmd (.. "lcd " dir))
      (let [cmd (string.format "fennel --compile %s > %s"
                               (vim.fn.fnameescape src2)
                               (vim.fn.fnameescape dest))]
        (local output (vim.fn.system cmd))
        (if vim.v.shell_error (print output)))
      (vim.cmd "lcd -"))))

(au BufWritePost *.fnl compile-udir-fennel)

;; Handle large buffers
(fn handle-large-buffers []
  (let [size (vim.fn.getfsize (vim.fn.expand :<afile>))]
    (when (or (> size (* 1024 1024)) (= size -2))
      (vim.cmd "syntax clear")
      (setlocal! foldmethod :manual)
      (setlocal! foldenable false)
      (setlocal! swapfile false)
      (setlocal! undofile false))))

(au BufReadPre * handle-large-buffers)

;; Make files with a shebang executable on first write
(fn maybe-make-executable []
  (let [shebang (vim.fn.matchstr (vim.fn.getline 1) "^#!\\S\\+")]
    (if shebang
        (let [name (vim.fn.expand "<afile>:p:S")
              mode (tonumber :755 8)
              error (uv.fs_chmod name mode)]
          (if error (print "Cannot make file '" name "' executable"))))))

(fn setup-make-executable []
  (au BufWritePost <buffer> maybe-make-executable :++once))

(au BufNewFile * setup-make-executable)

;; Maybe read template
(fn maybe-read-template []
  (let [path (.. (vim.fn.stdpath :data) :/templates)
        fs (uv.fs_scandir path)]
    (var done? false)
    (while (not done?)
      (let [(name type) (uv.fs_scandir_next fs)]
        (if (not name) (set done? true) :else
            (let [basename (string.match name "(%w+)%.")]
              (if (= basename vim.bo.filetype)
                  (do
                    (set done? true)
                    (with-open [file (assert (io.open (.. path "/" name)))]
                      (let [lines (icollect [v (file:lines)]
                                    v)]
                        ;; In case the file ends with a newline
                        (if (= (. lines (length lines)) "")
                            (table.remove lines))
                        (vim.api.nvim_buf_set_lines 0 0 -1 true lines)))))))))))

;; Maybe create missing directories
(fn maybe-create-directories []
  (let [afile (vim.fn.expand :<afile>)
        create? (not (afile:match "://"))
        new (vim.fn.expand "<afile>:p:h")]
    (if create? (vim.fn.mkdir new :p))))

(au [BufWritePre FileWritePre] * maybe-create-directories)

;; Highlight text on yank
(fn highlight-text []
  (vim.highlight.on_yank {:higroup :IncSearch
                          :timeout 150
                          :on_visual false
                          :on_macro true}))

(au TextYankPost * highlight-text)

;; Source colorscheme on write
(fn source-colorscheme []
  (do
    (vim.cmd (.. "source " (vim.fn.expand "<afile>:p")))
    (if vim.g.colors_name
        (vim.cmd (.. "colorscheme " vim.g.colors_name)))))

(au BufWritePost */colors/*.vim source-colorscheme)

;; Source tmux config on write
(fn source-tmux-cfg []
  (vim.fn.system (.. "tmux source-file " (vim.fn.expand "<afile>:p"))))

(au BufWritePost *tmux.conf source-tmux-cfg)

;; Restore cursor position
(fn restore-cursor-position []
  (let [last-cursor-pos (vim.api.nvim_buf_get_mark 0 "\"")]
    (if (not (vim.endswith vim.bo.filetype :commit))
        (pcall vim.api.nvim_win_set_cursor 0 last-cursor-pos))))

(au BufReadPost * restore-cursor-position)

;; Resize splits when vim is resized
(au VimResized * "wincmd =")

(fn setup-formatting []
  (vim.opt_local.formatoptions:append :jcn)
  ;; Remove options one-by-one to avoid issues (see :h set-=)
  (vim.opt_local.formatoptions:remove :r)
  (vim.opt_local.formatoptions:remove :o)
  (vim.opt_local.formatoptions:remove :t))

(au FileType * setup-formatting)

;; Reload file if changed on disk
(au [FocusGained BufEnter] * :checktime)

(vim.cmd "augroup END")

