local util = require'util'
require 'paq' {
    {'beardedsakimonkey/nvim-udir', branch = 'develop'},
    {'beardedsakimonkey/nvim-ufind', branch = 'develop'},
    'lewis6991/impatient.nvim',
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    'neovim/nvim-lspconfig',
    {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd 'TSUpdate' end},
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'kylechui/nvim-surround',
    {'savq/paq-nvim', pin = true},
    {'norcalli/nvim-colorizer.lua', pin = true},
    {'Darazaki/indent-o-matic', pin = true},
    {'hrsh7th/nvim-cmp', pin = true},
    {'hrsh7th/cmp-buffer', pin = true},
    {'hrsh7th/cmp-nvim-lua', pin = true},
    {'hrsh7th/cmp-path', pin = true},
    {'hrsh7th/cmp-nvim-lsp', pin = true},
    {'rhysd/clever-f.vim', pin = true},
    {'tommcdo/vim-exchange', pin = true},
    {'AndrewRadev/linediff.vim', pin = true},
}

vim.api.nvim_create_user_command('PInstall', 'PaqInstall', {})
vim.api.nvim_create_user_command('PUpdate', 'PaqLogClean | PaqUpdate', {})
vim.api.nvim_create_user_command('PClean', 'PaqClean', {})
vim.api.nvim_create_user_command('PSync', 'PaqLogClean | PaqSync', {})

local au = util.augroup'my/plugins'

au('User', 'PaqDoneUpdate', 'PaqLogOpen')
au('User', 'PaqDoneSync', 'PaqLogOpen')
au('BufNew', 'paq.log', 'nnoremap q <Cmd>:q<CR>')

require 'config.udir'
require 'config.ufind'
require 'config.lsp'
require 'config.colorizer'
require 'config.surround'
require 'config.treesitter'
require 'config.cmp'

-- linediff
vim.g.linediff_buffer_type = 'scratch'
vim.keymap.set('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

-- clever-f
vim.g.clever_f_chars_match_any_signs = ';'
