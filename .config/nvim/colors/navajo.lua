vim.cmd("hi clear")
vim.opt.background = "light"
if (1 == vim.fn.exists("syntax_on")) then
  vim.cmd("syntax reset")
else
end
vim.g.colors_name = "navajo"
vim.api.nvim_set_hl(0, "Cursor", {bg = "Black", fg = "White"})
vim.api.nvim_set_hl(0, "Normal", {bg = "#CDCABD", fg = "Black"})
vim.api.nvim_set_hl(0, "NonText", {bg = "#C5C2B5", fg = "none"})
vim.api.nvim_set_hl(0, "Visual", {bg = "OliveDrab2", fg = "fg"})
vim.api.nvim_set_hl(0, "Search", {bg = "#ffd787", fg = "none"})
vim.api.nvim_set_hl(0, "IncSearch", {bg = "#BD00BD", fg = "White"})
vim.api.nvim_set_hl(0, "WarningMsg", {bg = "none", bold = 1, fg = "Red4"})
vim.api.nvim_set_hl(0, "ErrorMsg", {bg = "IndianRed3", fg = "White"})
vim.api.nvim_set_hl(0, "PreProc", {bg = "none", fg = "DeepPink4"})
vim.api.nvim_set_hl(0, "Comment", {bg = "none", fg = "Burlywood4"})
vim.api.nvim_set_hl(0, "Identifier", {bg = "none", fg = "Blue3"})
vim.api.nvim_set_hl(0, "Function", {fg = "Black"})
vim.api.nvim_set_hl(0, "LineNr", {fg = "Burlywood4"})
vim.api.nvim_set_hl(0, "Statement", {bg = "none", bold = 1, fg = "MidnightBlue"})
vim.api.nvim_set_hl(0, "Type", {bg = "none", fg = "#6D16BD"})
vim.api.nvim_set_hl(0, "Constant", {bg = "none", fg = "#BD00BD"})
vim.api.nvim_set_hl(0, "Special", {bg = "none", fg = "DodgerBlue4"})
vim.api.nvim_set_hl(0, "String", {bg = "none", fg = "DarkGreen"})
vim.api.nvim_set_hl(0, "Whitespace", {bg = "#d1cec2", fg = "#bab28f"})
vim.api.nvim_set_hl(0, "Directory", {bg = "none", fg = "Blue3"})
vim.api.nvim_set_hl(0, "SignColumn", {bg = "#c9c5b5", fg = "none"})
vim.api.nvim_set_hl(0, "Todo", {bg = "none", bold = 1, fg = "Burlywood4"})
vim.api.nvim_set_hl(0, "MatchParen", {bg = "PaleTurquoise", fg = "none"})
vim.api.nvim_set_hl(0, "Title", {bold = 1, fg = "DeepPink4"})
vim.api.nvim_set_hl(0, "Pmenu", {bg = "#e5daa5"})
vim.api.nvim_set_hl(0, "PmenuSel", {bg = "LightGoldenrod3"})
vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#c6ddb1", fg = "none"})
vim.api.nvim_set_hl(0, "DiffChange", {bg = "#dbd09d", fg = "none"})
vim.api.nvim_set_hl(0, "DiffText", {bg = "#f4dc6e", fg = "none"})
vim.api.nvim_set_hl(0, "DiffDelete", {bg = "#dda296", fg = "none"})
vim.api.nvim_set_hl(0, "StatusLine", {bg = "MistyRose4", fg = "#CDCABD"})
vim.api.nvim_set_hl(0, "StatusLineNC", {bg = "#b2a99d", fg = "#CDCABD"})
vim.api.nvim_set_hl(0, "TabLineFill", {bg = "MistyRose4"})
vim.api.nvim_set_hl(0, "VertSplit", {bg = "MistyRose4", fg = "#CDCABD"})
vim.api.nvim_set_hl(0, "CursorLine", {bg = "#ccc5b5"})
vim.api.nvim_set_hl(0, "Underlined", {fg = "#BD00BD", underline = 1})
vim.api.nvim_set_hl(0, "CursorLineNr", {link = "LineNr"})
vim.api.nvim_set_hl(0, "SpecialKey", {link = "Directory"})
vim.api.nvim_set_hl(0, "User1", {bg = "MistyRose4", bold = 1, fg = "AntiqueWhite2"})
vim.api.nvim_set_hl(0, "User2", {bg = "OliveDrab2", fg = "Black"})
vim.api.nvim_set_hl(0, "User3", {bg = "MistyRose4", fg = "Red3"})
vim.api.nvim_set_hl(0, "User4", {bg = "MistyRose4", fg = "Orange3"})
vim.api.nvim_set_hl(0, "User5", {bg = "MistyRose4", fg = "Grey"})
vim.api.nvim_set_hl(0, "User6", {bg = "MistyRose4", bold = 1, fg = "#CDCABD"})
vim.api.nvim_set_hl(0, "User7", {bg = "MistyRose4", fg = "#CDCABD"})
vim.api.nvim_set_hl(0, "User8", {bg = "MistyRose4", bold = 1, fg = "AntiqueWhite2"})
vim.api.nvim_set_hl(0, "DiagnosticError", {fg = "Red3"})
vim.api.nvim_set_hl(0, "DiagnosticWarn", {fg = "Orange3"})
vim.api.nvim_set_hl(0, "DiagnosticInfo", {fg = "Orchid"})
vim.api.nvim_set_hl(0, "DiagnosticHint", {fg = "Orchid"})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {bg = "#dda296", underline = 1})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {bg = "#e5daa5", underline = 1})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {bg = "#dbd09d", underline = 1})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {bg = "#dbd09d", underline = 1})
vim.api.nvim_set_hl(0, "DiagnosticSignError", {bg = "#c9c5b5", fg = "Red3"})
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", {bg = "#c9c5b5", fg = "Orange3"})
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", {bg = "#c9c5b5", fg = "Orchid"})
vim.api.nvim_set_hl(0, "DiagnosticSignHint", {bg = "#c9c5b5", fg = "Orchid"})
vim.cmd("sign define DiagnosticSignError text=\226\151\143 texthl=DiagnosticSignError linehl= numhl=")
vim.cmd("sign define DiagnosticSignWarn  text=\226\151\143 texthl=DiagnosticSignWarn  linehl= numhl=")
vim.cmd("sign define DiagnosticSignInfo  text=\226\151\143 texthl=DiagnosticSignInfo  linehl= numhl=")
vim.cmd("sign define DiagnosticSignHint  text=\226\151\143 texthl=DiagnosticSignHint  linehl= numhl=")
vim.api.nvim_set_hl(0, "UdirExecutable", {link = "PreProc"})
vim.api.nvim_set_hl(0, "SnapSelect", {bg = "#ccc5b5", bold = 1})
vim.api.nvim_set_hl(0, "SnapPosition", {bg = "none", bold = 1, fg = "#BD00BD"})
vim.api.nvim_set_hl(0, "SnapPrompt", {link = "Comment"})
vim.api.nvim_set_hl(0, "FennelSymbol", {fg = "Black"})
vim.api.nvim_set_hl(0, "markdownH1", {link = "Title"})
vim.api.nvim_set_hl(0, "markdownH2", {link = "Statement"})
vim.api.nvim_set_hl(0, "markdownUrl", {fg = "#0645ad", underline = 1})
vim.api.nvim_set_hl(0, "markdownCode", {bg = "#dbd8ce"})
vim.api.nvim_set_hl(0, "TSConstBuiltin", {link = "Constant"})
vim.api.nvim_set_hl(0, "TSURI", {link = "markdownUrl"})
return vim.api.nvim_set_hl(0, "TSLiteral", {link = "markdownCode"})
