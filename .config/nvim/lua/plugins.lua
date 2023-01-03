require 'paq' {
    {'beardedsakimonkey/nvim-udir', branch = 'develop'},
    {'beardedsakimonkey/nvim-ufind', branch = 'develop'},
    'lewis6991/impatient.nvim',
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    'neovim/nvim-lspconfig',
    {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd'TSUpdate' end},
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    {'savq/paq-nvim', pin = true},
    {'kylechui/nvim-surround', pin = true},
    {'jose-elias-alvarez/minsnip.nvim', pin = true},
    {'norcalli/nvim-colorizer.lua', pin = true},
    {'Darazaki/indent-o-matic', pin = true},
    {'smjonas/inc-rename.nvim', pin = true},
    {'hrsh7th/nvim-cmp', pin = true},
    {'hrsh7th/cmp-buffer', pin = true},
    {'hrsh7th/cmp-nvim-lua', pin = true},
    {'hrsh7th/cmp-path', pin = true},
    {'hrsh7th/cmp-nvim-lsp', pin = true},
    {'rhysd/clever-f.vim', pin = true},
    {'tommcdo/vim-exchange', pin = true},
    {'AndrewRadev/linediff.vim', pin = true},
    {'bakpakin/fennel.vim', pin = true},
    -- 'tommcdo/vim-lion',
    -- 'dstein64/vim-startuptime',
    -- 'folke/neodev.nvim',
    -- 'mbbill/undotree',
    -- 'gpanders/fennel-repl.nvim',
    -- 'beardedsakimonkey/nvim-antifennel',
}

vim.api.nvim_create_user_command('PInstall', 'PaqInstall', {})
vim.api.nvim_create_user_command('PUpdate', 'PaqLogClean | PaqUpdate | PaqLogOpen', {})
vim.api.nvim_create_user_command('PClean', 'PaqClean', {})
vim.api.nvim_create_user_command('PSync', 'PaqLogClean | PaqSync | PaqLogOpen', {})

require 'config.udir'
require 'config.ufind'
require 'config.lsp'
require 'config.minsnip'
require 'config.colorizer'
require 'config.surround'
require 'config.treesitter'
require 'config.cmp'

-- inc-rename
require 'inc_rename'.setup({preview_empty_name = true})

-- linediff
vim.g.linediff_buffer_type = 'scratch'
vim.keymap.set('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})
