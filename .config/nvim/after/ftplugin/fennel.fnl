(import-macros {: setlocal! : no : undo_ftplugin} :macros)

(setlocal! commentstring ";; %s")
(setlocal! keywordprg ":help")

(undo_ftplugin "setl cms< keywordprg< lisp<")

