local formatter = require("formatter")
local function fnlfmt()
  return {exe = "fnlfmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
local function gofmt()
  return {exe = "gofmt", args = {"-w"}, stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
vim.api.nvim_create_augroup("my/formatter", {clear = true})
local _1_ = "my/formatter"
vim.api.nvim_create_autocmd("BufWritePost", {command = ":silent FormatWrite", group = _1_, pattern = {"*.fnl", "*.go"}})
return _1_
