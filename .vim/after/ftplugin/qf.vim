nnoremap <silent> <buffer> q :<c-u>quit<cr>

setlocal statusline=%!MyQuickfixStatusLine()

fun! MyQuickfixStatusLine()
  return '%q %{printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")}'
endf
