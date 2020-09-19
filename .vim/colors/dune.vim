hi clear
set background=light 

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'dune'

hi Normal     guibg=#CDCABD      guifg=black
hi NonText    guibg=#C5C2B5
hi Visual     guibg=palegreen3   guifg=fg   gui=none
hi Search     guibg=LightBlue
hi IncSearch  guibg=yellow2      guifg=fg   gui=none
hi WarningMsg guibg=white        guifg=red3 gui=bold
hi PreProc    guifg=DeepPink4    gui=none
hi Comment    guifg=burlywood4   gui=none
hi Identifier guifg=blue3        gui=none
hi Function   gui=none           guifg=black
hi LineNr     guifg=burlywood4
hi Statement  guifg=MidnightBlue gui=bold   
hi Type       guifg=#6D16BD      gui=none
hi Constant   guifg=#BD00BD      gui=none
hi Special    guifg=DodgerBlue4  gui=none
hi String     guifg=DarkGreen    gui=none
hi StatusLine   guifg=#CDCABD guibg=black gui=none
hi StatusLineNC guifg=#CDCABD guibg=gray gui=none

hi! link SpecialKey Identifier
hi! link Directory  Identifier

hi User1 guifg=red       guibg=black gui=bold
hi User2 guifg=black     guibg=palegreen3
hi User3 guifg=green     guibg=black
hi User4 guifg=red       guibg=black
hi User5 guifg=grey      guibg=black
hi User6 guifg=IndianRed2 guibg=black
