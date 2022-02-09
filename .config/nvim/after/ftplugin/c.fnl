(import-macros {: setlocal! : undo_ftplugin} :macros)

(setlocal! commentstring "// %s")
(setlocal! keywordprg ":vert Man")

(undo_ftplugin "setl cms< keywordprg<")

