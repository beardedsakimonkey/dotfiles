(import-macros {: setlocal! : no : undo_ftplugin} :macros)

(setlocal! cms ";; %s")
(setlocal! keywordprg ":help")
(setlocal! lisp true)

(undo_ftplugin "setl cms< keywordprg< lisp<")

