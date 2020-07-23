setl grepprg&
setl iskeyword-=#

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| setl grepprg< iskeyword<'
