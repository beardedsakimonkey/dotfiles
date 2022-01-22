vim.cmd("augroup my-colorizer | au!")
do
  vim.cmd("autocmd BufEnter rgb.txt,dune.vim  :ColorizerAttachToBuffer")
end
return vim.cmd("augroup END")
