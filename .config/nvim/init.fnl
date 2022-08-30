(set vim.g.loaded_vimball 1)
(set vim.g.loaded_vimballPlugin 1)

(set vim.g.loaded_tar 1)
(set vim.g.loaded_tarPlugin 1)

(set vim.g.loaded_zip 1)
(set vim.g.loaded_zipPlugin 1)

(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)

(set vim.g.loaded_matchit 1)
(set vim.g.loaded_tutor_mode_plugin 1)
(set vim.g.loaded_2html_plugin 1)
(set vim.g.did_install_default_menus 1)

(set vim.g.loaded_python_provider 0)
(set vim.g.loaded_python3_provider 0)
(set vim.g.loaded_perl_provider 0)
(set vim.g.loaded_ruby_provider 0)
(set vim.g.loaded_node_provider 0)

(vim.cmd "colorscheme navajo")

;; Enable filetype.lua
(set vim.g.do_filetype_lua 1)
;; Disable filetype.vim
(set vim.g.did_load_filetypes 0)

;; See :h syntax-loading
(vim.cmd "syntax enable")

(require :mappings)
(require :options)
;; Setup autocmds before plugins so that fennel compilation happens before
;; formatting.
(require :autocmds)
(require :plugins)
(require :statusline)

