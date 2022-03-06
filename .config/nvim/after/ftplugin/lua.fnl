(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

(fn goto-fnl []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.lua$" :.fnl))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

;; fnlfmt: skip
(with-undo-ftplugin (opt-local keywordprg ":help")
                    (map n "]f" goto-fnl :buffer)
                    (map n "[f" goto-fnl :buffer))

