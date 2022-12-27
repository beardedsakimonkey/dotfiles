vim["opt_local"]["formatprg"] = "python -m json.tool"
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl formatprg<"))
