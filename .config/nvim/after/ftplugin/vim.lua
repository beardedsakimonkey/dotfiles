vim.opt_local.iskeyword:append(":")
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl iskeyword<"))
