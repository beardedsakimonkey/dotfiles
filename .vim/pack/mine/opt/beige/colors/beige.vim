" Name:         Beige
" Author:       Myself <myself@somewhere.org>
" Maintainer:   Myself
" License:      Vim License (see `:help license`)
" Last Updated: Thu Jul 16 20:56:19 2020

" Generated by Colortemplate v2.0.0

set background=light

hi clear
if exists('syntax_on')
syntax reset
endif

let g:colors_name = 'beige'

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2
let s:italics = (&t_ZH != '' && &t_ZH != '[7m') || has('gui_running') || has('nvim')

hi! link QuickFixLine Search
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link Boolean Constant
hi! link Character Constant
hi! link Conditional Statement
hi! link Define PreProc
hi! link Debug Special
hi! link Delimiter Special
hi! link Exception Statement
hi! link Float Constant
hi! link Function Identifier
hi! link Include PreProc
hi! link Keyword Statement
hi! link Label Statement
hi! link Macro PreProc
hi! link Number Constant
hi! link Operator Statement
hi! link PreCondit PreProc
hi! link Repeat Statement
hi! link SpecialChar Special
hi! link SpecialComment Special
hi! link StorageClass Type
hi! link String Constant
hi! link Structure Type
hi! link Tag Special
hi! link Typedef Type
hi! link NormalFloat Pmenu

