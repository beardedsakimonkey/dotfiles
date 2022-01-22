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

" hi CursorLine   guibg=AntiqueWhite3
hi CursorLine   guibg=#ccc5b5
hi! link CursorLineNr LineNr

hi StatusLine   guifg=#CDCABD      guibg=MistyRose4   gui=none
hi StatusLineNC guifg=#CDCABD      guibg=#b2a99d       gui=none
hi TabLineFill                     guibg=MistyRose4   gui=none
hi VertSplit    guifg=#CDCABD      guibg=MistyRose4   gui=none

hi DiffAdd    guifg=none guibg=#c6ddb1
hi DiffChange guifg=none guibg=#dbd09d
hi DiffText   guifg=none guibg=#f4dc6e
hi DiffDelete guifg=none guibg=#dda296

hi! link SpecialKey Directory

hi User1 guifg=AntiqueWhite2  guibg=MistyRose4 gui=bold
hi User2 guifg=black          guibg=OliveDrab2
hi User3 guifg=red3      guibg=MistyRose4
hi User4 guifg=orange3  guibg=MistyRose4
hi User5 guifg=grey           guibg=MistyRose4
hi User6 guifg=#CDCABD        guibg=MistyRose4 gui=bold
hi User7 guifg=#CDCABD        guibg=MistyRose4
hi User8 guifg=AntiqueWhite2  guibg=MistyRose4 gui=bold

hi DiagnosticError  guifg=red3
hi DiagnosticWarn   guifg=orange3
hi DiagnosticInfo   guifg=orchid
hi DiagnosticHint   guifg=orchid

hi DiagnosticUnderlineError       guibg=#ffd7ff
hi DiagnosticUnderlineWarning     guibg=#ffd787
hi DiagnosticUnderlineInformation guibg=#ffd787
hi DiagnosticUnderlineHint        guibg=#ffd787

hi! link FennelParen  Comment
hi FennelSymbol guifg=black

hi! link javaScriptNumber Constant

" hi! link TSProperty String
