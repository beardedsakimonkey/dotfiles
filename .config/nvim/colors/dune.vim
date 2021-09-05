" Color shorthands: $VIMRUNTIME/rgb.txt

hi clear
set background=light 

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'dune'

hi Normal       guifg=black        guibg=#CDCABD
hi NonText      guifg=none         guibg=#C5C2B5
hi Visual       guifg=fg           guibg=palegreen3 gui=none
hi Search       guifg=none         guibg=LightBlue
hi IncSearch    guifg=fg           guibg=yellow2    gui=none
hi WarningMsg   guifg=red4         guibg=white      gui=bold
hi ErrorMsg     guifg=White        guibg=IndianRed3
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
hi Directory    guifg=blue3        guibg=none       gui=none
hi SignColumn   guifg=none         guibg=#c9c5b5
hi Todo         guifg=burlywood4   guibg=none       gui=bold

hi DiffAdd    guifg=none guibg=#c6ddb1
hi DiffChange guifg=none guibg=#dbd09d
hi DiffText   guifg=none guibg=#f4dc6e
hi DiffDelete guifg=none guibg=#dda296

hi DiffviewFilePanelCounter    guifg=DodgerBlue4 gui=bold
hi DiffviewFilePanelFileName   guifg=black       gui=bold
hi DiffviewFilePanelInsertions guifg=green       gui=bold
hi DiffviewFilePanelDeletions  guifg=IndianRed3  gui=bold
hi DiffviewStatusModified      guifg=burlywood4

" hi SignifySignAdd             guifg=DarkGreen guibg=#c9c5b5
" hi SignifySignChange          guifg=DeepPink4 guibg=#c9c5b5
" hi SignifySignDelete          guifg=red3      guibg=#c9c5b5
" hi SignifySignDeleteFirstLine guifg=red3      guibg=#c9c5b5

hi! link SpecialKey Directory

hi User1 guifg=red        guibg=black gui=bold
hi User2 guifg=black      guibg=palegreen3
hi User3 guifg=lawngreen  guibg=black
hi User4 guifg=red        guibg=black
hi User5 guifg=grey       guibg=black
hi User6 guifg=IndianRed2 guibg=black gui=bold
hi User7 guifg=#CDCABD    guibg=black gui=bold

hi LspDiagnosticsVirtualTextError       guifg=red3
hi LspDiagnosticsVirtualTextWarning     guifg=orange3
hi LspDiagnosticsVirtualTextInformation guifg=orchid
hi LspDiagnosticsVirtualTextHint        guifg=orchid

hi LspDiagnosticsUnderlineError       guibg=#ffd7ff
hi LspDiagnosticsUnderlineWarning     guibg=#ffd787
hi LspDiagnosticsUnderlineInformation guibg=#ffd787
hi LspDiagnosticsUnderlineHint        guibg=#ffd787
