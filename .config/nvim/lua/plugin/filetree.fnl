(local filetree (require :filetree))
(import-macros {: no} :macros)

(filetree.init)
(no n "-" ":<C-u>Filetree<CR>")
;; (vim.cmd "au vimrc StdinReadPost * let s:has_stdin = 1")
;; (vim.cmd "au vimrc VimEnter * if !argc() && !has_key(s:, 'has_stdin') && !empty(glob('*', 1, 1)) | silent! Filetree | endif")

