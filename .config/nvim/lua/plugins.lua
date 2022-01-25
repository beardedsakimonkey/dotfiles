local packer = require("packer")
local function use(pkgs)
  local function _1_(use0, use_rocks)
    for name, opts in pairs(pkgs) do
      opts[1] = name
      use0(opts)
    end
    return nil
  end
  return packer.startup(_1_)
end
return use({["AndrewRadev/linediff.vim"] = {config = "require'config.linediff'"}, ["AndrewRadev/undoquit.vim"] = {config = "require'config.undoquit'"}, ["andymass/vim-matchup"] = {config = "require'config.matchup'"}, ["bakpakin/fennel.vim"] = {}, ["camspiers/snap"] = {config = "require'config.snap'", rocks = "fzy"}, ["ggandor/lightspeed.nvim"] = {config = "require'config.lightspeed'"}, ["hrsh7th/cmp-buffer"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-cmdline"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-nvim-lsp"] = {}, ["hrsh7th/cmp-nvim-lua"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-path"] = {after = "nvim-cmp"}, ["hrsh7th/nvim-cmp"] = {config = "require'config.cmp'"}, ["jose-elias-alvarez/minsnip.nvim"] = {config = "require'config.minsnip'"}, ["lewis6991/impatient.nvim"] = {}, ["mbbill/undotree"] = {cmd = {"UndotreeToggle"}, opt = true}, ["mhartington/formatter.nvim"] = {config = "require'config.formatter'", ft = {"fennel", "go"}, opt = true}, ["neovim/nvim-lspconfig"] = {config = "require'config.lspconfig'"}, ["nkrkv/nvim-treesitter-rescript"] = {ft = "rescript", opt = true}, ["norcalli/nvim-colorizer.lua"] = {cmd = "ColorizerAttachToBuffer", opt = true, setup = "require'config.colorizer'"}, ["nvim-treesitter/nvim-treesitter"] = {branch = "0.5-compat", config = "require'config.nvim-treesitter'", run = ":TSUpdate"}, ["nvim-treesitter/playground"] = {cmd = "TSPlaygroundToggle", opt = true}, ["rescript-lang/vim-rescript"] = {}, ["tikhomirov/vim-glsl"] = {}, ["tommcdo/vim-exchange"] = {}, ["tpope/vim-commentary"] = {}, ["tpope/vim-repeat"] = {}, ["tpope/vim-sleuth"] = {}, ["tpope/vim-surround"] = {}, ["wbthomason/packer.nvim"] = {}, ["wellle/targets.vim"] = {config = "require'config.targets'"}, ["~/code/udir"] = {config = "require'config.udir'"}})
