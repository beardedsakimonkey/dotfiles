function blah()
  vim.api.nvim_command("echo 'yooo'")
end

vim.api.nvim_command("command! Blah call luaeval('blah()')")
vim.api.nvim_command("nnoremap <leader>f :Blah<cr>")
