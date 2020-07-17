local api = vim.api
local ts = vim.treesitter

local M = { parsers = {} }

local function get_lang()
    return api.nvim_buf_get_option(0, 'filetype')
end

local function has_parser()
    -- undocumented, see neovim/src/nvim/api/vim.c
    return #api.nvim_get_runtime_file('parser/' .. get_lang() .. '.*', false) > 0
end

function M.parse_query(query)
    return ts.parse_query(get_lang(), query)
end

function M.get_parser()
    if not has_parser() then
        return
    end
    local buf = api.nvim_get_current_buf()
    if not M.parsers[buf] then
        M.parsers[buf] = ts.get_parser(buf)
    end
    return M.parsers[buf]
end

function M.node_at_cursor(tsroot)
    local cursor = vim.api.nvim_win_get_cursor(0)
    return tsroot:named_descendant_for_range(cursor[1]-1, cursor[2], cursor[1]-1, cursor[2])
end

package.loaded['my.util'] = nil
return M
