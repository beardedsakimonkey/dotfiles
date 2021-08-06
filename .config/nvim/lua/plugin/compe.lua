local _2afile_2a = ".config/nvim/fnl/plugin/compe.fnl"
local _0_
do
  local name_0_ = "plugin.compe"
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
    return {autoload("compe")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {autoload = {compe = "compe"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local compe = _local_0_[1]
local _2amodule_2a = _0_
local _2amodule_name_2a = "plugin.compe"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
compe.setup({autocomplete = true, enabled = true, min_length = 2, preselect = "always", source = {buffer = true, nvim_lsp = true, path = true}})
vim.g.completion_chain_complete_list = {{complete_items = {"lsp"}}, {mode = "<c-p>"}, {mode = "<c-n>"}}
vim.g.completion_auto_change_source = 1
vim.g.completion_trigger_keyword_length = 1
vim.g.completion_enable_auto_signature = 0
vim.g.completion_enable_auto_hover = 0
vim.g.completion_confirm_key = "\\<c-i>"
vim.api.nvim_set_keymap("i", "<C-j>", "<C-n>", {noremap = true})
vim.api.nvim_set_keymap("i", "<C-k>", "<C-p>", {noremap = true})
return vim.api.nvim_set_keymap("i", "<Tab>", "compe#confirm('<tab>')", {expr = true, noremap = true})