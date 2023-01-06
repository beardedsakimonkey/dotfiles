local ufind = require'ufind'
local util = require'util'
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
            if i == #lines then  -- edit the last file
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

map('n', '<space>b', buffers)
map('n', '<space>o', oldfiles)
map('n', '<space>f', find)
map('n', '<space>F', interactive_find)
map('n', '<space>n', notes)
map('n', '<space>x', live_grep)

local function grep(query_str, query_tbl)
    local ft = vim.bo.ft
    local function cmd()
        local args = {'--vimgrep', '--column', '--fixed-strings', '--color=ansi', '--'}
        -- pattern matching on the last arg being a path is unreliable (it might be part of the
        -- query), so check if ft is 'udir'
        if ft == 'udir' and #query_tbl > 1 and util.exists(query_tbl[#query_tbl]) then
            -- seperate the path into its own argument
            local path = table.remove(query_tbl)
            table.insert(args, table.concat(query_tbl, ' '))
            table.insert(args, path)
        else
            table.insert(args, query_str)
        end
        return 'rg', args
    end
    ufind.open(cmd, cfg{
        scopes = '^([^:]-):%d+:%d+:(.*)$',
        ansi = true,
        on_complete = on_complete_grep,
    })
end

vim.api.nvim_create_user_command('Grep', function(o) grep(o.args, o.fargs) end, {nargs = '+'})
map('x', '<space>a', '\"vy:Grep <C-r>v<CR>')
map('n', '<space>a', function()
    local path = ''
    if vim.bo.ft == 'udir' then
        -- can't rely on % because sometimes the bufname has '[1]'
        local cwd = require'udir.store'.get().cwd
        path = ' ' .. cwd .. string.rep('<Left>', #cwd + 1)
    end
    return ':<C-u>Grep ' .. path
end, {expr = true})
