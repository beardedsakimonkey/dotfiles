"
" Argument motion
"
fun! s:jumpArg(forward)
  let flags = (a:forward ? '' : 'b').'W'
  call searchpair('[({[]', ',', '[]})]', flags, 's:isCursorInStringOrComment()')
endf

fun! s:isCursorInStringOrComment()
  let syn = synIDattr(synID(line('.'), col('.'), 0), 'name')
  return syn =~? 'string' || syn =~? 'comment'
endf

nnoremap <silent> <Plug>jump_arg_prev :<c-u>call <SID>jumpArg(0)<cr>
nnoremap <silent> <Plug>jump_arg_next :<c-u>call <SID>jumpArg(1)<cr>

"
" Move line
"
fun! s:moveLine(dir, count)
  normal! m`
  execute 'move' (a:dir == 'up' ? '--' : '+').a:count
  normal! =``
  silent! call repeat#set("\<Plug>move_line_".a:dir, a:count)
endf

nnoremap <silent> <Plug>move_line_up   :<c-u>call <SID>moveLine('up', v:count1)<cr>
nnoremap <silent> <Plug>move_line_down :<c-u>call <SID>moveLine('down', v:count1)<cr>
