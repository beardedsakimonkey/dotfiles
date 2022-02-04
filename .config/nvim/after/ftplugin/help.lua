vim.opt_local["scrolloff"] = 0
do
  vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>", {noremap = true})
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
  vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "/<Bar>\\S\\{-}<Bar><CR><Cmd>nohlsearch<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "<S-Tab>", "?<Bar>\\S\\{-}<Bar><CR><Cmd>nohlsearch<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "g<C-]>", {noremap = true})
end
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl scrolloff< | sil! nun <buffer> q | sil! nun <buffer> d | sil! nun <buffer> u | sil! nun <buffer> D | sil! nun <buffer> U | sil! nun <buffer> <Tab> | sil! nun <buffer> <S-Tab> | sil! nun <buffer> <CR>"))
