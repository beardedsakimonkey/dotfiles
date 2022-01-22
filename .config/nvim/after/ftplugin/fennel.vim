setl cms=;;\ %s
setl keywordprg=:help

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                                    \ ..'| setl cms< keywordprg<'
