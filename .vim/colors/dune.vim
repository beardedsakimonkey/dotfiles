hi clear
set background=light 

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'dune'

" hi WarningMsg ctermfg=Red      ctermbg=White cterm=bold
" hi ErrorMsg   ctermfg=White    ctermbg=Red
" hi Todo       ctermfg=8        ctermbg=none  cterm=bold
" hi NonText    ctermbg=LightGray
" hi Visual     ctermfg=black    ctermbg=76
" hi Comment    ctermfg=8
" hi LineNr     ctermfg=8
" hi Statement  ctermfg=DarkBlue cterm=bold
" hi String     ctermfg=DarkGreen
" hi Type       ctermfg=Magenta
" hi Constant   ctermfg=DarkMagenta
" hi Identifier ctermfg=Blue
" hi Function   ctermfg=Black
" hi Special    ctermfg=Cyan
" hi PreProc    ctermfg=DarkRed
" hi StatusLine cterm=reverse
" hi MatchParen ctermbg=51
" hi Directory  ctermfg=Blue

" hi User1 ctermfg=Red   ctermbg=Black cterm=bold
" hi User2 ctermfg=Black ctermbg=76
" hi User3 ctermfg=Green ctermbg=Black
" hi User4 ctermfg=Red   ctermbg=Black
" hi User5 ctermfg=grey  ctermbg=Black
" hi User6 ctermfg=Red   ctermbg=Black

hi Normal       guifg=black        guibg=#CDCABD
hi NonText      guifg=none         guibg=#C5C2B5
hi Visual       guifg=fg           guibg=palegreen3 gui=none
hi Search       guifg=none         guibg=LightBlue
hi IncSearch    guifg=fg           guibg=yellow2    gui=none
hi WarningMsg   guifg=red3         guibg=white      gui=bold
hi PreProc      guifg=DeepPink4    guibg=none       gui=none
hi Comment      guifg=burlywood4   guibg=none       gui=none
hi Identifier   guifg=blue3        guibg=none       gui=none
hi Function     gui=none           guifg=black
hi LineNr       guifg=burlywood4
hi Statement    guifg=MidnightBlue guibg=none       gui=bold
hi Type         guifg=#6D16BD      guibg=none       gui=none
hi Constant     guifg=#BD00BD      guibg=none       gui=none
hi Special      guifg=DodgerBlue4  guibg=none       gui=none
hi String       guifg=DarkGreen    guibg=none       gui=none
hi StatusLine   guifg=#CDCABD      guibg=black      gui=none
hi StatusLineNC guifg=#CDCABD      guibg=gray       gui=none
hi Directory    guifg=blue3        guibg=none       gui=bold
hi SignColumn   guifg=none         guibg=#c9c5b5
hi Todo         guifg=burlywood4   guibg=none       gui=bold

hi DiffAdd    guifg=DarkGreen guibg=none
hi DiffChange guifg=DeepPink4 guibg=none
hi DiffDelete guifg=red3      guibg=none

hi SignifySignAdd             guifg=DarkGreen guibg=#c9c5b5
hi SignifySignChange          guifg=DeepPink4 guibg=#c9c5b5
hi SignifySignDelete          guifg=red3      guibg=#c9c5b5
hi SignifySignDeleteFirstLine guifg=red3      guibg=#c9c5b5

hi! link SpecialKey Directory

hi User1 guifg=red        guibg=black gui=bold
hi User2 guifg=black      guibg=palegreen3
hi User3 guifg=lawngreen  guibg=black
hi User4 guifg=red        guibg=black
hi User5 guifg=grey       guibg=black
hi User6 guifg=IndianRed2 guibg=black

hi LspDiagnosticsVirtualTextError       guifg=red3
hi LspDiagnosticsVirtualTextWarning     guifg=orange3
hi LspDiagnosticsVirtualTextInformation guifg=orchid
hi LspDiagnosticsVirtualTextHint        guifg=orchid

hi LspDiagnosticsUnderlineError       guibg=#ffd7ff
hi LspDiagnosticsUnderlineWarning     guibg=#ffd787
hi LspDiagnosticsUnderlineInformation guibg=#ffd787
hi LspDiagnosticsUnderlineHint        guibg=#ffd787
