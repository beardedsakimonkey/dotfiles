" Name:         Gruvburn
" Author:       Myself <myself@somewhere.org>
" Maintainer:   Myself <myself@somewhere.org>
" License:      Vim License (see `:help license`)
" Last Updated: Thu Jun  4 17:56:52 2020

" Generated by Colortemplate v2.0.0

set background=dark

hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'gruvburn'

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2

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
  let g:terminal_ansi_colors = ['#32302f', '#ea6962', '#a8a920', '#d8a657',
        \ '#83a598', '#d3869b', '#8bba7f', '#bfa472', '#32302f', '#ea6962',
        \ '#a8a920', '#d8a657', '#83a598', '#d3869b', '#8bba7f', '#bfa472']
  if has('nvim')
    let g:terminal_color_0 = '#32302f'
    let g:terminal_color_1 = '#ea6962'
    let g:terminal_color_2 = '#a8a920'
    let g:terminal_color_3 = '#d8a657'
    let g:terminal_color_4 = '#83a598'
    let g:terminal_color_5 = '#d3869b'
    let g:terminal_color_6 = '#8bba7f'
    let g:terminal_color_7 = '#bfa472'
    let g:terminal_color_8 = '#32302f'
    let g:terminal_color_9 = '#ea6962'
    let g:terminal_color_10 = '#a8a920'
    let g:terminal_color_11 = '#d8a657'
    let g:terminal_color_12 = '#83a598'
    let g:terminal_color_13 = '#d3869b'
    let g:terminal_color_14 = '#8bba7f'
    let g:terminal_color_15 = '#bfa472'
  endif
  hi Normal guifg=#bfa472 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
  hi Terminal guifg=#bfa472 guibg=#32302f guisp=NONE gui=NONE cterm=NONE
  hi EndOfBuffer guifg=#32302f guibg=#32302f guisp=NONE gui=NONE cterm=NONE
  hi FoldColumn guifg=#928374 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi Folded guifg=#928374 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi SignColumn guifg=#bfa472 guibg=#2e2c2a guisp=NONE gui=NONE cterm=NONE
  hi IncSearch guifg=#32302f guibg=#fe8019 guisp=NONE gui=NONE cterm=NONE
  hi Search guifg=#32302f guibg=#d8a657 guisp=NONE gui=NONE cterm=NONE
  hi ColorColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi Conceal guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi CursorColumn guifg=NONE guibg=#3a3735 guisp=NONE gui=NONE cterm=NONE
  hi CursorLine guifg=NONE guibg=#3a3735 guisp=NONE gui=NONE cterm=NONE
  hi LineNr guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi CursorLineNr guifg=#a89984 guibg=#3a3735 guisp=NONE gui=NONE cterm=NONE
  hi DiffAdd guifg=NONE guibg=#3d4220 guisp=NONE gui=NONE cterm=NONE
  hi DiffDelete guifg=NONE guibg=#472322 guisp=NONE gui=NONE cterm=NONE
  hi DiffChange guifg=NONE guibg=#1f3742 guisp=NONE gui=NONE cterm=NONE
  hi DiffText guifg=NONE guibg=#391f42 guisp=NONE gui=NONE cterm=NONE
  hi Directory guifg=#a8a920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi ErrorMsg guifg=#ea6962 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi WarningMsg guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi ModeMsg guifg=#bfa472 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi MoreMsg guifg=#d8a657 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi MatchParen guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi NonText guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Pmenu guifg=#ddc7a1 guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi PmenuSbar guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi PmenuSel guifg=#504945 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
  hi WildMenu guifg=#504945 guibg=#a89984 guisp=NONE gui=NONE cterm=NONE
  hi PmenuThumb guifg=NONE guibg=#7c6f64 guisp=NONE gui=NONE cterm=NONE
  hi Question guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi StatusLine guifg=#ddc7a1 guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
  hi StatusLineNC guifg=#928374 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi TabLine guifg=#928374 guibg=#3a3735 guisp=NONE gui=NONE cterm=NONE
  hi TabLineFill guifg=#bfa472 guibg=#3a3735 guisp=NONE gui=NONE cterm=NONE
  hi TabLineSel guifg=#bfa472 guibg=#665c54 guisp=NONE gui=NONE cterm=NONE
  hi VertSplit guifg=#665c54 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Visual guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi VisualNOS guifg=NONE guibg=#504945 guisp=NONE gui=NONE cterm=NONE
  hi QuickFixLine guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Debug guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi debugPC guifg=#32302f guibg=#a8a920 guisp=NONE gui=NONE cterm=NONE
  hi debugBreakpoint guifg=#32302f guibg=#ea6962 guisp=NONE gui=NONE cterm=NONE
  hi Boolean guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Number guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Float guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreProc guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreCondit guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Include guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Define guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Conditional guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Repeat guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Keyword guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Typedef guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Exception guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Statement guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Error guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi StorageClass guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Tag guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Label guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Structure guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Operator guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Title guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Special guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialChar guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Type guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Function guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi String guifg=#a8a920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Character guifg=#a8a920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Constant guifg=#8bba7f guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Macro guifg=#8bba7f guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Identifier guifg=#bfa472 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialKey guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Comment guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpecialComment guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Todo guifg=#ddc7a1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Delimiter guifg=#bfa472 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Ignore guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi User1 guifg=#ea6962 guibg=#665c54 guisp=NONE gui=bold cterm=bold
  hi User2 guifg=#32302f guibg=#d8a657 guisp=NONE gui=NONE cterm=NONE
  hi! link isearchCursorLine CursorLine
  hi! link isearchResults Normal
  hi! link isearchInput Normal
  hi isearchMatch guifg=#ea6962 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi! link vimCommentString Comment
  hi helpNote guifg=#d3869b guibg=NONE guisp=NONE gui=bold cterm=bold
  hi helpHeadline guifg=#ea6962 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi helpHeader guifg=#e78a4e guibg=NONE guisp=NONE gui=bold cterm=bold
  hi helpURL guifg=#a8a920 guibg=NONE guisp=NONE gui=underline cterm=underline
  hi helpHyperTextEntry guifg=#d8a657 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi helpHyperTextJump guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi helpCommand guifg=#8bba7f guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi helpExample guifg=#a8a920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi helpSpecial guifg=#83a598 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi helpSectionDelim guifg=#928374 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsError guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsWarning guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsInformation guifg=#80a0ff guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsHint guifg=#80a0ff guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsUnderlineError guifg=NONE guibg=#472322 guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsUnderlineWarning guifg=NONE guibg=#472322 guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsUnderlineInformation guifg=NONE guibg=#1f3742 guisp=NONE gui=NONE cterm=NONE
  hi LspDiagnosticsUnderlineHint guifg=NONE guibg=#1f3742 guisp=NONE gui=NONE cterm=NONE
  hi htmlArg guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi javascriptFunction guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi javascriptReserved guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi javascriptValue guifg=#d3869b guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi rustFuncCall guifg=#bfa472 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi luaFunction guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  unlet s:t_Co
  finish
