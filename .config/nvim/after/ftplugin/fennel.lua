vim.opt_local["cms"] = ";; %s"
vim.opt_local["keywordprg"] = ":help"
vim.opt_local["lisp"] = true
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl cms< keywordprg< lisp<"))
