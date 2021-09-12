vim.cmd("augroup my-colorizer | au!")
do
  vim.cmd("autocmd BufEnter rgb.txt  :ColorizerAttachToBuffer")
end
return vim.cmd("augroup END")
