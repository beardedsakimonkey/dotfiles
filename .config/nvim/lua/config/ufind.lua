local ufind = require'ufind'
local uv = vim.loop

local function cfg(t)
    return vim.tbl_deep_extend('keep', t, {
        layout = { border = 'single' },
        keymaps = { open_vsplit = '<C-l>' },
    })
end

local function on_complete_grep(cmd, lines)
    for i, line in ipairs(lines) do
        local found, _, fname, linenr, colnr = line:find('^([^:]-):(%d+):(%d+):')
        if found then
            if i == #lines then
                -- HACK: if we don't schedule, the cursor gets positioned one column to the left.
                vim.schedule(function()
                    vim.cmd(('%s +%s %s|norm! %s|'):format(cmd, linenr, vim.fn.fnameescape(fname), colnr))
                end)
            else  -- create the buffer
                local buf = vim.fn.bufnr(fname, true)
                vim.bo[buf].buflisted = true
            end
        else
            print('regex fail for line: ', line)
        end
    end
end

local function live_grep()
    ufind.open_live('rg --vimgrep --column --fixed-strings --color=ansi -- ', cfg{
        ansi = true,
        on_complete = on_complete_grep,
    })
end

local function find()
    ufind.open_live('fd --color=always --fixed-strings --max-results=100 --type=file --', cfg{
        ansi = true,
    })
end

local function buffers()
    ufind.open(require'ufind.source.buffers'(), cfg{})
end

local function oldfiles()
    ufind.open(require'ufind.source.oldfiles'(), cfg{})
end

local function notes()
    ufind.open('fd --color=always --type=file "" ' .. os.getenv'HOME' .. '/notes', cfg{
        ansi = true
    })
end

local function interactive_find()
    local function ls(path)
        local paths = {[1] = path .. '/..'}
        for name in vim.fs.dir(path) do
            table.insert(paths, path .. '/' .. name)
        end
        return paths
    end
    local function get_highlights(line)
        local col_start = line:find('/([^/]+)$')
        if col_start then
            return {
                {col_start = 0, col_end = col_start, hl_group = 'Comment'},
            }
        else
            return {}
        end
    end
    local function on_complete(cmd, lines)
        local line = assert(uv.fs_realpath(lines[1]))
        local info = uv.fs_stat(line)
        local is_dir = info and info.type == 'directory' or false
        if is_dir then
            vim.schedule(function()
                ufind.open(ls(line), cfg{
                    on_complete = on_complete,
                    get_highlights = get_highlights,
                })
            end)
        else
            vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(line))
        end
    end
    ufind.open(ls(uv.cwd()), cfg{
        on_complete = on_complete,
        get_highlights = get_highlights,
    })
end

vim.keymap.set('n', '<space>b', buffers)
vim.keymap.set('n', '<space>o', oldfiles)
vim.keymap.set('n', '<space>f', find)
vim.keymap.set('n', '<space>F', interactive_find)
vim.keymap.set('n', '<space>n', notes)
vim.keymap.set('n', '<space>x', live_grep)

local function grep(query)
    local path = ''
    if vim.endswith(query, '%') then
        query = query:sub(1, -3)
        path = vim.fn.expand('%:p')
    end
    local cmd = 'rg --vimgrep --column --fixed-strings --color=ansi -- '
    ufind.open(cmd .. query .. ' ' .. path, cfg{
        scopes = '^([^:]-):%d+:%d+:(.*)$',
        ansi = true,
        on_complete = on_complete_grep,
    })
end

vim.api.nvim_create_user_command('Grep', function(o) grep(o.args) end, {nargs = '+'})
vim.keymap.set('x', '<space>a', '\"vy:Grep <C-r>v<CR>', {})
vim.keymap.set('n', '<space>a', function()
    local path = ''
    if vim.bo.ft == 'udir' then
        -- can't rely on % because sometimes the bufname has '[1]'
        path = ' ' .. require'udir.store'.get().cwd .. '<S-Left><Left>'
    end
    return ':<C-u>Grep ' .. path
end, {expr = true})
