local function jump_to_node(node)
  local row, col = node:start()
  return vim.api.nvim_win_set_cursor(0, {(1 + row), col})
end
local function fn_motion()
  local parser = vim.treesitter.get_parser(0)
  local _local_1_ = parser:parse()
  local tree = _local_1_[1]
  local root = tree:root()
  local _local_2_ = vim.api.nvim_win_get_cursor(0)
  local row = _local_2_[1]
  local col = _local_2_[2]
  local node = root:descendant_for_range((row - 1), col, (row - 1), col)
  local _3ffound = nil
  local cur = node
  while (not _3ffound and cur) do
    print(cur:type())
    if ("fn" == cur:type()) then
      _3ffound = cur
    else
    end
    cur = cur:parent()
  end
  if _3ffound then
    return jump_to_node(_3ffound)
  else
    return nil
  end
end
local function _5_()
  return fn_motion()
end
return vim.api.nvim_set_keymap("n", "[a", "", {callback = _5_, noremap = true})
