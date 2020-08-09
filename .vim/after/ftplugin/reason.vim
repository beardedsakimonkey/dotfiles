aug my_reason | au! * <buffer>
    au BufWritePre <buffer> :ReasonPrettyPrint
aug END

nno <nowait> <buffer> <silent> <cr>  :MerlinLocate<cr>
nno <nowait> <buffer>            gh  :MerlinTypeOf<cr>
nno <nowait> <buffer> <silent>   ,d  :MerlinDestruct<cr>
nno <nowait> <buffer>            ,n  :MerlinGrowEnclosing<cr>
nno <nowait> <buffer>            ,m  :MerlinShrinkEnclosing<cr>
nno <nowait> <buffer>             R  <plug>(MerlinRename)
nno <nowait> <buffer>            ,R  <plug>(MerlinRenameAppend)

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

" call matchup#util#patch_match_words(
"             \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>',
"             \ '<\@<=\([^/][^ \t>]*\)\%(>\|$\|[ \t][^>]*\%(>\|$\)\):<\@<=/\1>'
"             \)

" if matchup#util#matchpref('nolists',
"             \ get(g:, 'matchup_matchpref_html_nolists', 0))
"     call matchup#util#patch_match_words(
"                 \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>',
"                 \ '')
"     call matchup#util#patch_match_words(
"                 \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>',
"                 \ '')
" endif

" if matchup#util#matchpref('tagnameonly', 0)
"     call matchup#util#patch_match_words(
"                 \ '\)\%(',
"                 \ '\)\g{hlend}\%(')
"     call matchup#util#patch_match_words(
"                 \ ']l\>[',
"                 \ ']l\>\g{hlend}[')
"     call matchup#util#patch_match_words(
"                 \ 'dl\>',
"                 \ 'dl\>\g{hlend}')
"     call matchup#util#patch_match_words(
"                 \ '1>',
"                 \ '1\g{hlend}>')
"     call matchup#util#patch_match_words(
"                 \ ']l>',
"                 \ ']l\g{hlend}>')
"     call matchup#util#patch_match_words(
"                 \ 'dl>',
"                 \ 'dl\g{hlend}>')
" endif
