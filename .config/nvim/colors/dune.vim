" Color shorthands: $VIMRUNTIME/rgb.txt

hi clear
set background=light 

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'dune'

hi Normal     guifg=Black        guibg=#CDCABD
hi NonText    guifg=none         guibg=#C5C2B5
hi Visual     guifg=fg           guibg=OliveDrab2 gui=none
hi Search     guifg=none         guibg=#ffd787 
hi IncSearch  guifg=White        guibg=#BD00BD    gui=none
hi WarningMsg guifg=Red4         guibg=none       gui=bold
hi ErrorMsg   guifg=White        guibg=IndianRed3
hi PreProc    guifg=DeepPink4    guibg=none       gui=none
hi Comment    guifg=Burlywood4   guibg=none       gui=none
hi Identifier guifg=Blue3        guibg=none       gui=none
hi Function   gui=none           guifg=Black
hi LineNr     guifg=Burlywood4
hi Statement  guifg=MidnightBlue guibg=none       gui=bold
hi Type       guifg=#6D16BD      guibg=none       gui=none
hi Constant   guifg=#BD00BD      guibg=none       gui=none
hi Special    guifg=DodgerBlue4  guibg=none       gui=none
hi String     guifg=DarkGreen    guibg=none       gui=none
hi Directory  guifg=Blue3        guibg=none       gui=none
hi SignColumn guifg=none         guibg=#c9c5b5
hi Todo       guifg=Burlywood4   guibg=none       gui=bold
hi MatchParen guifg=none         guibg=PaleTurquoise
hi Title      guifg=DeepPink4    gui=bold
hi CursorLine guibg=#ccc5b5

hi! link CursorLineNr LineNr

hi StatusLine   guifg=#CDCABD    guibg=MistyRose4 gui=none
hi StatusLineNC guifg=#CDCABD    guibg=#b2a99d    gui=none
hi TabLineFill  guibg=MistyRose4 gui=none
hi VertSplit    guifg=#CDCABD    guibg=MistyRose4 gui=none

hi Pmenu    guibg=#e5daa5
hi PmenuSel guibg=LightGoldenrod3

hi DiffAdd    guifg=none guibg=#c6ddb1
hi DiffChange guifg=none guibg=#dbd09d
hi DiffText   guifg=none guibg=#f4dc6e
hi DiffDelete guifg=none guibg=#dda296

hi! link SpecialKey Directory

hi User1 guifg=AntiqueWhite2 guibg=MistyRose4 gui=bold
hi User2 guifg=Black         guibg=OliveDrab2
hi User3 guifg=Red3          guibg=MistyRose4
hi User4 guifg=Orange3       guibg=MistyRose4
hi User5 guifg=Grey          guibg=MistyRose4
hi User6 guifg=#CDCABD       guibg=MistyRose4 gui=bold
hi User7 guifg=#CDCABD       guibg=MistyRose4
hi User8 guifg=AntiqueWhite2 guibg=MistyRose4 gui=bold

hi DiagnosticError guifg=Red3
hi DiagnosticWarn  guifg=Orange3
hi DiagnosticInfo  guifg=Orchid
hi DiagnosticHint  guifg=Orchid

hi DiagnosticUnderlineError guibg=#dda296 gui=underline
hi DiagnosticUnderlineWarn  guibg=#e5daa5 gui=underline
hi DiagnosticUnderlineInfo  guibg=#dbd09d gui=underline
hi DiagnosticUnderlineHint  guibg=#dbd09d gui=underline

hi DiagnosticSignError guibg=#c9c5b5 guifg=Red3
hi DiagnosticSignWarn  guibg=#c9c5b5 guifg=Orange3
hi DiagnosticSignInfo  guibg=#c9c5b5 guifg=Orchid
hi DiagnosticSignHint  guibg=#c9c5b5 guifg=Orchid

sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn  text=● texthl=DiagnosticSignWarn  linehl= numhl=
sign define DiagnosticSignInfo  text=● texthl=DiagnosticSignInfo  linehl= numhl=
sign define DiagnosticSignHint  text=● texthl=DiagnosticSignHint  linehl= numhl=

hi! link FennelParen  Comment
hi FennelSymbol guifg=Black

hi! link UdirDirectory  Directory
hi! link UdirSymlink    Constant
hi! link UdirExecutable PreProc
hi! link UdirVirtText   Comment

hi! link TSConstBuiltin Constant

hi! link markdownH1 Title
hi! link markdownH2 Statement
