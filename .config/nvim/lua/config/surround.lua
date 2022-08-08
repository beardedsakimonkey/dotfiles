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
cfg = {keymaps = {insert = "<C-g>s", insert_line = "<C-g>S", normal = "ys", normal_cur = "yss", normal_line = "yS", normal_cur_line = "ySS", visual = "S", visual_line = "gS", delete = "ds", change = "cs"}, surrounds = {l = {add = _1_, find = "%b[]%b()", delete = "^(%[)().-(%]%b())()$", change = {target = "^()()%b[]%((.-)()%)$", replacement = _2_}}}, aliases = {a = ">", b = ")", B = "}", r = "]", ["'"] = {"\"", "'", "`"}, s = {"}", "]", ")", ">", "\"", "'", "`"}}, highlight = {duration = 0}, move_cursor = "begin"}
return nvim_surround.setup(cfg)
