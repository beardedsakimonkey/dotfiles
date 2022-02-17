vim.cmd("inoreabbrev <buffer> lambda \206\187")
do end (vim)["opt_local"]["commentstring"] = ";; %s"
vim["opt_local"]["keywordprg"] = ":help"
do end (vim.opt_local.iskeyword):remove(".")
local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub(".fnl$", ".lua")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
end
vim.api.nvim_buf_set_keymap(0, "n", "]f", "", {callback = goto_lua, noremap = true})
vim.api.nvim_buf_set_keymap(0, "n", "[f", "", {callback = goto_lua, noremap = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl cms< keywordprg< iskeyword< | unabbrev <buffer> lambda | sil! nunmap <buffer> ]f | sil! nunmap <buffer> [f"))
