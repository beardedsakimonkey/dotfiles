setl statusline=\ %f

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                                    \ ..'| setl statusline<'