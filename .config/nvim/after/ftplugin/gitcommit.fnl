(import-macros {: setlocal! : setlocal+= : undo_ftplugin} :macros)

(setlocal+= formatoptions :t)
(setlocal! textwidth 80)
(setlocal! colorcolumn :80)

(undo_ftplugin "setl fo< tw< cc<")

