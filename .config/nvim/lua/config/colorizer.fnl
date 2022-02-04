(import-macros {: au} :macros)

;; Workaround for https://github.com/norcalli/nvim-colorizer.lua/issues/35
(fn reload-colorizer []
  (set package.loaded.colorizer nil)
  (require :colorizer)
  (vim.cmd ":ColorizerAttachToBuffer"))

(vim.cmd "augroup my-colorizer | au!")
(au BufEnter [rgb.txt dune.vim] ":ColorizerAttachToBuffer")
(au BufWritePost [rgb.txt dune.vim] reload-colorizer)
(vim.cmd "augroup END")

