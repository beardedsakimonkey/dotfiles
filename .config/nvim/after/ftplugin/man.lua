vim["opt_local"]["keywordprg"] = "help"
vim.keymap.set("n", "q", "<Cmd>lclose<Bar>q<CR>", {buffer = true, nowait = true, silent = true})
vim.keymap.set("n", "<CR>", "<C-]>", {buffer = true})
-- Adapted from gpanders' config
vim.keymap.set("n", "u", "<C-u>", {buffer = true, nowait = true})
vim.keymap.set("n", "d", "<C-d>", {buffer = true, nowait = true})
vim.keymap.set("n", "U", "<C-b>", {buffer = true, nowait = true})
vim.keymap.set("n", "D", "<C-f>", {buffer = true, nowait = true})
vim.keymap.set("n", "<Tab>", "<Cmd>call search('\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$')<CR>", {buffer = true})
vim.keymap.set("n", "<S-Tab>", "<Cmd>call search('\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$', 'b')<CR>", {buffer = true})
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | sil! nun <buffer> q | sil! nun <buffer> <CR> | sil! nun <buffer> u | sil! nun <buffer> d | sil! nun <buffer> U | sil! nun <buffer> D | sil! nun <buffer> <Tab> | sil! nun <buffer> <S-Tab>"))
