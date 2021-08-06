local _2afile_2a = ".config/nvim/fnl/plugin/auto-session.fnl"
local _0_
do
  local name_0_ = "plugin.auto-session"
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
    return {autoload("auto-session")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {autoload = {["auto-session"] = "auto-session"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local auto_session = _local_0_[1]
local _2amodule_2a = _0_
local _2amodule_name_2a = "plugin.auto-session"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
return auto_session.setup({auto_restore_enabled = true, auto_save_enabled = true, auto_session_enable_last_session = false, auto_session_enabled = true})