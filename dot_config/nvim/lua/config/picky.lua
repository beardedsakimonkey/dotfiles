local picky = require('picky')

picky.setup({
    window = {
        border = 'rounded',
        shrink = true,
    },
    keymaps = {
        ['<C-l>'] = 'vsplit',
    },
})

vim.cmd('hi link PickyOperator Special')
local function set_picky_muted()
    vim.api.nvim_set_hl(0, 'PickyMuted', vim.tbl_extend('force',
        vim.api.nvim_get_hl(0, { name = 'Comment', link = false }),
        { italic = false }
    ))
end
set_picky_muted()
local au = aug'my/picky'
au('ColorScheme', '*', set_picky_muted)

-- Git
map('n', '<space>gl', function() picky.git_log() end)
map('n', '<space>gs', function() picky.git_status({ window = { width = 50 } }) end)

-- Symbols
map('n', '<space>s', function() picky.symbols() end)
map('n', '<space>S', function() picky.symbols({ workspace = true }) end)

-- Oldfiles
map('n', '<space>o', function() picky.oldfiles() end)

-- Buffers
map('n', '<space>b', function()
    picky.buffers({
        include_current = true,
        keymaps = {
            ['<C-d>'] = function(ctx)
                for _, item in ipairs(ctx.targets) do
                    vim.api.nvim_buf_delete(item.bufnr, {})
                end
                ctx.refresh()
            end,
        },
    })
end)

-- Files
map('n', '<space>f', function() picky.files() end)
map('n', '<space>v', function() picky.files({ cwd = vim.fn.stdpath('config') }) end)

-- Help
map('n', '<space>h', function() picky.help() end)
map('n', '<space>H', function() picky.help({ live = true }) end)

-- Colorschemes
map('n', '<space>c', function()
    local original = vim.g.colors_name
    local original_bg = vim.o.background
    local applied = original

    local items = vim.tbl_map(function(name)
        return { text = name }
    end, vim.fn.getcompletion('', 'color'))

    local function preview(name)
        if name and name ~= applied then
            applied = name
            -- Prefer the dark variant: set background first so schemes that
            -- branch on it load dark, then nudge it back if the scheme flipped
            -- to light on its own.
            vim.o.background = 'dark'
            pcall(vim.cmd.colorscheme, name)
            if vim.o.background ~= 'dark' then
                pcall(function() vim.o.background = 'dark' end)
            end
        end
    end

    local accepted = false
    local session = picky.open({
        window = {
            width = 30,
        },
        source = picky.sources.items(items),
        keymaps = {
            ['<CR>'] = function(ctx)
                accepted = true
                ctx.close()
            end,
        },
    })

    -- Drive the live preview off the session's update hook: every hover bumps
    -- the active item and notifies, and close() notifies once with closed set.
    local render = session.on_update
    session.on_update = function()
        render()
        if session.closed then
            if not accepted and original and applied ~= original then
                pcall(vim.cmd.colorscheme, original)
                vim.o.background = original_bg
            end
            return
        end
        local current = session:current_item()
        if current then
            preview(current.text)
        end
    end

    -- Preview the item the picker opened on.
    session.on_update()
end)

-- Grep -----------------------------------------------------------------------

local function absolute_path(cwd, path)
    if vim.fn.isabsolutepath(path) == 1 then
        return path
    end
    return vim.fs.joinpath(cwd, path)
end

local function open_grep_targets(action)
    return function(ctx)
        if #ctx.targets == 1 then
            picky.actions[action](ctx)
            return
        end

        local items = vim.tbl_map(function(item)
            return {
                filename = absolute_path(ctx.cwd, item.path),
                text = item.text,
                lnum = item.lnum,
                col = item.col,
            }
        end, ctx.targets)

        ctx.close()
        vim.fn.setqflist({}, ' ', {
            nr = '$',
            items = items,
        })
        vim.cmd(action)
        vim.cmd.copen()
        vim.cmd('cc!')
    end
end

local grep_keymaps = {
    ['<CR>'] = open_grep_targets('edit'),
    ['<C-s>'] = open_grep_targets('split'),
    ['<C-l>'] = open_grep_targets('vsplit'),
    ['<C-t>'] = open_grep_targets('tabedit'),
}

local function exists(path)
    return vim.uv.fs_access(path, '') == true
end

local function grep(query, parts)
    parts = vim.deepcopy(parts)
    local paths

    if #parts > 1 and exists(parts[#parts]) then
        paths = { table.remove(parts) }
        query = table.concat(parts, ' ')
    end

    picky.open({
        source = picky.sources.grep({
            pattern = query,
            paths = paths,
        }),
        keymaps = grep_keymaps,
    })
end

com('Grep', function(o) grep(o.args, o.fargs) end, { nargs = '+' })
map('x', '<space>a', '"vy:Grep <C-r>v<CR>')
map('n', '<space>a', ':<C-u>Grep ')

vim.cmd'hi link PickyNormal Normal'
