local lint = require("lint")
do end (lint)["linters_by_ft"]["lua"] = {"luacheck"}
local function clear_diagnostics()
  local ns = vim.api.nvim_get_namespaces()
  if ns.luacheck then
    return vim.api.nvim_buf_clear_namespace(0, ns.luacheck, 0, -1)
  else
    return nil
  end
end
local function _2_()
  clear_diagnostics()
  vim.g.lint_disabled = true
  return nil
end
vim.api.nvim_create_user_command("LintDisable", _2_, {})
local function _3_()
  vim.g.lint_disabled = false
  return nil
end
vim.api.nvim_create_user_command("LintEnable", _3_, {})
vim.api.nvim_create_augroup("my/lint", {clear = true})
local _4_ = "my/lint"
local function _5_()
  if not vim.g.lint_disabled then
    return lint.try_lint(nil, nil)
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("BufWritePost", {callback = _5_, group = _4_, pattern = "*.lua"})
return _4_
