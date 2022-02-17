(import-macros {: opt-local : map : undo_ftplugin} :macros)

(opt-local commentstring "// %s")
(opt-local keywordprg ":vert Man")

(map n "]f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)
(map n "[f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)

(undo_ftplugin "setl cms< keywordprg<" "sil! nun <buffer> ]f"
               "sil! nun <buffer> [f")

