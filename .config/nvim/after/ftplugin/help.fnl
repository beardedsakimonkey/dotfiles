(import-macros {: opt-local : no : undo_ftplugin} :macros)

(opt-local scrolloff 0)

(no n :q :<Cmd>q<CR> :buffer)

;; Adapted from gpanders' config
(no n :u :<C-u> :buffer :nowait)
(no n :d :<C-d> :buffer :nowait)
(no n :U :<C-b> :buffer :nowait)
(no n :D :<C-f> :buffer :nowait)
(no n :<Tab> "/<Bar>\\S\\{-}<Bar><CR><Cmd>nohlsearch<CR>" :buffer :silent)
(no n :<S-Tab> "?<Bar>\\S\\{-}<Bar><CR><Cmd>nohlsearch<CR>" :buffer :silent)
(no n :<CR> "g<C-]>" :buffer)

;; fnlfmt: skip
(undo_ftplugin "setl scrolloff<"
               "sil! nun <buffer> q"
               "sil! nun <buffer> d"
               "sil! nun <buffer> u"
               "sil! nun <buffer> D"
               "sil! nun <buffer> U"
               "sil! nun <buffer> <Tab>"
               "sil! nun <buffer> <S-Tab>"
               "sil! nun <buffer> <CR>")

