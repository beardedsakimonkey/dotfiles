local path = (vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim")
local bootstrap_3f = not vim.loop.fs_access(path, "R")
if bootstrap_3f then
  os.execute(("git clone --depth=1 https://github.com/wbthomason/packer.nvim " .. path))
  do end (vim.opt.runtimepath):prepend((vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath))
else
end
local packer = require("packer")
local function use(pkgs)
  local function _2_(use0)
    for name, opts in pairs(pkgs) do
      opts[1] = name
      use0(opts)
    end
    return nil
  end
  return packer.startup(_2_)
end
use({["wbthomason/packer.nvim"] = {}, ["neovim/nvim-lspconfig"] = {config = "require'config.lsp'"}, ["beardedsakimonkey/nvim-udir"] = {config = "require'config.udir'", branch = "config"}, ["mhartington/formatter.nvim"] = {config = "require'config.formatter'", opt = true, ft = {"fennel", "go"}}, ["ggandor/lightspeed.nvim"] = {config = "require'config.lightspeed'"}, ["beardedsakimonkey/snap"] = {config = "require'config.snap'"}, ["jose-elias-alvarez/minsnip.nvim"] = {config = "require'config.minsnip'", commit = "6ae2f32"}, ["norcalli/nvim-colorizer.lua"] = {setup = "require'config.colorizer'", opt = true, cmd = "ColorizerAttachToBuffer"}, ["Darazaki/indent-o-matic"] = {commit = "f7d4382"}, ["kylechui/nvim-surround"] = {config = "require'config.surround'"}, ["nvim-treesitter/nvim-treesitter"] = {config = "require'config.treesitter'", run = ":TSUpdate"}, ["nvim-treesitter/playground"] = {opt = true, ft = "query", cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}, after = "nvim-treesitter"}, ["nvim-treesitter/nvim-treesitter-textobjects"] = {}, ["nkrkv/nvim-treesitter-rescript"] = {opt = true, ft = "rescript", after = "nvim-treesitter", run = ":TSUpdate"}, ["windwp/nvim-ts-autotag"] = {config = "require'nvim-ts-autotag'.setup()", opt = true, ft = {"html", "rescript", "typescript", "javascript"}, after = "nvim-treesitter"}, ["hrsh7th/nvim-cmp"] = {config = "require'config.cmp'"}, ["hrsh7th/cmp-buffer"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-nvim-lua"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-path"] = {after = "nvim-cmp"}, ["hrsh7th/cmp-nvim-lsp"] = {}, ["farmergreg/vim-lastplace"] = {commit = "cef9d62"}, ["mbbill/undotree"] = {opt = true, cmd = "UndotreeToggle"}, ["tommcdo/vim-exchange"] = {opt = true, keys = "cx"}, ["dstein64/vim-startuptime"] = {opt = true, cmd = "StartupTime"}, ["AndrewRadev/linediff.vim"] = {config = "require'config.linediff'", opt = true, keys = {{"v", "D"}}}, ["tommcdo/vim-lion"] = {opt = true, keys = {"gl", "gL"}, config = "vim.g.lion_squeeze_spaces = 1"}, ["AndrewRadev/undoquit.vim"] = {config = "require'config.undoquit'"}, ["tpope/vim-commentary"] = {}, ["tpope/vim-repeat"] = {}, ["rescript-lang/vim-rescript"] = {opt = true, ft = "rescript"}, ["gpanders/fennel-repl.nvim"] = {opt = true, cmd = "FennelRepl", ft = "fennel"}, ["beardedsakimonkey/nvim-antifennel"] = {opt = true, cmd = "Antifennel"}})
if bootstrap_3f then
  return packer.sync()
else
  return nil
end
