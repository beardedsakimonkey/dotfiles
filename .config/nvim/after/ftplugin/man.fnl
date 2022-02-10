(import-macros {: opt-local : no : undo_ftplugin} :macros)

(opt-local keywordprg :help)

(no n :q :<Cmd>lclose<Bar>q<CR> :buffer :silent :nowait)
(no n :<CR> "<C-]>" :buffer)

;; Adapted from gpanders' config
(no n :u :<C-u> :buffer :nowait)
(no n :d :<C-d> :buffer :nowait)
(no n :U :<C-b> :buffer :nowait)
(no n :D :<C-f> :buffer :nowait)
(no n :<Tab>
    "/\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>"
    :buffer)

(no n :<S-Tab>
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

