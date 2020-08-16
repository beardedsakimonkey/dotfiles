aug my_reason | au! * <buffer>

    au BufWritePre <buffer> sil! call <sid>format()

    fu s:format() abort
        let view = winsaveview()
        lua vim.slp.buf.formatting_sync({}, 1000)
        winrestview(view)
    endfu

aug END

if exists("loaded_matchit")
    let b:match_ignorecase = 0
    let b:match_words = '(:),\[:\],{:},<:>,' .
                \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif

if exists("loaded_matchup")
    setlocal matchpairs=(:),{:},[:],<:>
    let b:match_words = '<\@<=\([^/][^ \t>]*\)\g{hlend}[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
    " let b:match_skip = 's:comment\|string'
endif