endif

if s:t_Co >= 256
  hi Normal ctermfg=223 ctermbg=236 cterm=NONE
  if !has('patch-8.0.0616') && !has('nvim') " Fix for Vim bug
    set background=dark
  endif
  hi Terminal ctermfg=223 ctermbg=236 cterm=NONE
  hi EndOfBuffer ctermfg=236 ctermbg=236 cterm=NONE
  hi FoldColumn ctermfg=245 ctermbg=237 cterm=NONE
  hi Folded ctermfg=245 ctermbg=237 cterm=NONE
  hi SignColumn ctermfg=223 ctermbg=236 cterm=NONE
  hi IncSearch ctermfg=236 ctermbg=208 cterm=NONE
  hi Search ctermfg=236 ctermbg=214 cterm=NONE
  hi ColorColumn ctermfg=NONE ctermbg=237 cterm=NONE
  hi Conceal ctermfg=245 ctermbg=NONE cterm=NONE
  hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi CursorColumn ctermfg=NONE ctermbg=237 cterm=NONE
  hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE
  hi LineNr ctermfg=243 ctermbg=NONE cterm=NONE
  hi CursorLineNr ctermfg=246 ctermbg=237 cterm=NONE
  hi DiffAdd ctermfg=NONE ctermbg=22 cterm=NONE
  hi DiffDelete ctermfg=NONE ctermbg=52 cterm=NONE
  hi DiffChange ctermfg=NONE ctermbg=236 cterm=NONE
  hi DiffText ctermfg=NONE ctermbg=53 cterm=NONE
  hi Directory ctermfg=142 ctermbg=NONE cterm=NONE
  hi ErrorMsg ctermfg=167 ctermbg=NONE cterm=underline
  hi WarningMsg ctermfg=214 ctermbg=NONE cterm=NONE
  hi ModeMsg ctermfg=223 ctermbg=NONE cterm=bold
  hi MoreMsg ctermfg=214 ctermbg=NONE cterm=bold
  hi MatchParen ctermfg=NONE ctermbg=239 cterm=NONE
  hi NonText ctermfg=245 ctermbg=NONE cterm=NONE
  hi Pmenu ctermfg=223 ctermbg=239 cterm=NONE
  hi PmenuSbar ctermfg=NONE ctermbg=239 cterm=NONE
  hi PmenuSel ctermfg=239 ctermbg=246 cterm=NONE
  hi WildMenu ctermfg=239 ctermbg=246 cterm=NONE
  hi PmenuThumb ctermfg=NONE ctermbg=243 cterm=NONE
  hi Question ctermfg=214 ctermbg=NONE cterm=NONE
  hi StatusLine ctermfg=223 ctermbg=241 cterm=NONE
  hi StatusLineNC ctermfg=245 ctermbg=237 cterm=NONE
  hi TabLine ctermfg=245 ctermbg=237 cterm=NONE
  hi TabLineFill ctermfg=223 ctermbg=237 cterm=NONE
  hi TabLineSel ctermfg=223 ctermbg=241 cterm=NONE
  hi VertSplit ctermfg=241 ctermbg=NONE cterm=NONE
  hi Visual ctermfg=NONE ctermbg=239 cterm=NONE
  hi VisualNOS ctermfg=NONE ctermbg=239 cterm=NONE
  hi QuickFixLine ctermfg=175 ctermbg=NONE cterm=bold
  hi Debug ctermfg=208 ctermbg=NONE cterm=NONE
  hi debugPC ctermfg=236 ctermbg=142 cterm=NONE
  hi debugBreakpoint ctermfg=236 ctermbg=167 cterm=NONE
  hi Boolean ctermfg=175 ctermbg=NONE cterm=NONE
  hi Number ctermfg=175 ctermbg=NONE cterm=NONE
  hi Float ctermfg=175 ctermbg=NONE cterm=NONE
  hi PreProc ctermfg=175 ctermbg=NONE cterm=NONE
  hi PreCondit ctermfg=175 ctermbg=NONE cterm=NONE
  hi Include ctermfg=109 ctermbg=NONE cterm=NONE
  hi Define ctermfg=175 ctermbg=NONE cterm=NONE
  hi Conditional ctermfg=175 ctermbg=NONE cterm=NONE
  hi Repeat ctermfg=175 ctermbg=NONE cterm=NONE
  hi Keyword ctermfg=175 ctermbg=NONE cterm=NONE
  hi Typedef ctermfg=175 ctermbg=NONE cterm=NONE
  hi Exception ctermfg=175 ctermbg=NONE cterm=NONE
  hi Statement ctermfg=109 ctermbg=NONE cterm=NONE
  hi Error ctermfg=175 ctermbg=NONE cterm=NONE
  hi StorageClass ctermfg=208 ctermbg=NONE cterm=NONE
  hi Tag ctermfg=208 ctermbg=NONE cterm=NONE
  hi Label ctermfg=208 ctermbg=NONE cterm=NONE
  hi Structure ctermfg=208 ctermbg=NONE cterm=NONE
  hi Operator ctermfg=208 ctermbg=NONE cterm=NONE
  hi Title ctermfg=208 ctermbg=NONE cterm=bold
  hi Special ctermfg=214 ctermbg=NONE cterm=NONE
  hi SpecialChar ctermfg=214 ctermbg=NONE cterm=NONE
  hi Type ctermfg=214 ctermbg=NONE cterm=NONE
  hi Function ctermfg=208 ctermbg=NONE cterm=NONE
  hi String ctermfg=142 ctermbg=NONE cterm=NONE
  hi Character ctermfg=142 ctermbg=NONE cterm=NONE
  hi Constant ctermfg=108 ctermbg=NONE cterm=NONE
  hi Macro ctermfg=108 ctermbg=NONE cterm=NONE
  hi Identifier ctermfg=223 ctermbg=NONE cterm=NONE
  hi SpecialKey ctermfg=109 ctermbg=NONE cterm=NONE
  hi Comment ctermfg=245 ctermbg=NONE cterm=NONE
  hi SpecialComment ctermfg=245 ctermbg=NONE cterm=NONE
  hi Todo ctermfg=223 ctermbg=NONE cterm=NONE
  hi Delimiter ctermfg=223 ctermbg=NONE cterm=NONE
  hi Ignore ctermfg=245 ctermbg=NONE cterm=NONE
  hi User1 ctermfg=167 ctermbg=241 cterm=bold
  hi User2 ctermfg=236 ctermbg=214 cterm=NONE
  hi! link isearchCursorLine CursorLine
  hi! link isearchResults Normal
  hi! link isearchInput Normal
  hi isearchMatch ctermfg=167 ctermbg=NONE cterm=underline
  hi! link vimCommentString Comment
  hi helpNote ctermfg=175 ctermbg=NONE cterm=bold
  hi helpHeadline ctermfg=167 ctermbg=NONE cterm=bold
  hi helpHeader ctermfg=208 ctermbg=NONE cterm=bold
  hi helpURL ctermfg=142 ctermbg=NONE cterm=underline
  hi helpHyperTextEntry ctermfg=214 ctermbg=NONE cterm=bold
  hi helpHyperTextJump ctermfg=214 ctermbg=NONE cterm=NONE
  hi helpCommand ctermfg=108 ctermbg=NONE cterm=NONE
  hi helpExample ctermfg=142 ctermbg=NONE cterm=NONE
  hi helpSpecial ctermfg=109 ctermbg=NONE cterm=NONE
  hi helpSectionDelim ctermfg=245 ctermbg=NONE cterm=NONE
  hi LspDiagnosticsError ctermfg=167 ctermbg=NONE cterm=NONE
  hi LspDiagnosticsWarning ctermfg=208 ctermbg=NONE cterm=NONE
  hi LspDiagnosticsInformation ctermfg=111 ctermbg=NONE cterm=NONE
  hi LspDiagnosticsHint ctermfg=111 ctermbg=NONE cterm=NONE
  hi LspDiagnosticsUnderlineError ctermfg=NONE ctermbg=52 cterm=NONE
  hi LspDiagnosticsUnderlineWarning ctermfg=NONE ctermbg=52 cterm=NONE
  hi LspDiagnosticsUnderlineInformation ctermfg=NONE ctermbg=236 cterm=NONE
  hi LspDiagnosticsUnderlineHint ctermfg=NONE ctermbg=236 cterm=NONE
  hi htmlArg ctermfg=214 ctermbg=NONE cterm=NONE
  hi javascriptFunction ctermfg=214 ctermbg=NONE cterm=NONE
  hi javascriptReserved ctermfg=208 ctermbg=NONE cterm=NONE
  hi javascriptValue ctermfg=175 ctermbg=NONE cterm=NONE
  hi rustFuncCall ctermfg=223 ctermbg=NONE cterm=NONE
  hi luaFunction ctermfg=167 ctermbg=NONE cterm=NONE
  unlet s:t_Co
  finish
