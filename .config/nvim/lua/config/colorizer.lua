local function reload_colorizer()
  package.loaded.colorizer = nil
  require("colorizer")
  return vim.cmd(":ColorizerAttachToBuffer")
end
vim.cmd("augroup my-colorizer | au!")
do
  vim.cmd("autocmd BufEnter rgb.txt,navajo.fnl  :ColorizerAttachToBuffer")
end
do
  _G["my__au__reload_colorizer"] = reload_colorizer
  vim.cmd("autocmd BufWritePost rgb.txt,navajo.fnl  lua my__au__reload_colorizer()")
end
return vim.cmd("augroup END")
