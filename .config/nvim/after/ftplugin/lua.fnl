(import-macros {: opt-local : no : undo_ftplugin} :macros)

(opt-local keywordprg ":help")

(fn goto-fnl []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub :.lua$ :.fnl))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

(no n "]f" goto-fnl :buffer)
(no n "[f" goto-fnl :buffer)

(undo_ftplugin "setl keywordprg<" "sil! nunmap <buffer> ]f"
               "sil! nunmap <buffer> [f")

