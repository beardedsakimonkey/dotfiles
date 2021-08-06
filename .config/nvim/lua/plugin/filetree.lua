local _2afile_2a = ".config/nvim/fnl/plugin/filetree.fnl"
local _0_
do
  local name_0_ = "plugin.filetree"
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
    return {require("filetree")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {filetree = "filetree"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local filetree = _local_0_[1]
local _2amodule_2a = _0_
local _2amodule_name_2a = "plugin.filetree"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function no(mode, lhs, rhs, opt)
  local opts = vim.tbl_extend("force", {noremap = true}, (opt or {}))
  return vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
filetree.init()
no("n", "-", ":<C-u>Filetree<CR>")
vim.cmd("au vimrc StdinReadPost * let s:has_stdin = 1")
return vim.cmd("au vimrc VimEnter * if !argc() && !has_key(s:, 'has_stdin') && !empty(glob('*', 1, 1)) | silent! Filetree | endif")