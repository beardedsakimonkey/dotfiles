vim["opt_local"]["keywordprg"] = ":help"
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg<"))
