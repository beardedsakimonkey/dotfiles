-- Workaround for https://github.com/norcalli/nvim-colorizer.lua/issues/35
local function reload_colorizer()
  package.loaded.colorizer = nil
  require("colorizer")
  vim.cmd(":ColorizerAttachToBuffer")
end
local AUGROUP = "my/colorizer"
vim.api.nvim_create_augroup(AUGROUP, {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {command = ":ColorizerAttachToBuffer", group = AUGROUP, pattern = {"rgb.txt", "papyrus.lua"}})
vim.api.nvim_create_autocmd("BufWritePost", {callback = reload_colorizer, group = AUGROUP, pattern = {"rgb.txt", "papyrus.lua"}})
