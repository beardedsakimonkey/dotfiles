(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

(with-undo-ftplugin (opt-local commentstring "// %s")
                    (opt-local keywordprg ":vert Man")
                    (map n "]f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)
                    (map n "[f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer))

