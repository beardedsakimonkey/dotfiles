setl fo+=tl tw=67 cc=67 syn=on

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
      \ ..'| setl fo< tw< cc<'
