vim["opt_local"]["keywordprg"] = ":help"
local function goto_fnl()
  local from = vim.fn.expand("%:p")
  local to = from:gsub(".lua$", ".fnl")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
end
do
  _G["my__map__goto_fnl"] = goto_fnl
  vim.api.nvim_buf_set_keymap(0, "n", "]f", "<Cmd>lua my__map__goto_fnl()<CR>", {noremap = true})
end
do
  _G["my__map__goto_fnl"] = goto_fnl
  vim.api.nvim_buf_set_keymap(0, "n", "[f", "<Cmd>lua my__map__goto_fnl()<CR>", {noremap = true})
end
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | sil! nunmap <buffer> ]f | sil! nunmap <buffer> [f"))
