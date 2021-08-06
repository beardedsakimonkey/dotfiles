nno <silent> <buffer> q :<c-u>quit<cr>

setl stl=%!MyQuickfixStatusLine()

fu MyQuickfixStatusLine()
    return '%q %{printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")}'
endfu
