vim["opt_local"]["formatprg"] = "tidy -quiet -indent -ashtml -utf8"
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl formatprg<"))
