require('features.pack').add({
    -- Trusted
    {'beardedsakimonkey/nvim-dora',  pin = false},
    {'beardedsakimonkey/nvim-picky', pin = false},

    -- Untrusted
    {'echasnovski/mini.operators',  version = 'stable'},
    {'echasnovski/mini.bufremove',  version = 'stable'},
    {'echasnovski/mini.hipatterns', version = 'stable'},
    {'echasnovski/mini.diff',       version = 'stable'},
    'tpope/vim-fugitive',
    'tpope/vim-sleuth',
    'kylechui/nvim-surround',
    'AndrewRadev/linediff.vim',
    'andymass/vim-matchup',
    'nvim-tree/nvim-web-devicons',
    'tommcdo/vim-lion',
    'AndrewRadev/splitjoin.vim',
    'barrettruth/diffs.nvim',
    'CoreyKaylor/diffbandit.nvim',

    -- Filetypes
    'DingDean/wgsl.vim',
    'kaarmu/typst.vim',
    'MaxMEllon/vim-jsx-pretty',

    -- Colorschemes
    'ClearAspect/onehalf',
    'navarasu/onedark.nvim',
})

vim.cmd('colorscheme onedark')

-- Neovim ---------------------------------------------------------------------
stub_com('Undotree', 'nvim.undotree')
stub_com('DiffTool', 'nvim.difftool', {nargs = '*', complete = 'file'})

-- nvim-picky -----------------------------------------------------------------
require('config.picky')

-- nvim-dora ------------------------------------------------------------------
map('n', '-', '<Cmd>Dora<CR>')

local video_extensions = {
    ['3gp'] = true,
    asf = true,
    avi = true,
    flv = true,
    m2ts = true,
    m4v = true,
    mkv = true,
    mov = true,
    mp4 = true,
    mpeg = true,
    mpg = true,
    mts = true,
    ogv = true,
    ts = true,
    vob = true,
    webm = true,
    wmv = true,
}

local function open_dora_external(ctx)
    local extension = ctx.path and vim.fn.fnamemodify(ctx.path, ':e'):lower()
    local is_file = ctx.type == 'file' or ctx.type == 'link'

    if not is_file or not video_extensions[extension] then
        require('dora.api').open_external()
        return
    end

    local handle, pid_or_error
    ---@diagnostic disable-next-line: missing-fields
    handle, pid_or_error = vim.uv.spawn('mpv', {
        args = {ctx.path},
        detached = true,
        stdio = {nil, nil, nil},
    }, function()
        if handle and not handle:is_closing() then
            handle:close()
        end
    end)

    if not handle then
        vim.notify('Could not open video with mpv: ' .. tostring(pid_or_error), vim.log.levels.ERROR)
        return
    end

    handle:unref()
end

require('dora').configure({
    keymaps = {
        ['!'] = {
            function()
                require('dora.api').shell_cmd('chmod +x')
            end,
            desc = 'Make executable',
        },
        gx = {
            open_dora_external,
            desc = 'Open externally',
        },
    },
})

-- mini.operators -------------------------------------------------------------
require('mini.operators').setup({
    evaluate = { prefix = 'g=' },
    exchange = { prefix = 'cx' },
    multiply = { prefix = 'gm' },
    replace  = { prefix = 'gr' },
    sort     = { prefix = 'gs' }
})
require('mini.operators').make_mappings(
    'exchange',
    { textobject = 'cx', line = 'cxx', selection = 'X' }
)

-- mini.diff ------------------------------------------------------------------
require('mini.diff').setup({
  mappings = {
    apply = 'gh',
    reset = 'gH',
    textobject = 'gh',
    goto_first = '[H',
    goto_prev  = '[h',
    goto_next  = ']h',
    goto_last  = ']H',
  },
  options = {
    wrap_goto = true,
  },
})
map('n', 'god', function() require'mini.diff'.toggle_overlay(0) end)

-- linediff -------------------------------------------------------------------
vim.g.linediff_buffer_type = 'scratch'
map('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

-- nvim-surround --------------------------------------------------------------
require('nvim-surround').setup({ indent_lines = false })

-- vim-matchup ----------------------------------------------------------------
vim.g.matchup_matchparen_offscreen = {method = 'none'}
map({'n', 'x', 'o'}, '<Tab>',   '<Plug>(matchup-%)',  {remap = true})
map({'n', 'x', 'o'}, '<S-Tab>', '<Plug>(matchup-g%)', {remap = true})

-- diffs.nvim------------------------------------------------------------------
vim.g.diffs = {
    integrations = {
        fugitive = true,
    },
}

-- fugitive -------------------------------------------------------------------
map('n', '<space>gc', '<Cmd>G commit<CR>')
