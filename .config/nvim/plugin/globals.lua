local print_ORIG = _G.print
local function print_PATCHED(...)
  local args = {}
  local num_args = select("#", ...)
  for i = 1, num_args do
    local arg = select(i, ...)
    if ("table" == type(arg)) then
      table.insert(args, vim.inspect(arg))
    elseif ("nil" == type(arg)) then
      table.insert(args, "nil")
    else
      table.insert(args, arg)
    end
  end
  return print_ORIG(unpack(args))
end
_G.print = print_PATCHED
return nil
