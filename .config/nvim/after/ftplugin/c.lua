vim["opt_local"]["commentstring"] = "// %s"
vim["opt_local"]["keywordprg"] = ":vert Man"
vim.keymap.set("n", "]f", "<Cmd>ClangdSwitchSourceHeader<CR>", {buffer = true})
vim.keymap.set("n", "[f", "<Cmd>ClangdSwitchSourceHeader<CR>", {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl commentstring< | setl keywordprg< | sil! nun <buffer> ]f | sil! nun <buffer> [f"))
