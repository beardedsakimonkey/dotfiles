(import-macros {: au} :macros)

(vim.cmd "augroup my-colorizer | au!")
(au BufEnter rgb.txt ":ColorizerAttachToBuffer")
(vim.cmd "augroup END")

