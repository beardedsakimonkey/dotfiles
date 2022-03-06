(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (map n :q :<Cmd>q<CR> :silent :buffer)
                    ;; Undo any existing <CR> mapping
                    (map n :<CR> :<CR> :buffer)
                    (opt-local statusline
                               " %q %{printf(\" %d line%s\", line(\"$\"), line(\"$\") > 1 ? \"s \" : \" \")}"))

;; Adapted from gpanders' config
(when (not= 1 vim.g.loaded_cfilter)
  (vim.cmd "sil! packadd cfilter")
  (set vim.g.loaded_cfilter 1))

