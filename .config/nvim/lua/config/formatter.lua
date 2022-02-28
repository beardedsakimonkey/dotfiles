local formatter = require("formatter")
local function fnlfmt()
  return {exe = "fnlfmt", args = {vim.api.nvim_buf_get_name(0)}, stdin = true}
end
local function gofmt()
  return {exe = "gofmt", args = {"-w"}, stdin = true}
end
formatter.setup({filetype = {fennel = {fnlfmt}, go = {gofmt}}})
vim.api.nvim_create_augroup({clear = true, name = "my/formatter"})
local _1_ = "my/formatter"
vim.api.nvim_create_autocmd({command = ":silent FormatWrite", event = "BufWritePost", group = _1_, pattern = {"*.fnl", "*.go"}})
return _1_
