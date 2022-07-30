local formatter = require("formatter")
local format = require("formatter.format")
local function fnlfmt()
  return {exe = "fnlfmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
local function gofmt()
  return {exe = "gofmt", args = {"-w"}, stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
local function some_3f(list, pred_3f)
  local found = false
  for _, v in ipairs(list) do
    if found then break end
    if pred_3f(v) then
      found = true
    else
    end
  end
  return found
end
local excludes = {"/Users/tim/.local/share/nvim/site/pack/mine/start/snap/lua/", "/Users/tim/.config/nvim/colors/"}
local enabled = true
local function _2_()
  enabled = false
  return nil
end
vim.api.nvim_create_user_command("FormatDisable", _2_, {})
local function _3_()
  enabled = true
  return nil
end
vim.api.nvim_create_user_command("FormatEnable", _3_, {})
vim.api.nvim_create_augroup("my/formatter", {clear = true})
local _4_ = "my/formatter"
local function _7_(_5_)
  local _arg_6_ = _5_
  local file = _arg_6_["file"]
  local excluded
  local function _8_(_241)
    return vim.startswith(file, _241)
  end
  excluded = some_3f(excludes, _8_)
  if (enabled and not excluded) then
    return format.format("", "silent", 1, -1, {write = true})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("BufWritePost", {callback = _7_, group = _4_, pattern = {"*.fnl", "*.go"}})
return _4_
