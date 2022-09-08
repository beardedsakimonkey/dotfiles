vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.did_install_default_menus = 1
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
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
require_safe("plugins")
return require_safe("statusline")
