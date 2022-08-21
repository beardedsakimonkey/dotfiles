local function goto_fnl()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.lua$", ".fnl")
  if vim.loop.fs_access(to, "R") then
    return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
  else
    return vim.api.nvim_err_writeln(("Cannot read file " .. to))
  end
end
vim["opt_local"]["keywordprg"] = ":help"
vim.keymap.set("n", "]f", goto_fnl, {buffer = true})
vim.keymap.set("n", "[f", goto_fnl, {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | sil! nun <buffer> ]f | sil! nun <buffer> [f"))
