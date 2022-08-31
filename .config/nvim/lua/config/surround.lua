local nvim_surround = require("nvim-surround")
local _local_1_ = require("nvim-surround.config")
local get_selection = _local_1_["get_selection"]
local get_selections = _local_1_["get_selections"]
local l
local function _2_()
  local clipboard = vim.fn.getreg("+"):gsub("\n", "")
  return {{"["}, {("](" .. clipboard .. ")")}}
end
local function _3_()
  local clipboard = vim.fn.getreg("+"):gsub("\n", "")
  return {{""}, {clipboard}}
end
l = {add = _2_, find = "%b[]%b()", delete = "^(%[)().-(%]%b())()$", change = {target = "^()()%b[]%((.-)()%)$", replacement = _3_}}
local F
local function _4_()
  local function _5_()
    return get_selection({query = {capture = "@function.inner", type = "textobjects"}})
  end
  return get_selections({char = "F", exclude = _5_})
end
local function _6_()
  return get_selection({query = {capture = "@function.outer", type = "textobjects"}})
end
F = {delete = _4_, find = _6_}
local o
local function _7_(c)
  local function _8_()
    return get_selection({query = {capture = "@conditional.inner", type = "textobjects"}})
  end
  return get_selections({char = c, exclude = _8_})
end
local function _9_()
  return get_selection({query = {capture = "@conditional.outer", type = "textobjects"}})
end
o = {delete = _7_, find = _9_}
return nvim_surround.setup({surrounds = {l = l, F = F, o = o}, indent_lines = false})