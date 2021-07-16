setl grepprg&
setl iskeyword-=#

nno <buffer> <silent> gd :<c-u>call lookup#lookup()<cr>

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| setl grepprg< iskeyword<'
