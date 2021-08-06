local _2afile_2a = ".config/nvim/fnl/options.fnl"
local _0_
do
  local name_0_ = "options"
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
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "options"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
vim.go.shada = "!,'1000,<50,s10,h"
vim.go.display = "msgsep"
vim.go.inccommand = "nosplit"
vim.go.lazyredraw = true
vim.go.ttimeout = true
vim.go.ttimeoutlen = 0
vim.go.timeoutlen = 3000
vim.go.mouse = "a"
vim.go.synmaxcol = 500
vim.cmd("let &t_8f = \"\\<Esc>[38;2;%lu;%lu;%lum\"")
vim.cmd("let &t_8b = \"\\<Esc>[48;2;%lu;%lu;%lum\"")
vim.go.termguicolors = true
vim.cmd("let &t_ti.=\"\\<Esc>[2 q\"")
vim.cmd("let &t_SI.=\"\\<Esc>[6 q\"")
vim.cmd("let &t_SR.=\"\\<Esc>[4 q\"")
vim.cmd("let &t_EI.=\"\\<Esc>[2 q\"")
vim.cmd("let &t_te.=\"\\<Esc>[0 q\"")
vim.go.hidden = true
vim.go.confirm = true
vim.go.swapfile = false
vim.go.backup = false
vim.go.undofile = true
if not vim.fn.isdirectory(vim.go.undodir) then
  vim.cmd("call mkdir(&undodir, 'p', 0700)")
end
vim.go.splitright = true
vim.go.splitbelow = true
vim.go.winminheight = 0
vim.go.winminwidth = 0
vim.go.joinspaces = false
vim.bo.autoindent = true
vim.go.shiftround = true
vim.go.smarttab = true
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = -1
vim.go.hlsearch = true
vim.go.incsearch = true
vim.go.ignorecase = true
vim.bo.infercase = true
vim.go.smartcase = true
return nil