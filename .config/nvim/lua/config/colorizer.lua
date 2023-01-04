local util = require'util'

-- Workaround for https://github.com/norcalli/nvim-colorizer.lua/issues/35
local function reload_colorizer()
  package.loaded.colorizer = nil
  require'colorizer'
  vim.cmd ':ColorizerAttachToBuffer'
end

local au = util.augroup'my/colorizer'

au('BufEnter', {'rgb.txt', 'papyrus.lua'}, ':ColorizerAttachToBuffer')
au('BufWritePost', {'rgb.txt', 'papyrus.lua'}, reload_colorizer)
