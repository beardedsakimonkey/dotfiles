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
    'github/copilot.vim',
    'kylechui/nvim-surround',
    'AndrewRadev/linediff.vim',
    'andymass/vim-matchup',
    'nvim-tree/nvim-web-devicons',
    'tommcdo/vim-lion',
    'barrettruth/diffs.nvim',

    -- Filetypes
    'DingDean/wgsl.vim',
    'kaarmu/typst.vim',
    'MaxMEllon/vim-jsx-pretty',

    -- Colorschemes
    'ClearAspect/onehalf',
})

vim.g.diffs = {
    integrations = {
        fugitive = true,
        neogit = false,
        neojj = false,
        gitsigns = false,
        committia = false,
        telescope = false,
    },
}

vim.cmd('colorscheme onehalfdark')

-- Neovim ---------------------------------------------------------------------
stub_com('Undotree', 'nvim.undotree')
stub_com('DiffTool', 'nvim.difftool', {nargs = '*', complete = 'file'})

-- nvim-picky -----------------------------------------------------------------
require('config.picky')

-- nvim-dora ------------------------------------------------------------------
map('n', '-', '<Cmd>Dora<CR>')

local dora = require('dora')
dora.setup({
    icons = true,
    keymaps = {
        ["g'"] = 'next_change',
    },
})
dora.config.keymaps['g,'] = nil
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dora-prompt',
    callback = function(args)
        vim.keymap.set('i', '<Esc>', '<Cmd>close<CR>', {buffer = args.buf})
    end,
})

-- mini.hipatterns ------------------------------------------------------------
aug('my/mini')('BufEnter', {'*.css'}, function(opts)
    local hipatterns = require'mini.hipatterns'
    hipatterns.enable(opts.buf, {
        highlighters = {
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

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
})
map('n', 'god', function() require'mini.diff'.toggle_overlay(0) end)

-- linediff -------------------------------------------------------------------
vim.g.linediff_buffer_type = 'scratch'
map('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

-- nvim-surround --------------------------------------------------------------
require('nvim-surround').setup({ indent_lines = false })

-- vim-matchup ----------------------------------------------------------------
map({'n', 'x', 'o'}, '<Tab>',   '<Plug>(matchup-%)',  {remap = true})
map({'n', 'x', 'o'}, '<S-Tab>', '<Plug>(matchup-g%)', {remap = true})
