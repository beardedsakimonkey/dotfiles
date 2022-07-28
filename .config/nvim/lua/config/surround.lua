local nvim_surround = require("nvim-surround")
local function surround_link()
  return {"[", ("](" .. vim.fn.getreg("*") .. ")")}
end
local cfg = {keymaps = {insert = "<C-g>s", insert_line = "<C-g>S", normal = "ys", normal_cur = "yss", normal_line = "yS", normal_cur_line = "ySS", visual = "S", visual_line = "gS", delete = "ds", change = "cs"}, delimiters = {pairs = {["("] = {"( ", " )"}, [")"] = {"(", ")"}, ["{"] = {"{ ", " }"}, ["}"] = {"{ ", " }"}, ["<"] = {"< ", " >"}, [">"] = {"<", ">"}, ["["] = {"[ ", " ]"}, ["]"] = {"[", "]"}, l = surround_link}, separators = {["'"] = {"'", "'"}, ["\""] = {"\"", "\""}, ["`"] = {"`", "`"}}, HTML = {t = "type", T = "whole"}, aliases = {a = ">", b = ")", B = "}", r = "]", q = {"\"", "'", "`"}, s = {"}", "]", ")", ">", "\"", "'", "`"}}}, highlight_motion = {duration = 0}, move_cursor = "begin"}
nvim_surround.setup(cfg)
local function select_quote(char)
  local _local_1_ = require("nvim-surround.utils")
  local get_nearest_selections = _local_1_["get_nearest_selections"]
  local selections = get_nearest_selections(char)
  if selections then
    local left = selections.left.last_pos
    local right = selections.right.last_pos
    vim.api.nvim_win_set_cursor(0, left)
    vim.cmd("normal! v")
    return vim.api.nvim_win_set_cursor(0, {right[1], (right[2] - 2)})
  else
    return nil
  end
end
local function i()
  local char = vim.fn.nr2char(vim.fn.getchar())
  if (cfg.delimiters.pairs[char] or cfg.delimiters.separators[char] or cfg.delimiters.aliases[char]) then
    return select_quote(char)
  else
    return nil
  end
end
return vim.keymap.set("o", "i", i, {})
