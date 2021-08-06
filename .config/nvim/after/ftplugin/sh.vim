setlocal makeprg=shellcheck\ -f\ gcc\ %

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                  \ ..'| setl makeprg<'
