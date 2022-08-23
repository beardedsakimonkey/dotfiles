local s_5c = vim.fn.shellescape
local f_5c = vim.fn.fnameescape
local function f_exists_3f(path)
  return (true == vim.loop.fs_access(path, "R"))
end
return {["s\\"] = s_5c, ["f\\"] = f_5c, ["f-exists?"] = f_exists_3f}
