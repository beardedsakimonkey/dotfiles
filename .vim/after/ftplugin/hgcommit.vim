setlocal formatoptions+=tl tw=67 cc=67 syntax=on

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
      \ ..'| setl formatoptions< tw< cc<'
