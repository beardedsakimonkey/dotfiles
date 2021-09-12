" Color shorthands: $VIMRUNTIME/rgb.txt

hi clear
set background=light 

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'dune'

hi Normal       guifg=black        guibg=#CDCABD
hi NonText      guifg=none         guibg=#C5C2B5
hi Visual       guifg=fg           guibg=OliveDrab2 gui=none
hi Search       guifg=none         guibg=PaleTurquoise
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
hi Directory    guifg=blue3        guibg=none       gui=none
hi SignColumn   guifg=none         guibg=#c9c5b5
hi Todo         guifg=burlywood4   guibg=none       gui=bold

hi StatusLine   guifg=#CDCABD      guibg=MistyRose4   gui=none
hi StatusLineNC guifg=#CDCABD      guibg=gray64       gui=none
hi TabLineFill                     guibg=MistyRose4   gui=none
hi VertSplit    guifg=#CDCABD      guibg=MistyRose4   gui=none

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

hi User1 guifg=AntiqueWhite2  guibg=MistyRose4 gui=bold
hi User2 guifg=black          guibg=OliveDrab2
hi User3 guifg=lawngreen      guibg=MistyRose4
hi User4 guifg=AntiqueWhite2  guibg=MistyRose4
hi User5 guifg=grey           guibg=MistyRose4
hi User6 guifg=#CDCABD        guibg=MistyRose4 gui=bold
hi User7 guifg=#CDCABD        guibg=MistyRose4 gui=bold
hi User8 guifg=AntiqueWhite2  guibg=MistyRose4 gui=bold

hi LspDiagnosticsVirtualTextError       guifg=red3
hi LspDiagnosticsVirtualTextWarning     guifg=orange3
hi LspDiagnosticsVirtualTextInformation guifg=orchid
hi LspDiagnosticsVirtualTextHint        guifg=orchid

hi LspDiagnosticsUnderlineError       guibg=#ffd7ff
hi LspDiagnosticsUnderlineWarning     guibg=#ffd787
hi LspDiagnosticsUnderlineInformation guibg=#ffd787
hi LspDiagnosticsUnderlineHint        guibg=#ffd787

hi! link FennelParen  Comment
hi! link FennelSymbol Normal

" hi! link TSProperty String
