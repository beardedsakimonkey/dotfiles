(import-macros {: opt-local : no : undo_ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")

(opt-local commentstring ";; %s")
(opt-local keywordprg ":help")

(undo_ftplugin "setl cms< keywordprg< lisp<" "unabbrev <buffer> lambda")

