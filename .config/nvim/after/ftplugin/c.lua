vim["opt_local"]["commentstring"] = "// %s"
vim["opt_local"]["keywordprg"] = ":vert Man"
do
  vim.api.nvim_buf_set_keymap(0, "n", "]h", "<Cmd>ClangdSwitchSourceHeader<CR>", {noremap = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "[h", "<Cmd>ClangdSwitchSourceHeader<CR>", {noremap = true})
end
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl cms< keywordprg< | sil! nun <buffer> ]h | sil! nun <buffer> [h"))
