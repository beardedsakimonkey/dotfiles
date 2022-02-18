(import-macros {: opt-local : map : undo_ftplugin} :macros)

(opt-local scrolloff 0)

(map n :q :<Cmd>q<CR> :buffer)

;; Adapted from gpanders' config
(map n :s :<C-u> :buffer :nowait)
(map n :d :<C-d> :buffer :nowait)
(map n :S :<C-b> :buffer :nowait)
(map n :D :<C-f> :buffer :nowait)
(map n :<Tab> "/<Bar>\\S\\{-}<Bar><CR><Cmd>nohlsearch<CR>" :buffer :silent)
(map n :<S-Tab> "?<Bar>\\S\\{-}<Bar><CR><Cmd>nohlsearch<CR>" :buffer :silent)
(map n :<CR> "g<C-]>" :buffer)

;; fnlfmt: skip
(undo_ftplugin "setl scrolloff<"
               "sil! nun <buffer> q"
               "sil! nun <buffer> d"
               "sil! nun <buffer> s"
               "sil! nun <buffer> D"
               "sil! nun <buffer> S"
               "sil! nun <buffer> <Tab>"
               "sil! nun <buffer> <S-Tab>"
               "sil! nun <buffer> <CR>")

