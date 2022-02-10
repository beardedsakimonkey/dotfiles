(import-macros {: opt-local : no : undo_ftplugin} :macros)

(no n :q :<Cmd>q<CR> :silent :buffer)
;; Undo any existing <CR> mapping
(no n :<CR> :<CR> :buffer)

(opt-local statusline
           " %q %{printf(\" %d line%s\", line(\"$\"), line(\"$\") > 1 ? \"s \" : \" \")}")

;; Adapted from gpanders' config
(when (not= 1 vim.g.loaded_cfilter)
  (vim.cmd "sil! packadd cfilter")
  (set vim.g.loaded_cfilter 1))

(undo_ftplugin "sil! nun <buffer> q" "sil! nun <buffer> <CR>" "setl stl<")

