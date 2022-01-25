-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/tim/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/tim/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/tim/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/tim/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/tim/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["cmp-buffer"] = {
    after_files = { "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    after_files = { "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    after_files = { "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["fennel.vim"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/fennel.vim",
    url = "https://github.com/bakpakin/fennel.vim"
  },
  ["formatter.nvim"] = {
    config = { "require'config.formatter'" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["lightspeed.nvim"] = {
    config = { "require'config.lightspeed'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["linediff.vim"] = {
    config = { "require'config.linediff'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/linediff.vim",
    url = "https://github.com/AndrewRadev/linediff.vim"
  },
  ["minsnip.nvim"] = {
    config = { "require'config.minsnip'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/minsnip.nvim",
    url = "https://github.com/jose-elias-alvarez/minsnip.nvim"
  },
  ["nvim-cmp"] = {
    after = { "cmp-cmdline", "cmp-nvim-lua", "cmp-path", "cmp-buffer" },
    loaded = true,
    only_config = true
  },
  ["nvim-colorizer.lua"] = {
    commands = { "ColorizerAttachToBuffer" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    config = { "require'config.lspconfig'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "require'config.nvim-treesitter'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-rescript"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-rescript",
    url = "https://github.com/nkrkv/nvim-treesitter-rescript"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  snap = {
    config = { "require'config.snap'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/snap",
    url = "https://github.com/camspiers/snap"
  },
  ["targets.vim"] = {
    config = { "require'config.targets'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  udir = {
    config = { "require'config.udir'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/udir",
    url = "/Users/tim/code/udir"
  },
  ["undoquit.vim"] = {
    config = { "require'config.undoquit'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/undoquit.vim",
    url = "https://github.com/AndrewRadev/undoquit.vim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/opt/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-exchange"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-exchange",
    url = "https://github.com/tommcdo/vim-exchange"
  },
  ["vim-glsl"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-glsl",
    url = "https://github.com/tikhomirov/vim-glsl"
  },
  ["vim-matchup"] = {
    config = { "require'config.matchup'" },
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rescript"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-rescript",
    url = "https://github.com/rescript-lang/vim-rescript"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-sleuth",
    url = "https://github.com/tpope/vim-sleuth"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/tim/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: nvim-colorizer.lua
time([[Setup for nvim-colorizer.lua]], true)
require'config.colorizer'
time([[Setup for nvim-colorizer.lua]], false)
-- Config for: undoquit.vim
time([[Config for undoquit.vim]], true)
require'config.undoquit'
time([[Config for undoquit.vim]], false)
-- Config for: linediff.vim
time([[Config for linediff.vim]], true)
require'config.linediff'
time([[Config for linediff.vim]], false)
-- Config for: snap
time([[Config for snap]], true)
require'config.snap'
time([[Config for snap]], false)
-- Config for: minsnip.nvim
time([[Config for minsnip.nvim]], true)
require'config.minsnip'
time([[Config for minsnip.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require'config.cmp'
time([[Config for nvim-cmp]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require'config.nvim-treesitter'
time([[Config for nvim-treesitter]], false)
-- Config for: targets.vim
time([[Config for targets.vim]], true)
require'config.targets'
time([[Config for targets.vim]], false)
-- Config for: lightspeed.nvim
time([[Config for lightspeed.nvim]], true)
require'config.lightspeed'
time([[Config for lightspeed.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
require'config.lspconfig'
time([[Config for nvim-lspconfig]], false)
-- Config for: udir
time([[Config for udir]], true)
require'config.udir'
time([[Config for udir]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
require'config.matchup'
time([[Config for vim-matchup]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd cmp-buffer ]]
vim.cmd [[ packadd cmp-cmdline ]]
vim.cmd [[ packadd cmp-nvim-lua ]]
vim.cmd [[ packadd cmp-path ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ColorizerAttachToBuffer lua require("packer.load")({'nvim-colorizer.lua'}, { cmd = "ColorizerAttachToBuffer", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType rescript ++once lua require("packer.load")({'nvim-treesitter-rescript'}, { ft = "rescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType fennel ++once lua require("packer.load")({'formatter.nvim'}, { ft = "fennel" }, _G.packer_plugins)]]
vim.cmd [[au FileType go ++once lua require("packer.load")({'formatter.nvim'}, { ft = "go" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
