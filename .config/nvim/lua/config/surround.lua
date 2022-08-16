local nvim_surround = require("nvim-surround")
local cfg
local function _1_()
  local clipboard = vim.fn.getreg("+"):gsub("\n", "")
  return {{"["}, {("](" .. clipboard .. ")")}}
end
local function _2_()
  local clipboard = vim.fn.getreg("+"):gsub("\n", "")
  return {{""}, {clipboard}}
end
cfg = {surrounds = {l = {add = _1_, find = "%b[]%b()", delete = "^(%[)().-(%]%b())()$", change = {target = "^()()%b[]%((.-)()%)$", replacement = _2_}}}}
return nvim_surround.setup(cfg)
