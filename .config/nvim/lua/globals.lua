local _print = _G.print

-- Patch `print` to call vim.inspect on each table arg
_G.print = function (...)
    local args = {}
    local num_args = select('#', ...)
    -- Use for loop instead of `tbl_map` because `pairs` iteration stops at nil
    for i = 1, num_args do
        local arg = select(i, ...)
        if type(arg) == 'table' then
            table.insert(args, vim.inspect(arg))
        elseif type(arg) == 'nil' then  -- lest it be ignored
            table.insert(args, 'nil')
        else
            table.insert(args, arg)
        end
    end
    return _print(unpack(args))
end

-- _G.P = function(...)
--     print_PATCHED(...)
--     return ...
-- end

_G.fe = vim.fn.fnameescape
_G.se = vim.fn.shellescape

_G.com = function(name, command, opts)
    vim.api.nvim_create_user_command(name, command, opts or {})
end

_G.aug = function(group)
    vim.api.nvim_create_augroup(group, {})
    local function au(event, pattern, cmd, opts)
        opts = opts or {}
        opts.group = group
        opts.pattern = pattern
        if type(cmd) == 'string' then
            opts.command = cmd
        else
            opts.callback = cmd
        end
        vim.api.nvim_create_autocmd(event, opts)
    end
    return au
end

_G.map = vim.keymap.set
