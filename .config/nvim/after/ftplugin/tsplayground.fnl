(import-macros {: map : undo_ftplugin} :macros)

(map n :q :<Cmd>q<CR> :silent :buffer)

(undo_ftplugin "sil! nun <buffer> q")

