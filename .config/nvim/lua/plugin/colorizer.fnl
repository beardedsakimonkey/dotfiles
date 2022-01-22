(import-macros {: au} :macros)

(vim.cmd "augroup my-colorizer | au!")
(au BufEnter [rgb.txt dune.vim] ":ColorizerAttachToBuffer")
(vim.cmd "augroup END")

