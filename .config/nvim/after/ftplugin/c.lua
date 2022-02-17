vim["opt_local"]["commentstring"] = "// %s"
vim["opt_local"]["keywordprg"] = ":vert Man"
vim.api.nvim_buf_set_keymap(0, "n", "]f", "<Cmd>ClangdSwitchSourceHeader<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(0, "n", "[f", "<Cmd>ClangdSwitchSourceHeader<CR>", {noremap = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl cms< keywordprg< | sil! nun <buffer> ]f | sil! nun <buffer> [f"))
