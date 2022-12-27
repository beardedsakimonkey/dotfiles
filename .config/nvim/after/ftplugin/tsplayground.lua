vim.keymap.set("n", "q", "<Cmd>q<CR>", {buffer = true, silent = true})
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> q"))
