local ufind = require'ufind'

local function cfg(t)
    return vim.tbl_deep_extend('keep', t or {}, {
        layout = { border = 'single' },
        keymaps = { open_vsplit = '<C-l>' },
    })
end

local function on_complete_grep(cmd, lines)
    for i, line in ipairs(lines) do
        local found, _, fname, linenr = line:find('^([^:]-):(%d+):')
        if found then
            if i == #lines then
                vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(fname) .. '|' .. linenr)
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
    ufind.open_live('rg --vimgrep --no-column --fixed-strings --color=ansi -- ', cfg{
        ansi = true,
        on_complete = on_complete_grep,
    })
end

local function find()
    ufind.open_live('fd --color=always --type=file --', cfg{ansi = true})
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
        return 'fd -- "" ' .. path
    end
    local function on_complete(cmd, line)
        local info = vim.loop.fs_stat(line)
        local is_dir = info and info.type == 'directory' or false
        if is_dir then
            vim.schedule(function()
                ufind.open(ls(line), cfg{on_complete = on_complete})
            end)
        else
            vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(line))
        end
    end
    local cwd = vim.loop.cwd()
    ufind.open(ls(cwd), cfg{
        on_complete = on_complete
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
    local cmd = 'rg --vimgrep --no-column --fixed-strings --color=ansi -- '
    ufind.open(cmd .. query .. ' ' .. path, cfg{
        pattern = '^([^:]-):%d+:(.*)$',
        ansi = true,
        on_complete = on_complete_grep,
    })
end

vim.api.nvim_create_user_command('Grep', function(o) grep(o.args) end, {nargs = '+'})
vim.keymap.set('x', '<space>a', '\"vy:Grep <C-r>v<CR>', {})
vim.keymap.set('n', '<space>a', function()
    local is_dir = vim.fn.isdirectory(vim.fn.expand('%:p')) == 1
    return ':<C-u>Grep ' .. (is_dir and ' %<Left><Left>' or '')
end, {expr = true})
