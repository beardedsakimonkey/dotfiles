local function reload_colorizer()
  package.loaded.colorizer = nil
  require("colorizer")
  return vim.cmd(":ColorizerAttachToBuffer")
end
vim.api.nvim_create_augroup({clear = true, name = "my/colorizer"})
local _1_ = "my/colorizer"
vim.api.nvim_create_autocmd({command = ":ColorizerAttachToBuffer", event = "BufEnter", group = _1_, pattern = {"rgb.txt", "navajo.fnl"}})
vim.api.nvim_create_autocmd({callback = reload_colorizer, event = "BufWritePost", group = _1_, pattern = {"rgb.txt", "navajo.fnl"}})
return _1_
