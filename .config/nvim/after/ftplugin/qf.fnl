(import-macros {: setlocal! : undo_ftplugin : no} :macros)

(no :n :q :<Cmd>q<CR> :silent :buffer)

(setlocal! statusline
           " %q %{printf(\" %d line%s\", line(\"$\"), line(\"$\") > 1 ? \"s \" : \" \")}")

(undo_ftplugin "sil! nun <buffer> q" "setl stl<")

