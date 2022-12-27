require'paq'{
    'savq/paq-nvim',
    'lewis6991/impatient.nvim',
    {'beardedsakimonkey/nvim-udir', branch = 'develop'},
    {'beardedsakimonkey/nvim-ufind', branch = 'develop'},
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/minsnip.nvim',
    'norcalli/nvim-colorizer.lua',
    'Darazaki/indent-o-matic',
    'kylechui/nvim-surround',
    'folke/neodev.nvim',
    'smjonas/inc-rename.nvim',
    {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd'TSUpdate' end},
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    -- vimscript
    'rhysd/clever-f.vim',
    'mbbill/undotree',
    'tommcdo/vim-exchange',
    'dstein64/vim-startuptime',
    'AndrewRadev/linediff.vim',
    'tommcdo/vim-lion',
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    -- language specific
    'bakpakin/fennel.vim',
    'gpanders/fennel-repl.nvim',
}

require'inc_rename'.setup({preview_empty_name = true})
require'config.udir'
require'config.ufind'
require'config.lsp'
require'config.minsnip'
require'config.colorizer'
require'config.surround'
require'config.treesitter'
require'config.cmp'

-- linediff
vim.g.linediff_buffer_type = "scratch"
vim.keymap.set("x", "D", "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

-- vim-lion
vim.g.lion_squeeze_spaces = 1
