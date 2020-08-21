setl scrolloff=0
nno <buffer> q :<c-u>q<cr>

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                  \ ..'| setl scrolloff<'
