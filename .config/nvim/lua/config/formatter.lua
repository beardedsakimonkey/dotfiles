local formatter = require("formatter")
local function fnlfmt()
  return {exe = "fnlfmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
local function gofmt()
  return {exe = "gofmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
vim.cmd("augroup my-formatter | au!")
local function format_write()
  return vim.cmd(":silent FormatWrite")
end
do
  _G["my__au__format_write"] = format_write
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__format_write()")
end
do
  _G["my__au__format_write"] = format_write
  vim.cmd("autocmd BufWritePost *.go  lua my__au__format_write()")
end
return vim.cmd("augroup END")
