local formatter = require("formatter")
local function fnlfmt()
  return {args = {vim.api.nvim_buf_get_name(0)}, exe = "fnlfmt", stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}}})
local function format_write()
  return vim.cmd(":silent FormatWrite")
end
_G["my__au__format_write"] = format_write
return vim.cmd("autocmd BufWritePost *.fnl  lua my__au__format_write()")