endif

if s:t_Co >= 8
  hi Normal ctermfg=White ctermbg=Black cterm=NONE
  hi Terminal ctermfg=White ctermbg=Black cterm=NONE
  hi EndOfBuffer ctermfg=Black ctermbg=Black cterm=NONE
  hi FoldColumn ctermfg=LightGrey ctermbg=DarkGrey cterm=NONE
  hi Folded ctermfg=LightGrey ctermbg=DarkGrey cterm=NONE
  hi SignColumn ctermfg=White ctermbg=Black cterm=NONE
  hi IncSearch ctermfg=Black ctermbg=DarkRed cterm=NONE
  hi Search ctermfg=Black ctermbg=Yellow cterm=NONE
  hi ColorColumn ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi Conceal ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi CursorColumn ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi CursorLine ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi LineNr ctermfg=DarkGrey ctermbg=NONE cterm=NONE
  hi CursorLineNr ctermfg=LightGrey ctermbg=DarkGrey cterm=NONE
  hi DiffAdd ctermfg=NONE ctermbg=DarkGreen cterm=NONE
  hi DiffDelete ctermfg=NONE ctermbg=DarkRed cterm=NONE
  hi DiffChange ctermfg=NONE ctermbg=DarkCyan cterm=NONE
  hi DiffText ctermfg=NONE ctermbg=DarkMagenta cterm=NONE
  hi Directory ctermfg=Green ctermbg=NONE cterm=NONE
  hi ErrorMsg ctermfg=Red ctermbg=NONE cterm=underline
  hi WarningMsg ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi ModeMsg ctermfg=White ctermbg=NONE cterm=bold
  hi MoreMsg ctermfg=Yellow ctermbg=NONE cterm=bold
  hi MatchParen ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi NonText ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi Pmenu ctermfg=White ctermbg=DarkGrey cterm=NONE
  hi PmenuSbar ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi PmenuSel ctermfg=DarkGrey ctermbg=LightGrey cterm=NONE
  hi WildMenu ctermfg=DarkGrey ctermbg=LightGrey cterm=NONE
  hi PmenuThumb ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi Question ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi StatusLine ctermfg=White ctermbg=DarkGrey cterm=NONE
  hi StatusLineNC ctermfg=LightGrey ctermbg=DarkGrey cterm=NONE
  hi TabLine ctermfg=LightGrey ctermbg=DarkGrey cterm=NONE
  hi TabLineFill ctermfg=White ctermbg=DarkGrey cterm=NONE
  hi TabLineSel ctermfg=White ctermbg=DarkGrey cterm=NONE
  hi VertSplit ctermfg=DarkGrey ctermbg=NONE cterm=NONE
  hi Visual ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi VisualNOS ctermfg=NONE ctermbg=DarkGrey cterm=NONE
  hi QuickFixLine ctermfg=Magenta ctermbg=NONE cterm=bold
  hi Debug ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi debugPC ctermfg=Black ctermbg=Green cterm=NONE
  hi debugBreakpoint ctermfg=Black ctermbg=Red cterm=NONE
  hi Boolean ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Number ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Float ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi PreProc ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi PreCondit ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Include ctermfg=Blue ctermbg=NONE cterm=NONE
  hi Define ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Conditional ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Repeat ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Keyword ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Typedef ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Exception ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi Statement ctermfg=Blue ctermbg=NONE cterm=NONE
  hi Error ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi StorageClass ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Tag ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Label ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Structure ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Operator ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Title ctermfg=DarkYellow ctermbg=NONE cterm=bold
  hi Special ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi SpecialChar ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi Type ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi Function ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi String ctermfg=Green ctermbg=NONE cterm=NONE
  hi Character ctermfg=Green ctermbg=NONE cterm=NONE
  hi Constant ctermfg=Cyan ctermbg=NONE cterm=NONE
  hi Macro ctermfg=Cyan ctermbg=NONE cterm=NONE
  hi Identifier ctermfg=White ctermbg=NONE cterm=NONE
  hi SpecialKey ctermfg=Blue ctermbg=NONE cterm=NONE
  hi Comment ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi SpecialComment ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi Todo ctermfg=White ctermbg=NONE cterm=NONE
  hi Delimiter ctermfg=White ctermbg=NONE cterm=NONE
  hi Ignore ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi User1 ctermfg=Red ctermbg=DarkGrey cterm=bold
  hi User2 ctermfg=Black ctermbg=Yellow cterm=NONE
  hi! link isearchCursorLine CursorLine
  hi! link isearchResults Normal
  hi! link isearchInput Normal
  hi isearchMatch ctermfg=Red ctermbg=NONE cterm=underline
  hi! link vimCommentString Comment
  hi helpNote ctermfg=Magenta ctermbg=NONE cterm=bold
  hi helpHeadline ctermfg=Red ctermbg=NONE cterm=bold
  hi helpHeader ctermfg=DarkYellow ctermbg=NONE cterm=bold
  hi helpURL ctermfg=Green ctermbg=NONE cterm=underline
  hi helpHyperTextEntry ctermfg=Yellow ctermbg=NONE cterm=bold
  hi helpHyperTextJump ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi helpCommand ctermfg=Cyan ctermbg=NONE cterm=NONE
  hi helpExample ctermfg=Green ctermbg=NONE cterm=NONE
  hi helpSpecial ctermfg=Blue ctermbg=NONE cterm=NONE
  hi helpSectionDelim ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi LspDiagnosticsError ctermfg=Red ctermbg=NONE cterm=NONE
  hi LspDiagnosticsWarning ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi LspDiagnosticsInformation ctermfg=Cyan ctermbg=NONE cterm=NONE
  hi LspDiagnosticsHint ctermfg=Cyan ctermbg=NONE cterm=NONE
  hi LspDiagnosticsUnderlineError ctermfg=NONE ctermbg=DarkRed cterm=NONE
  hi LspDiagnosticsUnderlineWarning ctermfg=NONE ctermbg=DarkRed cterm=NONE
  hi LspDiagnosticsUnderlineInformation ctermfg=NONE ctermbg=DarkCyan cterm=NONE
  hi LspDiagnosticsUnderlineHint ctermfg=NONE ctermbg=DarkCyan cterm=NONE
  hi htmlArg ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi javascriptFunction ctermfg=Yellow ctermbg=NONE cterm=NONE
  hi javascriptReserved ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi javascriptValue ctermfg=Magenta ctermbg=NONE cterm=NONE
  hi rustFuncCall ctermfg=White ctermbg=NONE cterm=NONE
  hi luaFunction ctermfg=Red ctermbg=NONE cterm=NONE
  unlet s:t_Co
  finish
