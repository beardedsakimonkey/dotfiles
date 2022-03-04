vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>", {noremap = true, silent = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> q"))
