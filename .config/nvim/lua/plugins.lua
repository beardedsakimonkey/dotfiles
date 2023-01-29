local util = require'util'

local function setup()
    require'paq'{
        {'beardedsakimonkey/nvim-udir', branch = 'develop'},
        {'beardedsakimonkey/nvim-ufind', branch = 'develop'},
        'tpope/vim-commentary',
        'kylechui/nvim-surround',
        'savq/paq-nvim',
        {'Darazaki/indent-o-matic',     pin=true},
        {'norcalli/nvim-colorizer.lua', pin=true, opt=true},
    }
end

local function configure()
    local function stub_com(cmd, pack)
        com(cmd, function()
            vim.api.nvim_del_user_command(cmd)
            vim.cmd('pa ' .. pack)
            vim.cmd(cmd)
        end)
    end

    local function stub_map(mode, lhs, pack)
        map(mode, lhs, function()
            vim.keymap.del(mode, lhs)
            vim.cmd('pa ' .. pack)
            vim.api.nvim_input(lhs)
        end)
    end

    require_safe 'config.udir'
    require_safe 'config.ufind'

    --[[ paq ]]--
    com('PInstall', 'PaqInstall')
    com('PUpdate', 'PaqLogClean | PaqUpdate')
    com('PClean', 'PaqClean')
    com('PSync', 'PaqLogClean | PaqSync')

    --[[ colorizer ]]--
    local au = aug'my/colorizer'
    local pats = {'rgb.txt', 'papyrus.lua', '*.css'}
    au('BufEnter', pats, 'pa nvim-colorizer.lua | ColorizerAttachToBuffer')
    au('BufWritePost', pats, function()
        -- https://github.com/norcalli/nvim-colorizer.lua/issues/35
        package.loaded.colorizer = nil
        require'colorizer'
        vim.cmd 'ColorizerAttachToBuffer'
    end)

    --[[ nvim-surround ]]--
    require'nvim-surround'.setup{
        indent_lines = false,
    }
end

local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if not util.exists(path) then  -- bootstrap
    print('Cloning paq-nvim...')
    vim.fn.system{'git', 'clone', '--depth', '1',
        'https://github.com/savq/paq-nvim', path}
    vim.cmd 'pa paq-nvim'
    setup()
    require'paq'.install()
    vim.api.nvim_create_autocmd('User', {
        pattern = 'PaqDoneInstall',
        callback = configure,
        once = true,
    })
else
    setup()
    configure()
end
