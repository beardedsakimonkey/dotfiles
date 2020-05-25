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

local function get_parser()
  if not has_parser() then
    return
  end
  local buf = api.nvim_get_current_buf()
  if not M.parsers[buf] then
    M.parsers[buf] = ts.get_parser(buf)
  end
  return M.parsers[buf]
end

local function node_at_cursor(tsroot)
  local cursor = vim.api.nvim_win_get_cursor(0)
  return tsroot:named_descendant_for_range(cursor[1]-1, cursor[2], cursor[1]-1, cursor[2])
end

function noop()
end

local function jump(direction)
  parser = get_parser()
  local tstree = parser:parse()
  local tsroot = tstree:root()

  local query = [[
    (arguments) @a
  ]]

  local cursor = vim.api.nvim_win_get_cursor(0)

  local cquery = ts.parse_query(get_lang(), query)

  local captures = {}

  for id, node in cquery:iter_captures(tsroot, parser.bufnr, cursor[1]-1, cursor[1]) do
    -- print(vim.inspect(node:sexpr()))
    table.insert(captures, node)
  end

  local node = captures[1]

  if not node then
    return
  end

  noop('a',  'b', 3, 5, {}) -- sdkjfkdsfj

  local cursor_col = cursor[2] + 1
  local dest_node

  if direction == 0 then -- prev
    for i = node:named_child_count() - 1, 0, -1 do
      local child = node:named_child(i)
      dest_node = dest_node or child
      local _, _, _, child_col = child:range()
      if child_col < cursor_col then
        dest_node = child
        break
      end
    end
  else -- next
    for i = 0, node:named_child_count() - 1 do
      local child = node:named_child(i)
      dest_node = dest_node or child
      local _, child_col, _, _ = child:range()
      if child_col > cursor_col then
        dest_node = child
        break
      end
    end
  end

  if dest_node then
    local _, col, _ = dest_node:start()
    api.nvim_win_set_cursor(0, { cursor[1], col })
  end
end

function M.jump_prev()
  jump(0)
end

function M.jump_next()
  jump(1)
end

package.loaded.argmotion = nil

return M
