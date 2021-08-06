(module plugin.filetree {require {filetree filetree}})

(fn no [mode lhs rhs opt]
  (let [opts (vim.tbl_extend :force {:noremap true} (or opt {}))]
    (vim.api.nvim_set_keymap mode lhs rhs opts)))

(filetree.init)
(no :n "-" ":<C-u>Filetree<CR>")
(vim.cmd "au vimrc StdinReadPost * let s:has_stdin = 1")
(vim.cmd "au vimrc VimEnter * if !argc() && !has_key(s:, 'has_stdin') && !empty(glob('*', 1, 1)) | silent! Filetree | endif")

