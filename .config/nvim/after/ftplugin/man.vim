nno <silent> <buffer> q :<c-u>lclose<bar>q<cr>
nno <silent> <buffer> <cr> <c-]>
setl keywordprg=:help

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                                    \ ..'| setl keywordprg<'
