(import-macros {: opt-local : no : undo_ftplugin} :macros)

(opt-local commentstring "// %s")
(opt-local keywordprg ":vert Man")

(no n "]h" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)
(no n "[h" :<Cmd>ClangdSwitchSourceHeader<CR> :buffer)

(undo_ftplugin "setl cms< keywordprg<" "sil! nun <buffer> ]h"
               "sil! nun <buffer> [h")

