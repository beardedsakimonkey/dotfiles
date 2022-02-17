(import-macros {: opt-local : no : undo_ftplugin} :macros)

(opt-local commentstring "// %s")
(opt-local keywordprg ":vert Man")

(no n "]f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)
(no n "[f" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)

(undo_ftplugin "setl cms< keywordprg<" "sil! nun <buffer> ]f"
               "sil! nun <buffer> [f")

