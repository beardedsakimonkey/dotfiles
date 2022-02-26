(import-macros {: au} :macros)

;; Workaround for https://github.com/norcalli/nvim-colorizer.lua/issues/35
(fn reload-colorizer []
  (set package.loaded.colorizer nil)
  (require :colorizer)
  (vim.cmd ":ColorizerAttachToBuffer"))

(vim.cmd "augroup my-colorizer | au!")
(au BufEnter [rgb.txt navajo.fnl] ":ColorizerAttachToBuffer")

(au BufWritePost [rgb.txt navajo.fnl] reload-colorizer)
(vim.cmd "augroup END")

