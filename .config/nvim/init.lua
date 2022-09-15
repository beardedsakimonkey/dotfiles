local _local_1_ = require("util")
local exists_3f = _local_1_["exists?"]
local path = (vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim")
if not exists_3f(path) then
  os.execute(("git clone --depth=1 https://github.com/beardedsakimonkey/packer.nvim " .. path))
  do end (vim.opt.runtimepath):prepend((vim.fn.stdpath("data") .. "/site/pack/*/start/*"))
  require("plugins")
  local packer = require("packer")
  packer.sync()
else
end
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_node_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_python3_provider = 1
vim.g.loaded_ruby_provider = 1
vim.cmd("colorscheme navajo")
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.cmd("syntax enable")
local function require_safe(mod)
  local ok_3f, msg = pcall(require, mod)
  if not ok_3f then
    return vim.api.nvim_err_writeln(("Config error in %s: %s"):format(mod, msg))
  else
    return nil
  end
end
require_safe("mappings")
require_safe("options")
require_safe("autocmds")
require_safe("statusline")
return require_safe("commands")
