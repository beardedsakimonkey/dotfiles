local function reload_colorizer()
  package.loaded.colorizer = nil
  require("colorizer")
  return vim.cmd(":ColorizerAttachToBuffer")
end
vim.api.nvim_create_augroup("my/colorizer", {clear = true})
local _1_ = "my/colorizer"
vim.api.nvim_create_autocmd("BufEnter", {command = ":ColorizerAttachToBuffer", group = _1_, pattern = {"rgb.txt", "papyrus.fnl"}})
vim.api.nvim_create_autocmd("BufWritePost", {callback = reload_colorizer, group = _1_, pattern = {"rgb.txt", "papyrus.fnl"}})
return _1_
