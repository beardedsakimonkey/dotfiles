(local filetree (require :filetree))
(import-macros {: no : au} :macros)

(filetree.init)
(no n "-" ":<C-u>Filetree<CR>")

;; (vim.cmd "augroup my-filetree | au!")

;; (autocmd StdinReadPost * "let s:has_stdin = 1")
;; (autocmd VimEnter *
;;          "if !argc() && !has_key(s:, 'has_stdin') && !empty(glob('*', 1, 1)) | silent! Filetree | endif")

;; (vim.cmd "augroup END")

