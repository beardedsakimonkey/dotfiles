(import-macros {: opt-local : map : undo_ftplugin} :macros)

(opt-local keywordprg :help)

(map n :q :<Cmd>lclose<Bar>q<CR> :buffer :silent :nowait)
(map n :<CR> "<C-]>" :buffer)

;; Adapted from gpanders' config
(map n :u :<C-u> :buffer :nowait)
(map n :d :<C-d> :buffer :nowait)
(map n :U :<C-b> :buffer :nowait)
(map n :D :<C-f> :buffer :nowait)
(map n :<Tab>
     "/\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>"
     :buffer)

(map n :<S-Tab>
     "?\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>"
     :buffer)

;; fnlfmt: skip
(undo_ftplugin "setl keywordprg<"
               "sil! nun <buffer> q"
               "sil! nun <buffer> <CR>"
               "sil! nun <buffer> u"
               "sil! nun <buffer> d"
               "sil! nun <buffer> U"
               "sil! nun <buffer> D"
               "sil! nun <buffer> <Tab>"
               "sil! nun <buffer> <S-Tab>"
               )

