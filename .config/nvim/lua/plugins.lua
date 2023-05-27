local util = require'util'

local function setup()
    require'paq'{
        'savq/paq-nvim',
        {'beardedsakimonkey/nvim-udir',  branch='develop'},
        {'beardedsakimonkey/nvim-ufind', branch='develop'},
        'tpope/vim-commentary',
        'tpope/vim-sleuth',
        {'kylechui/nvim-surround',      pin=true},
        {'AndrewRadev/linediff.vim',    pin=true},
        {'echasnovski/mini.hipatterns', pin=true, opt=true}
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

    --[[ mini.hipatterns ]]--
    local au = aug'my/hipatterns'

    local function require_hipatterns()
        vim.cmd'pa mini.hipatterns'
        return require'mini.hipatterns'
    end

    local nvim_get_color_map = util.memo(vim.api.nvim_get_color_map)

    local function enable_hipatterns(opts)
        local hipatterns = require_hipatterns()
        hipatterns.enable(opts.buf, {
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
                named_color = {
                    pattern = '%w+',
                    group = function(_, match)
                        local color = nvim_get_color_map()[match]
                        if color == nil then return nil end
                        local hex = '#' .. require'bit'.tohex(color, 6)
                        return require'mini.hipatterns'.compute_hex_color_group(hex, 'bg')
                    end
                },
            },
        })
    end

    au('BufEnter', {'papyrus.lua', 'rgb.txt', '*.css'}, enable_hipatterns)
    -- Sourcing colorscheme invokes `:hi clear`, which clears mini's highlight
    -- groups.
    au('BufWritePost', 'papyrus.lua', function(opts)
        package.loaded['mini.hipatterns'] = nil
        enable_hipatterns(opts)
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
