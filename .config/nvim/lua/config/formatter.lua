local formatter = require("formatter")
local function fnlfmt()
  return {exe = "fnlfmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
local function gofmt()
  return {exe = "gofmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
vim.cmd("augroup my-formatter | au!")
do
  vim.cmd("autocmd BufWritePost *.fnl,*.go  :silent FormatWrite")
end
return vim.cmd("augroup END")
