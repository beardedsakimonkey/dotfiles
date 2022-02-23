vim["opt_local"]["statusline"] = " %f"
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl statusline<"))
