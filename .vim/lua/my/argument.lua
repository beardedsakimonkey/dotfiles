local api = vim.api
local ts = vim.treesitter
local util = require'my.util'

local M = {}

function noop()
end

local function jump(direction)
  local parser = util.get_parser()
  if not parser then
    print('missing treesitter parser')
    return
  end
  local tstree = parser:parse()
  local tsroot = tstree:root()

  local cursor = vim.api.nvim_win_get_cursor(0)

  -- argument_list?
  local cquery = util.parse_query('(arguments) @a')

  local captures = {}

  -- print(vim.inspect(tsroot:sexpr()))

  for id, node in cquery:iter_captures(tsroot, parser.bufnr, cursor[1]-1, cursor[1]) do
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

package.loaded['my.argument'] = nil
return M