endif

" Background: dark
" Color: fg0        #bfa472   223  White
" Color: fg1        #ddc7a1   223  White
" Color: bg_dark    #2e2c2a   ~    Black
" Color: bg0        #32302f   236  Black
" Color: bg1        #3a3735   237  DarkGrey
" Color: bg2        #3c3836   237  DarkGrey
" Color: bg3        #504945   239  DarkGrey
" Color: bg4        #504945   239  DarkGrey
" Color: bg5        #665c54   241  DarkGrey
" Color: bg_grey0   #7c6f64   243  DarkGrey
" Color: bg_grey1   #a89984   246  LightGrey
" Color: bg_red     #472322   52   DarkRed
" Color: bg_orange  #fe8019   ~    DarkRed
" Color: bg_yellow  #d8a657   214  Yellow
" Color: bg_green   #3d4220   22   DarkGreen
" Color: bg_magenta #391f42   ~    DarkMagenta
" Color: bg_cyan    #1f3742   ~    DarkCyan
" Color: red        #ea6962   167  Red
" Color: orange     #e78a4e   208  DarkYellow
" Color: yellow     #d8a657   214  Yellow
" Color: green      #a8a920   142  Green
" Color: cyan       #8bba7f   108  Cyan
" Color: blue       #83a598   109  Blue
" Color: magenta    #d3869b   175  Magenta
" Color: dark_green #98971a   106  DarkGreen
" Color: grey       #928374   245  LightGrey
" Color: skyblue    #80a0ff   ~    Cyan
" Term colors: bg0 red green yellow blue magenta cyan fg0 bg0 red green yellow blue magenta cyan fg0
" vim: et ts=2 sw=2
