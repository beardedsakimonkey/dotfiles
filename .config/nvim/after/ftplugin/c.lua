vim["opt_local"]["commentstring"] = "// %s"
vim["opt_local"]["keywordprg"] = ":vert Man"
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl cms< keywordprg<"))
