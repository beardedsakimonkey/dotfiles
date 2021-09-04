local formatter = require("formatter")
local function fnlfmt()
  return {args = {vim.api.nvim_buf_get_name(0)}, exe = "fnlfmt", stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}}})
vim.cmd("augroup my-formatter | au!")
local function format_write()
  return vim.cmd(":silent FormatWrite")
end
return vim.cmd("augroup END")
