vim["opt_local"]["keywordprg"] = ":help"
local function goto_fnl()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.lua$", ".fnl")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
end
vim.api.nvim_buf_set_keymap(0, "n", "]f", "", {callback = goto_fnl, noremap = true})
vim.api.nvim_buf_set_keymap(0, "n", "[f", "", {callback = goto_fnl, noremap = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | sil! nunmap <buffer> ]f | sil! nunmap <buffer> [f"))
