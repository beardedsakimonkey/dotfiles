require'impatient'
require'globals'

-- In $VIMRUNTIME/plugin/
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1

-- In $VIMRUNTIME/autoload/provider/
vim.g.loaded_node_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_python3_provider = 1
vim.g.loaded_ruby_provider = 1

vim.cmd 'colorscheme papyrus'
vim.cmd 'syntax enable'  -- see :h syntax-loading

local util = require'util'
util.require_safe 'commands'
util.require_safe 'autocmds'
util.require_safe 'options'
util.require_safe 'statusline'
util.require_safe 'mappings'
util.require_safe 'plugins'
util.require_safe 'lsp'
