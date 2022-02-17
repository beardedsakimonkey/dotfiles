vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>", {noremap = true, silent = true})
vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>", {noremap = true})
do end (vim)["opt_local"]["statusline"] = " %q %{printf(\" %d line%s\", line(\"$\"), line(\"$\") > 1 ? \"s \" : \" \")}"
if (1 ~= vim.g.loaded_cfilter) then
  vim.cmd("sil! packadd cfilter")
  vim.g.loaded_cfilter = 1
else
end
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> q | sil! nun <buffer> <CR> | setl stl<"))
