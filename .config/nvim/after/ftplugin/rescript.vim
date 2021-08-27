aug my_rescript | au! * <buffer>
    au BufWritePre <buffer> sil! call s:format()

    fu s:format() abort
        let view = winsaveview()
        RescriptFormat
        winrestview(view)
    endfu
aug END

setl cms=//%s

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
