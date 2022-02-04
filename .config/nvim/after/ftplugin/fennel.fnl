(import-macros {: setlocal! : no : undo_ftplugin} :macros)

(setlocal! cms ";; %s")
(setlocal! keywordprg ":help")

(undo_ftplugin "setl cms< keywordprg<")

