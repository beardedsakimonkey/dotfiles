vim.opt_local["keywordprg"] = "help"
do
  vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>lclose<Bar>q<CR>", {noremap = true, nowait = true, silent = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<C-]>", {noremap = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "u", "<C-u>", {noremap = true, nowait = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "d", "<C-d>", {noremap = true, nowait = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "U", "<C-b>", {noremap = true, nowait = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "D", "<C-f>", {noremap = true, nowait = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "/\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>", {noremap = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "<S-Tab>", "?\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>", {noremap = true})
end
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | sil! nun <buffer> q | sil! nun <buffer> <CR> | sil! nun <buffer> u | sil! nun <buffer> d | sil! nun <buffer> U | sil! nun <buffer> D | sil! nun <buffer> <Tab> | sil! nun <buffer> <S-Tab>"))
