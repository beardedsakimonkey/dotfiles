local configs = require'nvim-treesitter.configs'

local function disable(lang, bufnr)
    local size = vim.fn.getfsize(vim.fn.bufname(bufnr))
    local large_buf = size > (1024 * 1024) or size == -2
    return large_buf or lang == 'markdown'
end

-- Enable treesitter highlighting for lua
vim.g.ts_highlight_lua = true

configs.setup({
    ensure_installed = {
        'javascript',
        'fennel',
        'markdown',
        'markdown_inline',
        'query',
    },
    highlight = {
        enable = true,
        disable = disable,
    },
    playground = {
        enable = true,
    },
    textobjects = {
        move = {
            enable = true,
            disable = disable,
            goto_next_end = {[']a'] = '@parameter.inner'},
            goto_previous_start = {['[a'] = '@parameter.inner'},
            set_jumps = false,  -- keepjumps
        },
        select = {
            enable = true,
            disable = disable,
            lookahead = true,  -- jump to next textobject
            keymaps = {
                aF = '@function.outer',
                iF = '@function.inner',
                af = '@call.outer',
                ['if'] = '@call.inner',
                aB = '@block.outer',
                iB = '@block.inner',
                aa = '@parameter.outer',
                ia = '@parameter.inner',
            },
        },
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {'BufWrite', 'BufEnter'},
    },
})

-- From nvim-treesitter/playground
vim.keymap.set('n', 'gy', '<Cmd>TSHighlightCapturesUnderCursor<CR>', {})
