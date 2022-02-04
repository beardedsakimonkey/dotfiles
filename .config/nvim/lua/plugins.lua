local packer = require("packer")
local function use(pkgs)
  local function _1_()
    for name, opts in pairs(pkgs) do
      opts[1] = name
      packer.use(opts)
    end
    return nil
  end
  return packer.startup(_1_)
end
return use({["wbthomason/packer.nvim"] = {}, ["mhartington/formatter.nvim"] = {config = "require'config.formatter'", opt = true, ft = {"fennel", "go"}}, ["ggandor/lightspeed.nvim"] = {config = "require'config.lightspeed'"}, ["camspiers/snap"] = {config = "require'config.snap'", rocks = "fzy"}, ["jose-elias-alvarez/minsnip.nvim"] = {config = "require'config.minsnip'"}, ["norcalli/nvim-colorizer.lua"] = {setup = "require'config.colorizer'", opt = true, cmd = "ColorizerAttachToBuffer"}, ["nvim-treesitter/nvim-treesitter"] = {config = "require'config.treesitter'", run = ":TSUpdate"}, ["nvim-treesitter/playground"] = {opt = true, cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}, after = "nvim-treesitter"}, ["nkrkv/nvim-treesitter-rescript"] = {opt = true, ft = "rescript", after = "nvim-treesitter"}, ["windwp/nvim-ts-autotag"] = {config = "require'nvim-ts-autotag'.setup()", after = "nvim-treesitter"}, ["neovim/nvim-lspconfig"] = {config = "require'config.lsp'"}, ["j-hui/fidget.nvim"] = {config = "require'fidget'.setup{}"}, ["hrsh7th/nvim-cmp"] = {config = "require'config.cmp'"}, ["hrsh7th/cmp-buffer"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-nvim-lua"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-path"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-nvim-lsp"] = {}, ["mbbill/undotree"] = {opt = true, cmd = "UndotreeToggle"}, ["tommcdo/vim-exchange"] = {keys = "cx"}, ["wellle/targets.vim"] = {config = "require'config.targets'"}, ["AndrewRadev/linediff.vim"] = {config = "require'config.linediff'", opt = true, keys = {{"v", "D"}}}, ["AndrewRadev/undoquit.vim"] = {config = "require'config.undoquit'"}, ["tpope/vim-commentary"] = {opt = true, keys = "gc"}, ["tpope/vim-surround"] = {}, ["tpope/vim-sleuth"] = {}, ["tpope/vim-repeat"] = {}, ["bakpakin/fennel.vim"] = {}, ["gpanders/fennel-repl.nvim"] = {opt = true, cmd = "FennelRepl"}, ["rescript-lang/vim-rescript"] = {opt = true, ft = "rescript"}, ["~/code/udir"] = {config = "require'config.udir'"}})
