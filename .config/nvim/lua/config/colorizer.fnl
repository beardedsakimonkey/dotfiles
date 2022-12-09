(import-macros {: augroup : autocmd} :macros)

;; Workaround for https://github.com/norcalli/nvim-colorizer.lua/issues/35
(fn reload-colorizer []
  (set package.loaded.colorizer nil)
  (require :colorizer)
  (vim.cmd ":ColorizerAttachToBuffer"))

(augroup :my/colorizer
         (autocmd BufEnter [rgb.txt papyrus.fnl] ":ColorizerAttachToBuffer")
         (autocmd BufWritePost [rgb.txt papyrus.fnl] reload-colorizer))
