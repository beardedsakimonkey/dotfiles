do
  vim.keymap.set("n", "q", "<Cmd>q<CR>", {buffer = true, silent = true})
  vim.keymap.set("n", "<CR>", "<CR>", {buffer = true})
  do end (vim)["opt_local"]["statusline"] = " %q %{printf(\" %d line%s\", line(\"$\"), line(\"$\") > 1 ? \"s \" : \" \")}"
  vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> q | sil! nun <buffer> <CR> | setl statusline<"))
end
if (1 ~= vim.g.loaded_cfilter) then
  vim.cmd("sil! packadd cfilter")
  vim.g.loaded_cfilter = 1
  return nil
else
  return nil
end
