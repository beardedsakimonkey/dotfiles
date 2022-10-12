(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (opt-local scrolloff 0)
                    (map n :q :<Cmd>q<CR> :buffer)
                    ;; Adapted from gpanders' config
                    (map n :u :<C-u> :buffer :nowait)
                    (map n :d :<C-d> :buffer :nowait)
                    (map n :U :<C-b> :buffer :nowait)
                    (map n :D :<C-f> :buffer :nowait)
                    (map n :<Tab> "<Cmd>call search('\\v[\\|\\*]\\S{-}[\\|\\*]')<CR>"
                         :buffer :silent)
                    (map n :<S-Tab>
                         "<Cmd>call search('\\v[\\|\\*]\\S{-}[\\|\\*]', 'b')<CR>" :buffer
                         :silent)
                    (map n :<CR> "g<C-]>" :buffer))
