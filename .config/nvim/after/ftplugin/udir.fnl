(import-macros {: opt-local : undo_ftplugin} :macros)

(opt-local cursorline)
(opt-local statusline " %f")

(undo_ftplugin "setl cursorline< statusline<")

