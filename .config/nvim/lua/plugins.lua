local packer = require("packer")
local function safe_require_plugin_config(name)
  local ok_3f, val_or_err = pcall(require, ("plugin." .. name))
  if not ok_3f then
    return print(("plugin config error: " .. val_or_err))
  end
end
local function use(pkgs)
  local function _2_(use0, use_rocks)
    for name, opts in pairs(pkgs) do
      do
        local _3_ = opts.require
        if _3_ then
          safe_require_plugin_config(_3_)
        else
        end
      end
      if opts.rock then
        use_rocks(name)
      else
        opts[1] = name
        use0(opts)
      end
    end
    return nil
  end
  return packer.startup(_2_)
end
return use({["AndrewRadev/linediff.vim"] = {require = "linediff"}, ["AndrewRadev/undoquit.vim"] = {require = "undoquit"}, ["andymass/vim-matchup"] = {}, ["bakpakin/fennel.vim"] = {}, ["camspiers/snap"] = {require = "snap"}, ["ggandor/lightspeed.nvim"] = {require = "lightspeed"}, ["hrsh7th/nvim-compe"] = {require = "compe"}, ["mbbill/undotree"] = {}, ["mhartington/formatter.nvim"] = {require = "formatter"}, ["nkrkv/nvim-treesitter-rescript"] = {}, ["nvim-treesitter/nvim-treesitter"] = {branch = "0.5-compat", require = "nvim_treesitter"}, ["nvim-treesitter/playground"] = {}, ["rescript-lang/vim-rescript"] = {}, ["romgrk/equal.operator"] = {}, ["tommcdo/vim-exchange"] = {}, ["tpope/vim-commentary"] = {}, ["tpope/vim-repeat"] = {}, ["tpope/vim-sleuth"] = {}, ["tpope/vim-surround"] = {}, ["wbthomason/packer.nvim"] = {}, ["wellle/targets.vim"] = {}, ["~/code/edir"] = {require = "edir"}, ["~/code/nvim-filetree"] = {require = "filetree"}, fzy = {rock = true}})