if (has('termguicolors') && &termguicolors) || has('gui_running')
let g:terminal_ansi_colors = ['#111111', '#e8503f', '#5F5F00', '#d87900',
    \ '#005F87', '#63001C', '#159ccc', '#BBBBBB', '#111111', '#d87900',
    \ '#BBFFAA', '#e1ad0b', '#538192', '#63001C', '#23bce1', '#fafafa']
    if has('nvim')
    let g:terminal_color_0 = '#111111'
    let g:terminal_color_1 = '#e8503f'
    let g:terminal_color_2 = '#5F5F00'
    let g:terminal_color_3 = '#d87900'
    let g:terminal_color_4 = '#005F87'
    let g:terminal_color_5 = '#63001C'
    let g:terminal_color_6 = '#159ccc'
    let g:terminal_color_7 = '#BBBBBB'
    let g:terminal_color_8 = '#111111'
    let g:terminal_color_9 = '#d87900'
    let g:terminal_color_10 = '#BBFFAA'
    let g:terminal_color_11 = '#e1ad0b'
    let g:terminal_color_12 = '#538192'
    let g:terminal_color_13 = '#63001C'
    let g:terminal_color_14 = '#23bce1'
    let g:terminal_color_15 = '#fafafa'
    endif
    hi Normal guifg=#111111 guibg=#d8c79b guisp=NONE gui=NONE cterm=NONE
    hi CursorLine guifg=NONE guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi CursorLineNr guifg=#d87900 guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi Folded guifg=#111111 guibg=#BBBBBB guisp=NONE gui=italic cterm=italic
    hi LineNr guifg=#111111 guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi FoldColumn guifg=#111111 guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi Terminal guifg=#111111 guibg=#fafafa guisp=NONE gui=NONE cterm=NONE
    hi ColorColumn guifg=NONE guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi Conceal guifg=#5F5F00 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
    hi CursorColumn guifg=NONE guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi DiffAdd guifg=#BBFFAA guibg=#111111 guisp=NONE gui=reverse cterm=reverse
    hi DiffChange guifg=#d87900 guibg=#fafafa guisp=NONE gui=reverse cterm=reverse
    hi DiffDelete guifg=#e8503f guibg=#fafafa guisp=NONE gui=reverse cterm=reverse
    hi DiffText guifg=#159ccc guibg=#fafafa guisp=NONE gui=bold,reverse cterm=bold,reverse
    hi Directory guifg=#5F5F00 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi EndOfBuffer guifg=#d87900 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi ErrorMsg guifg=#e8503f guibg=#fafafa guisp=NONE gui=reverse cterm=reverse
    hi IncSearch guifg=#d87900 guibg=#fafafa guisp=NONE gui=standout cterm=standout
    hi MatchParen guifg=NONE guibg=NONE guisp=#111111 gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi ModeMsg guifg=#111111 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi MoreMsg guifg=#d87900 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi NonText guifg=#111111 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Pmenu guifg=#111111 guibg=#BBBBBB guisp=NONE gui=NONE cterm=NONE
    hi PmenuSbar guifg=#d87900 guibg=#111111 guisp=NONE gui=NONE cterm=NONE
    hi PmenuSel guifg=#fafafa guibg=#d87900 guisp=NONE gui=NONE cterm=NONE
    hi PmenuThumb guifg=#e8503f guibg=#d87900 guisp=NONE gui=NONE cterm=NONE
    hi Question guifg=#111111 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Search guifg=#e1ad0b guibg=#fafafa guisp=NONE gui=reverse cterm=reverse
    hi SignColumn guifg=#d87900 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpecialKey guifg=#d87900 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpellBad guifg=#63001C guibg=NONE guisp=#111111 gui=undercurl cterm=undercurl
    hi SpellCap guifg=#63001C guibg=NONE guisp=#111111 gui=undercurl cterm=undercurl
    hi SpellLocal guifg=#63001C guibg=NONE guisp=#111111 gui=undercurl cterm=undercurl
    hi SpellRare guifg=#63001C guibg=NONE guisp=#111111 gui=undercurl cterm=undercurl
    hi Title guifg=#d87900 guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Visual guifg=#005F87 guibg=#fafafa guisp=NONE gui=reverse cterm=reverse
    hi VisualNOS guifg=#fafafa guibg=#005F87 guisp=NONE gui=NONE cterm=NONE
    hi WarningMsg guifg=#e8503f guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Boolean guifg=#BBFFAA guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Character guifg=#63001C guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Comment guifg=#111111 guibg=NONE guisp=NONE gui=italic cterm=italic
    hi Constant guifg=#5F5F00 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Debug guifg=#63001C guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Delimiter guifg=#005F87 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Error guifg=#e8503f guibg=#fafafa guisp=NONE gui=reverse cterm=reverse
    hi Float guifg=#BBFFAA guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Function guifg=#5F5F00 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Identifier guifg=#005F87 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Ignore guifg=#d87900 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Include guifg=#538192 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Keyword guifg=#159ccc guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Label guifg=#5F5F00 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Number guifg=#5F5F00 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Operator guifg=#159ccc guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi PreProc guifg=#e8503f guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Special guifg=#e8503f guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpecialChar guifg=#63001C guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi SpecialComment guifg=#63001C guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Statement guifg=#159ccc guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi StorageClass guifg=#159ccc guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi String guifg=#d87900 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Structure guifg=#e8503f guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Todo guifg=#63001C guibg=NONE guisp=NONE gui=bold cterm=bold
    hi Type guifg=#538192 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Underlined guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
    if !s:italics
    hi Folded gui=NONE cterm=NONE
    hi Comment gui=NONE cterm=NONE
    endif
    unlet s:t_Co s:italics
    finish
    endif

    if s:t_Co >= 256
    hi Normal ctermfg=59 ctermbg=59 cterm=NONE
    hi CursorLine ctermfg=NONE ctermbg=255 cterm=NONE
    hi CursorLineNr ctermfg=172 ctermbg=255 cterm=NONE
    hi Folded ctermfg=102 ctermbg=255 cterm=italic
    hi LineNr ctermfg=102 ctermbg=255 cterm=NONE
    hi FoldColumn ctermfg=102 ctermbg=255 cterm=NONE
    hi Terminal ctermfg=59 ctermbg=231 cterm=NONE
    hi ColorColumn ctermfg=NONE ctermbg=255 cterm=NONE
    hi Conceal ctermfg=30 ctermbg=NONE cterm=NONE
    hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
    hi CursorColumn ctermfg=NONE ctermbg=255 cterm=NONE
    hi DiffAdd ctermfg=143 ctermbg=59 cterm=reverse
    hi DiffChange ctermfg=172 ctermbg=231 cterm=reverse
    hi DiffDelete ctermfg=167 ctermbg=231 cterm=reverse
    hi DiffText ctermfg=74 ctermbg=231 cterm=bold,reverse
    hi Directory ctermfg=30 ctermbg=NONE cterm=NONE
    hi EndOfBuffer ctermfg=172 ctermbg=NONE cterm=NONE
    hi ErrorMsg ctermfg=167 ctermbg=231 cterm=reverse
    hi IncSearch ctermfg=172 ctermbg=231 cterm=reverse
    hi MatchParen ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi ModeMsg ctermfg=59 ctermbg=NONE cterm=NONE
    hi MoreMsg ctermfg=172 ctermbg=NONE cterm=NONE
    hi NonText ctermfg=102 ctermbg=NONE cterm=NONE
    hi Pmenu ctermfg=59 ctermbg=255 cterm=NONE
    hi PmenuSbar ctermfg=172 ctermbg=102 cterm=NONE
    hi PmenuSel ctermfg=231 ctermbg=172 cterm=NONE
    hi PmenuThumb ctermfg=167 ctermbg=172 cterm=NONE
    hi Question ctermfg=59 ctermbg=NONE cterm=NONE
    hi Search ctermfg=178 ctermbg=231 cterm=reverse
    hi SignColumn ctermfg=172 ctermbg=NONE cterm=NONE
    hi SpecialKey ctermfg=172 ctermbg=NONE cterm=NONE
    hi SpellBad ctermfg=197 ctermbg=NONE cterm=underline
    hi SpellCap ctermfg=197 ctermbg=NONE cterm=underline
    hi SpellLocal ctermfg=197 ctermbg=NONE cterm=underline
    hi SpellRare ctermfg=197 ctermbg=NONE cterm=underline
    hi Title ctermfg=172 ctermbg=NONE cterm=bold
    hi Visual ctermfg=66 ctermbg=231 cterm=reverse
    hi VisualNOS ctermfg=231 ctermbg=66 cterm=NONE
    hi WarningMsg ctermfg=167 ctermbg=NONE cterm=NONE
    hi Boolean ctermfg=143 ctermbg=NONE cterm=NONE
    hi Character ctermfg=197 ctermbg=NONE cterm=NONE
    hi Comment ctermfg=102 ctermbg=NONE cterm=italic
    hi Constant ctermfg=30 ctermbg=NONE cterm=NONE
    hi Debug ctermfg=197 ctermbg=NONE cterm=NONE
    hi Delimiter ctermfg=66 ctermbg=NONE cterm=NONE
    hi Error ctermfg=167 ctermbg=231 cterm=reverse
    hi Float ctermfg=143 ctermbg=NONE cterm=NONE
    hi Function ctermfg=30 ctermbg=NONE cterm=NONE
    hi Identifier ctermfg=66 ctermbg=NONE cterm=NONE
    hi Ignore ctermfg=172 ctermbg=NONE cterm=NONE
    hi Include ctermfg=97 ctermbg=NONE cterm=NONE
    hi Keyword ctermfg=74 ctermbg=NONE cterm=NONE
    hi Label ctermfg=30 ctermbg=NONE cterm=NONE
    hi Number ctermfg=30 ctermbg=NONE cterm=NONE
    hi Operator ctermfg=74 ctermbg=NONE cterm=NONE
    hi PreProc ctermfg=167 ctermbg=NONE cterm=NONE
    hi Special ctermfg=167 ctermbg=NONE cterm=NONE
    hi SpecialChar ctermfg=197 ctermbg=NONE cterm=NONE
    hi SpecialComment ctermfg=197 ctermbg=NONE cterm=NONE
    hi Statement ctermfg=74 ctermbg=NONE cterm=NONE
    hi StorageClass ctermfg=74 ctermbg=NONE cterm=NONE
    hi String ctermfg=172 ctermbg=NONE cterm=NONE
    hi Structure ctermfg=167 ctermbg=NONE cterm=NONE
    hi Todo ctermfg=197 ctermbg=NONE cterm=bold
    hi Type ctermfg=97 ctermbg=NONE cterm=NONE
    hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline
    if !s:italics
    hi Folded cterm=NONE
    hi Comment cterm=NONE
    endif
    unlet s:t_Co s:italics
    finish
    endif

    if s:t_Co >= 8
    hi Normal ctermfg=Black ctermbg=White cterm=NONE
    hi CursorLine ctermfg=NONE ctermbg=Gray cterm=NONE
    hi CursorLineNr ctermfg=Red ctermbg=Gray cterm=NONE
    hi Folded ctermfg=DarkGray ctermbg=Gray cterm=italic
    hi LineNr ctermfg=DarkGray ctermbg=Gray cterm=NONE
    hi FoldColumn ctermfg=DarkGray ctermbg=Gray cterm=NONE
    hi Terminal ctermfg=Black ctermbg=White cterm=NONE
    hi ColorColumn ctermfg=NONE ctermbg=Gray cterm=NONE
    hi Conceal ctermfg=DarkGreen ctermbg=NONE cterm=NONE
    hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
    hi CursorColumn ctermfg=NONE ctermbg=Gray cterm=NONE
    hi DiffAdd ctermfg=Green ctermbg=Black cterm=reverse
    hi DiffChange ctermfg=DarkYellow ctermbg=White cterm=reverse
    hi DiffDelete ctermfg=DarkRed ctermbg=White cterm=reverse
    hi DiffText ctermfg=DarkCyan ctermbg=White cterm=bold,reverse
    hi Directory ctermfg=DarkGreen ctermbg=NONE cterm=NONE
    hi EndOfBuffer ctermfg=Red ctermbg=NONE cterm=NONE
    hi ErrorMsg ctermfg=DarkRed ctermbg=White cterm=reverse
    hi IncSearch ctermfg=Red ctermbg=White cterm=reverse
    hi MatchParen ctermfg=NONE ctermbg=NONE cterm=bold,underline
    hi ModeMsg ctermfg=Black ctermbg=NONE cterm=NONE
    hi MoreMsg ctermfg=Red ctermbg=NONE cterm=NONE
    hi NonText ctermfg=DarkGray ctermbg=NONE cterm=NONE
    hi Pmenu ctermfg=Black ctermbg=Gray cterm=NONE
    hi PmenuSbar ctermfg=Red ctermbg=DarkGray cterm=NONE
    hi PmenuSel ctermfg=White ctermbg=Red cterm=NONE
    hi PmenuThumb ctermfg=DarkRed ctermbg=Red cterm=NONE
    hi Question ctermfg=Black ctermbg=NONE cterm=NONE
    hi Search ctermfg=Yellow ctermbg=White cterm=reverse
    hi SignColumn ctermfg=Red ctermbg=NONE cterm=NONE
    hi SpecialKey ctermfg=Red ctermbg=NONE cterm=NONE
    hi SpellBad ctermfg=DarkMagenta ctermbg=NONE cterm=underline
    hi SpellCap ctermfg=DarkMagenta ctermbg=NONE cterm=underline
    hi SpellLocal ctermfg=DarkMagenta ctermbg=NONE cterm=underline
    hi SpellRare ctermfg=DarkMagenta ctermbg=NONE cterm=underline
    hi Title ctermfg=Red ctermbg=NONE cterm=bold
    hi Visual ctermfg=DarkBlue ctermbg=White cterm=reverse
    hi VisualNOS ctermfg=White ctermbg=DarkBlue cterm=NONE
    hi WarningMsg ctermfg=DarkRed ctermbg=NONE cterm=NONE
    hi Boolean ctermfg=Green ctermbg=NONE cterm=NONE
    hi Character ctermfg=DarkMagenta ctermbg=NONE cterm=NONE
    hi Comment ctermfg=DarkGray ctermbg=NONE cterm=italic
    hi Constant ctermfg=DarkGreen ctermbg=NONE cterm=NONE
    hi Debug ctermfg=DarkMagenta ctermbg=NONE cterm=NONE
    hi Delimiter ctermfg=DarkBlue ctermbg=NONE cterm=NONE
    hi Error ctermfg=DarkRed ctermbg=White cterm=reverse
    hi Float ctermfg=Green ctermbg=NONE cterm=NONE
    hi Function ctermfg=DarkGreen ctermbg=NONE cterm=NONE
    hi Identifier ctermfg=DarkBlue ctermbg=NONE cterm=NONE
    hi Ignore ctermfg=DarkYellow ctermbg=NONE cterm=NONE
    hi Include ctermfg=Blue ctermbg=NONE cterm=NONE
    hi Keyword ctermfg=DarkCyan ctermbg=NONE cterm=NONE
    hi Label ctermfg=DarkGreen ctermbg=NONE cterm=NONE
    hi Number ctermfg=DarkGreen ctermbg=NONE cterm=NONE
    hi Operator ctermfg=DarkCyan ctermbg=NONE cterm=NONE
    hi PreProc ctermfg=DarkRed ctermbg=NONE cterm=NONE
    hi Special ctermfg=DarkRed ctermbg=NONE cterm=NONE
    hi SpecialChar ctermfg=DarkMagenta ctermbg=NONE cterm=NONE
    hi SpecialComment ctermfg=DarkMagenta ctermbg=NONE cterm=NONE
    hi Statement ctermfg=DarkCyan ctermbg=NONE cterm=NONE
    hi StorageClass ctermfg=DarkCyan ctermbg=NONE cterm=NONE
    hi String ctermfg=Red ctermbg=NONE cterm=NONE
    hi Structure ctermfg=DarkRed ctermbg=NONE cterm=NONE
    hi Todo ctermfg=DarkMagenta ctermbg=NONE cterm=bold
    hi Type ctermfg=Blue ctermbg=NONE cterm=NONE
    hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline
    if !s:italics
    hi Folded cterm=NONE
    hi Comment cterm=NONE
    endif
    unlet s:t_Co s:italics
    finish
    endif

    " Background: light
    " Color: bg0           #d8c79b     59           White
    " Color: black         #111111     59           Black
    " Color: red           rgb(232,  80,  63)     167          DarkRed
    " Color: green         #5F5F00     30           DarkGreen
    " Color: yellow        rgb(216, 121,   0)     172          DarkYellow
    " Color: blue          #005F87     66           DarkBlue
    " Color: magenta       #63001C     197          DarkMagenta
    " Color: cyan          rgb( 21, 156, 204)     74           DarkCyan
    " Color: white         #BBBBBB     255          Gray
    " Color: brightblack   #111111     102          DarkGray
    " Color: brightred     rgb(216, 121,   0)     172          Red
    " Color: brightgreen   #BBFFAA     143          Green
    " Color: brightyellow  rgb(225, 173,  11)     178          Yellow
    " Color: brightblue    #538192     97           Blue
    " Color: brightmagenta #63001C     197          Magenta
    " Color: brightcyan    rgb( 35, 188, 225)     38           Cyan
    " Color: brightwhite   rgb(250, 250, 250)     231          White
    " Term Colors: black red green yellow blue magenta cyan white
    " Term Colors: brightblack brightred brightgreen brightyellow
    " Term Colors: brightblue brightmagenta brightcyan brightwhite
    " vim: et ts=2 sw=2
