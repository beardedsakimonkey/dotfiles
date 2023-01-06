local M = {}

function M.exists(path)
    -- Passing '' as the mode corresponds to access(2)'s F_OK
    return vim.loop.fs_access(path, '') == true
end

M.FF_PROFILE = '/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/'

return M
