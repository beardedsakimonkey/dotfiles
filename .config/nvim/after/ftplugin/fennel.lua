vim.cmd("inoreabbrev <buffer> lambda \206\187")
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | unabbrev <buffer> lambda"))
local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.fnl$", ".lua")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
end
vim["opt_local"]["expandtab"] = true
vim["opt_local"]["commentstring"] = ";; %s"
vim["opt_local"]["comments"] = "n:;"
vim["opt_local"]["keywordprg"] = ":help"
vim["opt_local"]["iskeyword"] = "!,$,%,#,*,+,-,/,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94"
vim["opt_local"]["lisp"] = true
vim["opt_local"]["autoindent"] = true
vim["opt_local"]["lispwords"] = {"accumulate", "collect", "do", "doto", "each", "fn", "for", "icollect", "lambda", "let", "macro", "macros", "match", "when", "while", "with-open"}
vim.keymap.set("n", "]f", goto_lua, {buffer = true})
vim.keymap.set("n", "[f", goto_lua, {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl expandtab< | setl commentstring< | setl comments< | setl keywordprg< | setl iskeyword< | setl lisp< | setl autoindent< | setl lispwords< | sil! nun <buffer> ]f | sil! nun <buffer> [f"))
