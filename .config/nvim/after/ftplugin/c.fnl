(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (opt-local commentstring "// %s")
                    (opt-local ts 8)
                    (opt-local cinoptions "l1") ; better switch case indenting
                    (opt-local keywordprg ":vert Man") (opt-local expandtab)
                    (map n "]f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)
                    (map n "[f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer))
