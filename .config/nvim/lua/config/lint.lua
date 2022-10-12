local lint = require("lint")
do end (lint)["linters_by_ft"]["lua"] = {"luacheck"}
vim.api.nvim_create_augroup("my/lint", {clear = true})
local _1_ = "my/lint"
local function _2_()
  return lint.try_lint(nil, nil)
end
vim.api.nvim_create_autocmd("BufWritePost", {callback = _2_, group = _1_, pattern = "*.lua"})
return _1_
