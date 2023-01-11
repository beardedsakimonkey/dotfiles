local util = require'util'

local function setup()
    require'paq'{
        {'beardedsakimonkey/nvim-udir', branch = 'develop'},
        {'beardedsakimonkey/nvim-ufind', branch = 'develop'},
        'lewis6991/impatient.nvim',
        'tpope/vim-commentary',
        'tpope/vim-repeat',
        'kylechui/nvim-surround',
        'savq/paq-nvim',
        {'Darazaki/indent-o-matic',     pin=true},
        {'AndrewRadev/linediff.vim',    pin=true},
        {'rhysd/clever-f.vim',          pin=true},
        {'norcalli/nvim-colorizer.lua', pin=true, opt=true},
        {'tommcdo/vim-exchange',        pin=true, opt=true},
        {'dstein64/vim-startuptime',    pin=true, opt=true},
        {'mbbill/undotree',             pin=true, opt=true},
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

    --[[ linediff ]]--
    vim.g.linediff_buffer_type = 'scratch'
    map('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

    --[[ colorizer ]]--
    local au = aug'my/colorizer'
    au('BufEnter', {'rgb.txt', 'papyrus.lua'}, 'pa nvim-colorizer.lua | ColorizerAttachToBuffer')
    au('BufWritePost', {'rgb.txt', 'papyrus.lua'}, function()
        -- Workaround for https://github.com/norcalli/nvim-colorizer.lua/issues/35
        package.loaded.colorizer = nil
        require'colorizer'
        vim.cmd 'ColorizerAttachToBuffer'
    end)

    --[[ nvim-surround ]]--
    require'nvim-surround'.setup{
        indent_lines = false,
    }

    --[[ vim-startuptime ]]--
    stub_com('StartupTime', 'vim-startuptime')

    --[[ undotree ]]--
    stub_com('UndotreeToggle', 'undotree')

    --[[ vim-exchange ]]--
    stub_map('n', 'cx', 'vim-exchange')
    stub_map('x', 'X', 'vim-exchange')
end

local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if not util.exists(path) then  -- bootstrap
    print('Cloning paq-nvim...')
    vim.fn.system{'git', 'clone', '--depth', '1', 'https://github.com/beardedsakimonkey/paq-nvim', path}
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
