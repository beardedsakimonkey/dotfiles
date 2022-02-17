(import-macros {: opt-local : no : undo_ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")

(opt-local commentstring ";; %s")
(opt-local keywordprg ":help")
(opt-local iskeyword -= ".")

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub :.fnl$ :.lua))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

(no n "]f" goto-lua :buffer)
(no n "[f" goto-lua :buffer)

;; fnlfmt: skip
(undo_ftplugin "setl cms< keywordprg< iskeyword<"
               "unabbrev <buffer> lambda"
               "sil! nunmap <buffer> ]f"
               "sil! nunmap <buffer> [f")

