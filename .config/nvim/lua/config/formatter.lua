local formatter = require("formatter")
local format = require("formatter.format")
local _local_1_ = require("util")
local some_3f = _local_1_["some?"]
local function fnlfmt()
  return {exe = "fnlfmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
local _local_2_ = require("formatter.filetypes.go")
local gofmt = _local_2_["gofmt"]
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
local excludes = {"/Users/tim/.local/share/nvim/site/pack/mine/start/snap/lua/", "/Users/tim/.config/nvim/colors/"}
local function _3_()
  vim.g.format_enabled = false
  return nil
end
vim.api.nvim_create_user_command("FormatDisable", _3_, {})
local function _4_()
  vim.g.format_enabled = true
  return nil
end
vim.api.nvim_create_user_command("FormatEnable", _4_, {})
local function falsy_3f(v)
  return (not v or ("" == v))
end
vim.api.nvim_create_augroup("my/formatter", {clear = true})
local _5_ = "my/formatter"
local function _8_(_6_)
  local _arg_7_ = _6_
  local file = _arg_7_["file"]
  local buf = _arg_7_["buf"]
  local excluded
  local function _9_(_241)
    return vim.startswith(file, _241)
  end
  excluded = some_3f(excludes, _9_)
  if (vim.g.format_enabled and not excluded and falsy_3f(vim.fn.getbufvar(buf, "comp_err"))) then
    return format.format("", "", 1, -1, {write = true})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("BufWritePost", {callback = _8_, group = _5_, pattern = {"*.fnl", "*.go"}})
return _5_