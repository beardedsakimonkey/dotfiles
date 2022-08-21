(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

(fn goto-fnl []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.lua$" :.fnl))
  (if (vim.loop.fs_access to :R)
      (vim.cmd (.. "edit " (vim.fn.fnameescape to)))
      (vim.api.nvim_err_writeln (.. "Cannot read file " to))))

;; fnlfmt: skip
(with-undo-ftplugin (opt-local keywordprg ":help")
                    (map n "]f" goto-fnl :buffer)
                    (map n "[f" goto-fnl :buffer))

