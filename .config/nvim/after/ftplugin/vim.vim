setl grepprg&
setl iskeyword-=#
setl keywordprg=:help

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| setl grepprg< iskeyword< keywordprg<'
