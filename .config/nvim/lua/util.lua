local M = {}

---@param path string
function M.exists(path)
    -- Passing '' as the mode corresponds to access(2)'s F_OK
    return vim.loop.fs_access(path, '') == true
end

-- Use this over `vim.fn.system` if you want to avoid blocking the main thread.
function M.system(cmd_parts, cb)
    local stdout_pipe = vim.loop.new_pipe()
    local stderr_pipe = vim.loop.new_pipe()
    -- Not using arrays because chunks of stdout/err can stop mid-line, which
    -- would add complication.
    -- TODO: consider using array buffer (https://www.lua.org/pil/11.6.html)
    local stdout = ""
    local stderr = ""
    local function on_exit(exit_code)
        cb(stdout, stderr, exit_code)
    end
    local cmd = table.remove(cmd_parts, 1)
    local args = cmd_parts

    vim.loop.spawn(cmd, {
        stdio = {nil, stdout_pipe, stderr_pipe},
        args = args,
    }, on_exit)

    local function on_stdouterr(is_stdout, err, data)
        assert(not err, err)
        if nil ~= data then
            if is_stdout then
                stdout = stdout .. data
            else
                stderr = stderr .. data
            end
        end
    end
    vim.loop.read_start(stdout_pipe, function(err, data)
        on_stdouterr(true, err, data)
    end)
    vim.loop.read_start(stderr_pipe, function(err, data)
        on_stdouterr(false, err, data)
    end)
end

function M.augroup(name)
    vim.api.nvim_create_augroup(name, {clear = true})
    local function au(event, pattern, cmd, opts)
        opts = opts or {}
        opts.group = AUGROUP
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

M.FF_PROFILE = '/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/'

return M
