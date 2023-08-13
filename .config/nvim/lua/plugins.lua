local util = require'util'

local function setup()
    require'paq'{
        'savq/paq-nvim',
        {'beardedsakimonkey/nvim-udir',  branch='develop'},
        {'beardedsakimonkey/nvim-ufind'},
        'tpope/vim-commentary',
        'tpope/vim-sleuth',
        {'tpope/vim-abolish'},
        {'kylechui/nvim-surround',      pin=true},
        {'AndrewRadev/linediff.vim',    pin=true},
        {'echasnovski/mini.hipatterns', pin=true, opt=true},
        {'tommcdo/vim-exchange',        pin=true, opt=true},
        {'dstein64/vim-startuptime',    pin=true, opt=true},
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

    -- paq ---------------------------------------------------------------------
    com('PInstall', 'PaqInstall')
    com('PUpdate', 'PaqLogClean | PaqUpdate')
    com('PClean', 'PaqClean')
    com('PSync', 'PaqLogClean | PaqSync')

    -- linediff ----------------------------------------------------------------
    vim.g.linediff_buffer_type = 'scratch'
    map('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

    -- mini.hipatterns ---------------------------------------------------------
    local color_map

    local function enable_hipatterns(opts)
        vim.cmd'pa mini.hipatterns'
        local hipatterns = require'mini.hipatterns'
        hipatterns.enable(opts.buf, {
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
                named_color = {
                    pattern = '%w+',
                    group = function(_, match)
                        local color = color_map[match]
                        if color == nil then return nil end
                        return hipatterns.compute_hex_color_group(color, 'bg')
                    end
                },
            },
        })
    end

    local au = aug'my/hipatterns'
    au('BufEnter', {'papyrus.lua', 'rgb.txt', '*.css'}, function(opts)
        color_map = color_map or vim.tbl_map(
            function(dec) return string.format('#%06x', dec) end,
            vim.api.nvim_get_color_map()
        )
        enable_hipatterns(opts)
    end)
    -- Sourcing colorscheme invokes `:hi clear`, which clears mini's highlight
    -- groups.
    au('BufWritePost', 'papyrus.lua', function(opts)
        package.loaded['mini.hipatterns'] = nil
        enable_hipatterns(opts)
    end)

    -- nvim-surround -----------------------------------------------------------
    require'nvim-surround'.setup{
        indent_lines = false,
    }

    -- vim-exchange ------------------------------------------------------------
    stub_map('n', 'cx', 'vim-exchange')
    stub_map('x', 'X', 'vim-exchange')

    -- vim-startuptime ---------------------------------------------------------
    stub_com('StartupTime', 'vim-startuptime')

    -- vim-abolish -------------------------------------------------------------
    -- Abbreviations in ../after/plugin/abolish.vim
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
