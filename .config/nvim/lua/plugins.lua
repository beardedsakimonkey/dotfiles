local _2afile_2a = ".config/nvim/fnl/plugins.fnl"
local _0_
do
  local name_0_ = "plugins"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {autoload("aniseed.core"), autoload("packer")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {autoload = {core = "aniseed.core", packer = "packer"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local core = _local_0_[1]
local packer = _local_0_[2]
local _2amodule_2a = _0_
local _2amodule_name_2a = "plugins"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function safe_require_plugin_config(name)
  local ok_3f, val_or_err = pcall(require, ("plugin." .. name))
  if not ok_3f then
    return print(("dotfiles error: " .. val_or_err))
  end
end
local function use(...)
  local pkgs = {...}
  local function _3_(use0, use_rocks)
    for i = 1, core.count(pkgs), 2 do
      local name = pkgs[i]
      local opts = pkgs[(i + 1)]
      do
        local _4_ = opts.mod
        if _4_ then
          safe_require_plugin_config(_4_)
        else
        end
      end
      if opts.rock then
        use_rocks(name)
      else
        use0(core.assoc(opts, 1, name))
      end
    end
    return nil
  end
  return packer.startup(_3_)
end
return use("wbthomason/packer.nvim", {}, "Olical/aniseed", {}, "Olical/conjure", {}, "mhartington/formatter.nvim", {mod = "formatter"}, "hrsh7th/nvim-compe", {mod = "compe"}, "tami5/compe-conjure", {}, "camspiers/snap", {mod = "snap"}, "fzy", {rock = true}, "~/code/nvim-filetree", {mod = "filetree"}, "mbbill/undotree", {}, "tommcdo/vim-exchange", {}, "wellle/targets.vim", {}, "andymass/vim-matchup", {}, "AndrewRadev/linediff.vim", {}, "AndrewRadev/undoquit.vim", {mod = "undoquit"}, "tpope/vim-commentary", {}, "tpope/vim-surround", {}, "tpope/vim-sleuth", {}, "tpope/vim-repeat", {})