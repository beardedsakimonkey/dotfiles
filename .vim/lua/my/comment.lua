local util = require'my.util'

local M = {}

function M.set_marks()
  local parser = util.get_parser()
  if not parser then
    print('missing treesitter parser')
    return '\\<Esc>'
  end
  local tstree = parser:parse()
  local tsroot = tstree:root()

  local comment = util.node_at_cursor(tsroot)

  if comment:type() ~= 'comment' then return '\\<Esc>' end

  local row1, col1, row2, col2 = comment:range()

  -- TODO: group contiguous comment nodes
  vim.fn.setpos("'[", { 0, row1 + 1, col1, 0 })
  vim.fn.setpos("']", { 0, row2 + 1, col2, 0 })

  return "'[o']"
end

package.loaded['my.comment'] = nil
return M
