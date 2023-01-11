local cfg = require'udir.config'

local function find(tbl, fn)
    for _, v in ipairs(tbl) do
        if fn(v) then
            return v
        end
    end
end

local function some(tbl, fn)
    return find(tbl, fn) ~= nil
end

local function endswith_any(str, suffixes)
    local found = false
    for _, suf in ipairs(suffixes) do
        if found then break end
        if vim.endswith(str, suf) then
            found = true
        end
    end
    return found
end

local function is_file_hidden(file, files)
    return endswith_any(file.name, {'.bs.js', '.o'})
        or file.name == '.git'
end

local function cd(cmd)
    local store = require'udir.store'
    local state = store.get()
    vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(state.cwd))
    vim.cmd 'pwd'
end

local function sort_by_mtime(files)
    local store = require'udir.store'
    local cwd = store.get().cwd
    local mtimes = {}
    for _, file in ipairs(files) do
        --`fs_stat` fails in case of a broken symlink
        local fstat = vim.loop.fs_stat(cwd .. '/' .. file.name)
        mtimes[file.name] = fstat and fstat.mtime.sec or 0
    end
    table.sort(files, function(a, b)
        if (a.type == 'directory') == (b.type == 'directory') then
            return mtimes[a.name] > mtimes[b.name]
        else
            return a.type == 'directory'
        end
    end)
end

local function toggle_sort()
    cfg.sort = cfg.sort ~= sort_by_mtime and sort_by_mtime or nil
    udir.reload()
end

cfg.show_hidden_files = false
cfg.keymaps.i = "<Cmd>lua require'udir'.open()<CR>"
cfg.keymaps.r = "<Cmd>lua require'udir'.move()<CR>"
cfg.keymaps.gh = "<Cmd>lua require'udir'.toggle_hidden_files()<CR>"
cfg.keymaps.C = toggle_sort
cfg.keymaps.C = function() cd 'cd' end
cfg.keymaps.L = function() cd 'lcd' end

map('n', '-', '<Cmd>Udir<CR>')
