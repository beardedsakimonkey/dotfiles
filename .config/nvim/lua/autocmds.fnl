(import-macros {: autocmd : setlocal!} :macros)
(local uv vim.loop)

;; Recompile fennel on write
(fn recompile-fennel []
  ;; TODO: check if <afile> is in config dir
  (vim.cmd (.. "lcd " (vim.fn.stdpath :config)))
  (vim.cmd :make)
  (vim.cmd "lcd -"))

(autocmd BufWritePost *.fnl recompile-fennel)

;; Handler large buffers
(fn handle-large-buffers []
  (let [size (vim.fn.getfsize (vim.fn.expand :<afile>))]
    (when (or (> size (* 1024 1024)) (= size -2))
      (vim.cmd "syntax clear")
      (setlocal! foldmethod :manual)
      (setlocal! foldenable false)
      (setlocal! swapfile false)
      (setlocal! undofile false))))

(autocmd BufReadPre * handle-large-buffers)

;; Make files with a shebang executable on first write
(fn maybe-make-executable []
  (let [shebang (vim.fn.matchstr (vim.fn.getline 1) "^#!\\S\\+")]
    (if shebang
        (let [name (vim.fn.expand "<afile>:p:S")
              mode (tonumber :755 8)
              error (uv.fs_chmod name mode)]
          (if error (print "Cannot make file '" name "' executable"))))))

(fn setup-make-executable []
  (autocmd BufWritePost <buffer> maybe-make-executable
           :++once))

(autocmd BufNewFile * setup-make-executable)

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

;; Highlight text on yank
(fn highlight-text []
  (vim.highlight.on_yank {:higroup :IncSearch
                          :timeout 150
                          :on_visual false
                          :on_macro true}))

(autocmd TextYankPost * highlight-text)

;; Source colorscheme on write
(fn source-colorscheme []
  (do
    (vim.cmd (.. "source " (vim.fn.expand "<afile>:p")))
    (if vim.g.colors_name
      (vim.cmd (.. "colorscheme " vim.g.colors_name)))))

(autocmd BufWritePost */colors/*.vim source-colorscheme)

;; Source tmux config on write
(fn source-tmux-cfg []
  (vim.fn.system (.. "tmux source-file " (vim.fn.expand "<afile>:p"))))

(autocmd BufWritePost *tmux.conf source-tmux-cfg)

;; Restore cursor position
(fn restore-cursor-position []
  (let [last-cursor-pos (vim.api.nvim_buf_get_mark 0 "\"")]
    (if (not (vim.endswith vim.bo.filetype :commit))
      (vim.api.nvim_win_set_cursor 0 last-cursor-pos))))

(autocmd BufReadPost * restore-cursor-position)

;; Resize splits when vim is resized
(fn resize-splits []
  (vim.cmd "wincmd ="))

(autocmd VimResized * resize-splits)

