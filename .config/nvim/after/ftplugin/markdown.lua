do end (vim.opt_local.formatoptions):append("t")
do end (vim.opt_local.formatoptions):remove("l")
do end (vim)["opt_local"]["breakindent"] = true
vim["opt_local"]["textwidth"] = 100
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl formatoptions< | setl formatoptions< | setl breakindent< | setl textwidth<"))
