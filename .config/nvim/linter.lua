local function descend(target, _1_)
  local _arg_2_ = _1_
  local part = _arg_2_[1]
  local parts = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_2_, 2)
  if (nil == part) then
    return target
  elseif ("table" == type(target)) then
    local _3_ = target[part]
    if (nil ~= _3_) then
      local new_target = _3_
      return descend(new_target, parts)
    else
      return nil
    end
  else
    return target
  end
end
local function set_set_meta(to, scope, opts)
  if not (opts.declaration or __fnl_global__multi_2dsym_3f(to)) then
    if __fnl_global__sym_3f(to) then
      scope.symmeta[tostring(to)]["set"] = true
      return nil
    else
      for _, sub in ipairs(to) do
        set_set_meta(sub, scope, opts)
      end
      return nil
    end
  else
    return nil
  end
end
local function save_meta(from, to, scope, opts)
  if (__fnl_global__sym_3f(to) and not __fnl_global__multi_2dsym_3f(to) and __fnl_global__list_3f(from) and __fnl_global__sym_3f(from[1]) and ("require" == tostring(from[1])) and ("string" == type(from[2]))) then
    local meta = scope.symmeta[tostring(to)]
    meta.required = tostring(from[2])
  else
  end
  return set_set_meta(to, scope, opts)
end
local function has_fields_3f(module_name, parts)
  local module = (module_name and require(module_name))
  local target = descend(module, parts)
  return ((nil == module) or (nil ~= target))
end
local function check_module_fields(symbol, scope)
  local _let_9_ = (__fnl_global__multi_2dsym_3f(symbol) or {})
  local module_local = _let_9_[1]
  local parts = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_9_, 2)
  local module_name
  do
    local _10_ = scope.symmeta
    if (nil ~= _10_) then
      local _11_ = (_10_)[tostring(module_local)]
      if (nil ~= _11_) then
        module_name = (_11_).required
      else
        module_name = _11_
      end
    else
      module_name = _10_
    end
  end
  local field = table.concat(parts, ".")
  local has_fields = has_fields_3f(module_name, parts)
  if (not has_fields and (nil ~= package.loaded[module_name])) then
    package.loaded[module_name] = nil
    has_fields = has_fields_3f(module_name, parts)
  else
  end
  return __fnl_global__assert_2dcompile(has_fields, string.format("Missing field %s in module %s", (field or "?"), (module_name or "?")), symbol)
end
local function arity_check_3f(module, module_name)
  local function _15_()
    local _16_ = module
    if (nil ~= _16_) then
      local _17_ = getmetatable(_16_)
      if (nil ~= _17_) then
        return (_17_)["arity-check?"]
      else
        return _17_
      end
    else
      return _16_
    end
  end
  local function _20_()
    return nil
  end
  local function _21_()
    local _22_ = (module_name and os and os.getenv and os.getenv("FENNEL_LINT_MODULES"))
    if (nil ~= _22_) then
      local module_pattern = _22_
      return module_name:find(module_pattern)
    else
      return nil
    end
  end
  return (_15_() or pcall(debug.getlocal, _20_, 1) or _21_())
end
local function min_arity(target, nparams)
  local _24_ = debug.getlocal(target, nparams)
  if (nil ~= _24_) then
    local localname = _24_
    if (localname:match("^_3f") and (0 < nparams)) then
      return min_arity(target, (nparams - 1))
    else
      return nparams
    end
  elseif true then
    local _ = _24_
    return nparams
  else
    return nil
  end
end
local function getfn(v)
  if ("function" == type(v)) then
    return {v, false}
  else
    local mt = getmetatable(v)
    if (("table" == type(v)) and ("table" == type(mt)) and ("function" == type(mt.__call))) then
      return {mt.__call, true}
    else
      return {v, false}
    end
  end
end
local function arity_check_call(_29_, scope)
  local _arg_30_ = _29_
  local f = _arg_30_[1]
  local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_30_, 2)
  local last_arg = args[#args]
  local arity
  if tostring(f):find(":") then
    arity = (#args + 1)
  else
    arity = #args
  end
  local _let_32_ = (__fnl_global__multi_2dsym_3f(f) or {})
  local f_local = _let_32_[1]
  local parts = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_32_, 2)
  local module_name
  do
    local _33_ = scope.symmeta
    if (nil ~= _33_) then
      local _34_ = (_33_)[tostring(f_local)]
      if (nil ~= _34_) then
        module_name = (_34_).required
      else
        module_name = _34_
      end
    else
      module_name = _33_
    end
  end
  local module = (module_name and require(module_name))
  local field = table.concat(parts, ".")
  local _let_37_ = getfn(descend(module, parts))
  local target = _let_37_[1]
  local is_metamethod = _let_37_[2]
  local arity0
  if is_metamethod then
    arity0 = (1 + arity)
  else
    arity0 = arity
  end
  if (arity_check_3f(module, module_name) and _G.debug and _G.debug.getinfo and module and not __fnl_global__varg_3f(last_arg) and not __fnl_global__list_3f(last_arg)) then
    __fnl_global__assert_2dcompile(("function" == type(target)), string.format("Missing function %s in module %s", (field or "?"), module_name), f)
    local _39_ = _G.debug.getinfo(target)
    if ((_G.type(_39_) == "table") and (nil ~= (_39_).nparams) and ((_39_).what == "Lua")) then
      local nparams = (_39_).nparams
      local min = min_arity(target, nparams)
      return __fnl_global__assert_2dcompile((min <= arity0), ("Called %s with %s arguments, expected at least %s"):format(f, arity0, min), f)
    else
      return nil
    end
  else
    return nil
  end
end
local function local_3f(ast, name)
  return (("table" == type(ast)) and ("table" == type(ast[1])) and (("local" == ast[1][1]) or ("var" == ast[1][1])) and ("table" == type(ast[2])) and (name == ast[2][1]))
end
local function find_local(ast, name)
  if (not ast or ("table" ~= type(ast))) then
    return nil
  else
    if local_3f(ast, name) then
      return ast
    else
      local _3fres = nil
      for _, v in ipairs(ast) do
        if _3fres then break end
        _3fres = find_local(v, name)
      end
      return _3fres
    end
  end
end
local function check_unused(ast, scope)
  for symname in pairs(scope.symmeta) do
    local valid_3f = (scope.symmeta[symname].used or symname:find("^_"))
    if not valid_3f then
      local name = (symname or "?")
      __fnl_global__assert_2dcompile(false, ("unused local %s"):format(name), (find_local(ast, name) or ast))
    else
    end
  end
  return nil
end
return {destructure = save_meta, ["symbol-to-expression"] = check_module_fields, call = arity_check_call, fn = check_unused, ["do"] = check_unused, chunk = check_unused, name = "my/linter", versions = {"1.0.0", "1.1.0", "1.2.0", "1.3.0"}}
