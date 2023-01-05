local util = require'util'

require 'paq' {
    {'beardedsakimonkey/nvim-udir', branch = 'develop'},
    {'beardedsakimonkey/nvim-ufind', branch = 'develop'},
    'lewis6991/impatient.nvim',
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    'neovim/nvim-lspconfig',
    {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd 'TSUpdate' end},
    {'nvim-treesitter/playground', opt = true},
    'nvim-treesitter/nvim-treesitter-textobjects',
    'kylechui/nvim-surround',
    {'savq/paq-nvim', pin = true},
    {'norcalli/nvim-colorizer.lua', pin = true},
    {'Darazaki/indent-o-matic', pin = true},
    -- {'hrsh7th/nvim-cmp', pin = true},
    -- {'hrsh7th/cmp-buffer', pin = true},
    -- {'hrsh7th/cmp-nvim-lua', pin = true},
    -- {'hrsh7th/cmp-path', pin = true},
    -- {'hrsh7th/cmp-nvim-lsp', pin = true},
    {'rhysd/clever-f.vim', pin = true},
    {'tommcdo/vim-exchange', pin = true},
    {'AndrewRadev/linediff.vim', pin = true},
    {'dstein64/vim-startuptime', pin = true, opt = true},
}

com('PInstall', 'PaqInstall')
com('PUpdate', 'PaqLogClean | PaqUpdate')
com('PClean', 'PaqClean')
com('PSync', 'PaqLogClean | PaqSync')

local au = aug'my/plugins'
au('User', 'PaqDoneInstall', 'PaqLogOpen')
au('User', 'PaqDoneUpdate', 'PaqLogOpen')
au('User', 'PaqDoneSync', 'PaqLogOpen')

util.require_safe 'config.udir'
util.require_safe 'config.ufind'
util.require_safe 'config.lsp'
util.require_safe 'config.colorizer'
util.require_safe 'config.surround'
util.require_safe 'config.treesitter'
-- util.require_safe 'config.cmp'

-- nvim-treesitter/playground
map('n', 'gy', function()
    vim.cmd 'pa! playground'
    require'nvim-treesitter-playground.hl-info'.show_hl_captures()
end)
com('TSPlaygroundToggle', function()
    vim.cmd 'pa! playground'
    require'nvim-treesitter-playground.internal'.toggle()
end)

-- linediff
vim.g.linediff_buffer_type = 'scratch'
map('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})
