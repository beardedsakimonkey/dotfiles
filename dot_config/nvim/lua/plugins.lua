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
    'barrettruth/diffs.nvim',
    'AndrewRadev/splitjoin.vim',

    -- Filetypes
    'DingDean/wgsl.vim',
    'kaarmu/typst.vim',
    'MaxMEllon/vim-jsx-pretty',

    -- Colorschemes
    'ClearAspect/onehalf',
    'navarasu/onedark.nvim',
})

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
    keymaps = {},
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

-- ]]  -> quickfix list of every hunk in the repo (working tree vs index,
--        matching mini.diff's default source).
map('n', ']]', function()
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not root or root == '' then
    vim.notify('Not in a git repository', vim.log.levels.WARN)
    return
  end
  local lines = vim.fn.systemlist(
    {'git', '-C', root, 'diff', '--no-color', '--unified=0'})
  local items, file = {}, nil
  for _, line in ipairs(lines) do
    local f = line:match('^%+%+%+ b/(.*)')
    if f then
      file = root .. '/' .. f
    else
      local lnum = line:match('^@@ %-%d+,?%d* %+(%d+)')
      if lnum and file then
        items[#items + 1] = {
          filename = file,
          lnum = tonumber(lnum),
          text = line:match('@@ .-@@%s*(.*)') or '',
        }
      end
    end
  end
  if #items == 0 then
    vim.notify('No hunks in repo', vim.log.levels.INFO)
    return
  end
  vim.fn.setqflist({}, ' ', {title = 'git hunks', items = items})
  vim.cmd('copen')
end)

-- linediff -------------------------------------------------------------------
vim.g.linediff_buffer_type = 'scratch'
map('x', 'D', "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})

-- nvim-surround --------------------------------------------------------------
require('nvim-surround').setup({ indent_lines = false })

-- vim-matchup ----------------------------------------------------------------
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
