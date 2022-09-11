local formatter = require("formatter")
local format = require("formatter.format")
local _local_1_ = require("util")
local s_5c = _local_1_["s\\"]
local some_3f = _local_1_["some?"]
local _24HOME = _local_1_["$HOME"]
local function remove_last_line(text)
  if ("" == text[#text]) then
    table.remove(text)
  else
  end
  return text
end
local function fnlfmt()
  return {exe = "fnlfmt", args = {s_5c(vim.api.nvim_buf_get_name(0))}, stdin = true, transform = remove_last_line}
end
local _local_3_ = require("formatter.filetypes.go")
local gofmt = _local_3_["gofmt"]
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
local function _4_()
  vim.g.format_disabled = true
  return nil
end
vim.api.nvim_create_user_command("FormatDisable", _4_, {})
local function _5_()
  vim.g.format_disabled = false
  return nil
end
vim.api.nvim_create_user_command("FormatEnable", _5_, {})
local function falsy_3f(v)
  return (not v or ("" == v))
end
local excludes = {(_24HOME .. "/.local/share/nvim/site/pack/mine/start/snap/lua/"), (vim.fn.stdpath("config") .. "/colors/")}
vim.api.nvim_create_augroup("my/formatter", {clear = true})
local _6_ = "my/formatter"
local function _9_(_7_)
  local _arg_8_ = _7_
  local file = _arg_8_["file"]
  local buf = _arg_8_["buf"]
  local excluded
  local function _10_(_241)
    return vim.startswith(file, _241)
  end
  excluded = some_3f(excludes, _10_)
  if (not vim.g.format_disabled and not excluded and falsy_3f(vim.fn.getbufvar(buf, "comp_err"))) then
    return format.format("", "", 1, -1, {write = true})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("BufWritePost", {callback = _9_, group = _6_, pattern = {"*.fnl", "*.go"}})
return _6_
