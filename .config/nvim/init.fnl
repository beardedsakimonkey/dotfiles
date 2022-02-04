(set vim.g.loaded_getscriptPlugin 1)
(set vim.g.loaded_logiPat 1)
(set vim.g.loaded_rrhelper 1)

(set vim.g.loaded_vimball 1)
(set vim.g.loaded_vimballPlugin 1)

(set vim.g.loaded_tar 1)
(set vim.g.loaded_tarPlugin 1)

(set vim.g.loaded_zip 1)
(set vim.g.loaded_zipPlugin 1)

(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)

(set vim.g.loaded_matchit 1)

;; Disable $VIMRUNTIME/menu.vim
(set vim.g.did_install_default_menus 1)

(set vim.g.loaded_python_provider 0)
(set vim.g.loaded_python3_provider 0)
(set vim.g.loaded_perl_provider 0)
(set vim.g.loaded_ruby_provider 0)
(set vim.g.loaded_node_provider 0)

(vim.cmd "colorscheme dune")
(vim.cmd "syntax enable")

;; See :h syntax-loading
(vim.cmd "filetype plugin indent on")

(vim.cmd "com! DiffOrig echo my#diff_orig()")

;; NOTE: Don't need to require plugins.fnl
(require :mappings)
(require :options)
(require :autocmds)
(require :statusline)
