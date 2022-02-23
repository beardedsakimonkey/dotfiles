vim.cmd("inoreabbrev <buffer> lambda \206\187")
do end (vim)["opt_local"]["commentstring"] = ";; %s"
vim["opt_local"]["comments"] = "n:;"
vim["opt_local"]["keywordprg"] = ":help"
vim["opt_local"]["iskeyword"] = "!,$,%,#,*,+,-,/,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94"
vim["opt_local"]["lisp"] = true
vim["opt_local"]["autoindent"] = true
vim["opt_local"]["lispwords"] = {"accumulate", "collect", "do", "doto", "each", "fn", "for", "icollect", "lambda", "let", "macro", "macros", "match", "when", "while", "with-open"}
local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.fnl$", ".lua")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
end
vim.api.nvim_buf_set_keymap(0, "n", "]f", "", {callback = goto_lua, noremap = true})
vim.api.nvim_buf_set_keymap(0, "n", "[f", "", {callback = goto_lua, noremap = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl cms< com< keywordprg< iskeyword< lisp< autoindent< lispwords< | unabbrev <buffer> lambda | sil! nunmap <buffer> ]f | sil! nunmap <buffer> [f"))
