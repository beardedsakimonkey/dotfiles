setl cms=//\ %s
setl keywordprg=:vert\ Man

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
            \ ..'| setl cms< keywordprg<'
