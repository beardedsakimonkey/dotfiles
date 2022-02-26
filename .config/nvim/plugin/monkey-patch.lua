local print_ORIG = _G.print
local function print_PATCHED(...)
  local args
  local function _1_(_241)
    if ("table" == type(_241)) then
      return vim.inspect(_241)
    else
      return _241
    end
  end
  args = vim.tbl_map(_1_, {...})
  return print_ORIG(unpack(args))
end
_G.print = print_PATCHED
return nil
