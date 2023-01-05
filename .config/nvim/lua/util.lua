local M = {}

function M.require_safe(mod)
    local ok, msg = xpcall(function() return require(mod) end, debug.traceback)
    if not ok then
        vim.api.nvim_err_writeln(('Error requiring %s: %s'):format(mod, msg))
    end
end

---@param path string
function M.exists(path)
    -- Passing '' as the mode corresponds to access(2)'s F_OK
    return vim.loop.fs_access(path, '') == true
end

M.FF_PROFILE = '/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/'

return M
