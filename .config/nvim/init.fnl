;; In $VIMRUNTIME/plugin/
(set vim.g.loaded_matchit 1)
(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)
(set vim.g.loaded_remote_plugins 1)
(set vim.g.loaded_spellfile_plugin 1)
(set vim.g.loaded_2html_plugin 1)
(set vim.g.loaded_tutor_mode_plugin 1)

;; In $VIMRUNTIME/autoload/provider/
(set vim.g.loaded_node_provider 1)
(set vim.g.loaded_perl_provider 1)
(set vim.g.loaded_python_provider 1)
(set vim.g.loaded_python3_provider 1)
(set vim.g.loaded_ruby_provider 1)

(vim.cmd "colorscheme navajo")

;; Enable filetype.lua
(set vim.g.do_filetype_lua 1)
;; Disable filetype.vim
(set vim.g.did_load_filetypes 0)

;; See :h syntax-loading
(vim.cmd "syntax enable")

(fn require-safe [mod]
  (local (ok? msg) (pcall require mod))
  (when (not ok?)
    (vim.api.nvim_err_writeln (: "Config error in %s: %s" :format mod msg))))

(require-safe :mappings)
(require-safe :options)
;; Setup autocmds before plugins so fennel compile happens before formatting.
(require-safe :autocmds)
(require-safe :plugins)
(require-safe :statusline)
(require-safe :commands)
