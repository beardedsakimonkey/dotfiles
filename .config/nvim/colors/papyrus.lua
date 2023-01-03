-- Color shorthands: $VIMRUNTIME/rgb.txt

vim.cmd'hi clear'
vim.opt.background = 'light'
if vim.fn.exists('syntax_on') == 1 then
  vim.cmd'syntax reset'
end
vim.g.colors_name = 'papyrus'

local hl = vim.api.nvim_set_hl

---@diagnostic disable: param-type-mismatch
hl(0, 'Cursor', {bg = 'Black', fg = 'White'})
hl(0, 'Normal', {bg = '#CDCABD', fg = 'Black'})
hl(0, 'NonText', {bg = '#C5C2B5', fg = 'none'})
hl(0, 'Visual', {bg = 'OliveDrab2', fg = 'fg'})
hl(0, 'Search', {bg = '#ffd787', fg = 'none'})
hl(0, 'IncSearch', {bg = '#ffc17a', fg = 'Black'})
hl(0, 'CurSearch', {link = 'IncSearch'})
hl(0, 'WarningMsg', {bg = 'none', bold = 1, fg = 'Red4'})
hl(0, 'ErrorMsg', {bg = 'IndianRed3', fg = 'White'})
hl(0, 'PreProc', {bg = 'none', fg = 'DeepPink4'})
hl(0, 'Comment', {bg = 'none', fg = 'Burlywood4'})
hl(0, 'Identifier', {bg = 'none', fg = 'Black'})
hl(0, 'Function', {fg = 'Black'})
hl(0, 'LineNr', {fg = 'Burlywood4'})
hl(0, 'Statement', {bg = 'none', fg = 'MidnightBlue'})
hl(0, 'Keyword', {bg = 'none', fg = 'MidnightBlue'})
hl(0, 'Type', {bg = 'none', fg = '#6D16BD'})
hl(0, 'Constant', {bg = 'none', fg = '#BD00BD'})
hl(0, 'Special', {bg = 'none', fg = 'DodgerBlue4'})
hl(0, 'String', {bg = 'none', fg = 'DarkGreen'})
hl(0, 'Whitespace', {fg = '#bab28f'})  -- trail listchar
hl(0, 'Directory', {bg = 'none', fg = 'Blue3'})
hl(0, 'SignColumn', {bg = '#c9c5b5', fg = 'none'})
hl(0, 'Todo', {bg = 'none', bold = 1, fg = 'Burlywood4'})
hl(0, 'MatchParen', {bg = 'PaleTurquoise', fg = 'none'})
hl(0, 'Title', {bold = 1, fg = 'DeepPink4'})
hl(0, 'Pmenu', {bg = '#e5daa5'})
hl(0, 'PmenuSel', {bg = 'LightGoldenrod3'})
hl(0, 'StatusLine', {bg = 'MistyRose4', fg = '#CDCABD'})
hl(0, 'StatusLineNC', {bg = '#b2a99d', fg = '#CDCABD'})
hl(0, 'TabLineFill', {bg = 'MistyRose4'})
hl(0, 'VertSplit', {bg = 'MistyRose4', fg = '#CDCABD'})
hl(0, 'CursorLine', {bg = '#ccc5b5'})
hl(0, 'Underlined', {fg = '#BD00BD', underline = 1})
hl(0, 'ColorColumn', {bg = '#ccb3a9'})
hl(0, 'CursorLineNr', {link = 'LineNr'})
hl(0, 'SpecialKey', {link = 'Directory'})

hl(0, 'DiffAdd', {bg = '#c6ddb1', fg = 'none'})
hl(0, 'DiffChange', {bg = '#dbd09d', fg = 'none'})
hl(0, 'DiffText', {bg = '#f4dc6e', fg = 'none'})
hl(0, 'DiffDelete', {bg = '#dda296', fg = 'none'})

hl(0, 'User1', {bg = 'MistyRose4', bold = 1, fg = 'AntiqueWhite2'})
hl(0, 'User2', {bg = 'OliveDrab2', fg = 'Black'})
hl(0, 'User3', {bg = 'MistyRose4', fg = 'Red3'})
hl(0, 'User4', {bg = 'MistyRose4', fg = 'Orange3'})
hl(0, 'User5', {bg = 'MistyRose4', fg = 'Grey'})
hl(0, 'User6', {bg = 'MistyRose4', bold = 1, fg = '#CDCABD'})
hl(0, 'User7', {bg = 'MistyRose4', fg = '#CDCABD'})
hl(0, 'User8', {bg = 'MistyRose4', bold = 1, fg = 'AntiqueWhite2'})

hl(0, 'DiagnosticError', {fg = 'Red3'})
hl(0, 'DiagnosticWarn', {fg = 'Orange3'})
hl(0, 'DiagnosticInfo', {fg = 'Orange2'})
hl(0, 'DiagnosticHint', {fg = 'Orange2'})
hl(0, 'DiagnosticUnderlineError', {bg = '#dda296'})
hl(0, 'DiagnosticUnderlineWarn', {bg = '#e5daa5'})
hl(0, 'DiagnosticUnderlineInfo', {bg = '#dbd09d'})
hl(0, 'DiagnosticUnderlineHint', {bg = '#dbd09d'})
hl(0, 'DiagnosticSignError', {bg = '#c9c5b5', fg = 'Red3'})
hl(0, 'DiagnosticSignWarn', {bg = '#c9c5b5', fg = 'Orange3'})
hl(0, 'DiagnosticSignInfo', {bg = '#c9c5b5', fg = 'Orange2'})
hl(0, 'DiagnosticSignHint', {bg = '#c9c5b5', fg = 'Orange2'})
vim.cmd('sign define DiagnosticSignError text=\226\151\143 texthl=DiagnosticSignError linehl= numhl=')
vim.cmd('sign define DiagnosticSignWarn  text=\226\151\143 texthl=DiagnosticSignWarn  linehl= numhl=')
vim.cmd('sign define DiagnosticSignInfo  text=\226\151\143 texthl=DiagnosticSignInfo  linehl= numhl=')
vim.cmd('sign define DiagnosticSignHint  text=\226\151\143 texthl=DiagnosticSignHint  linehl= numhl=')

hl(0, 'UdirExecutable', {link = 'PreProc'})
hl(0, 'UfindMatch', {bg = 'none', bold = 1, fg = '#BD00BD'})
hl(0, 'UfindCursorLine', {link = 'DiffChange'})

hl(0, 'FennelSymbol', {fg = 'Black'})
hl(0, 'markdownH1', {link = 'Title'})
hl(0, 'markdownH2', {link = 'Statement'})
hl(0, 'markdownUrl', {fg = '#0645ad', underline = 1})
hl(0, 'markdownCode', {bg = '#dbd8ce'})
-- Custom '@' captures used in after/queries/*
hl(0, '@text.title1', {link = 'markdownH1'})
hl(0, '@text.title2', {link = 'markdownH2'})

hl(0, '@constant.builtin', {link = 'Constant'})
hl(0, '@function', {bold = 1, fg = 'Black'})
hl(0, '@function.call', {fg = 'Blue3'})
hl(0, '@keyword.operator', {link = 'PreProc'})
hl(0, '@keyword.return', {link = 'PreProc'})
hl(0, 'TSURI', {link = 'markdownUrl'})
hl(0, 'TSLiteral', {link = 'markdownCode'})
-- hi(0, 'TSError', {bg ='#dda296'})
