local udir = require("udir")
local u = require("udir.util")
local _local_1_ = require("util")
local some_3f = _local_1_["some?"]
local function endswith_any(str, suffixes)
  local found = false
  for _, suf in ipairs(suffixes) do
    if found then break end
    if vim.endswith(str, suf) then
      found = true
    else
    end
  end
  return found
end
local function is_file_hidden(file, files, _cwd)
  local hidden_3f = false
  local ext = string.match(file.name, "%.(%w-)$")
  if ("lua" == ext) then
    local fnl = string.gsub(file.name, "lua$", "fnl")
    local function _3_(_241)
      return (fnl == _241.name)
    end
    hidden_3f = (hidden_3f or some_3f(files, _3_))
  else
  end
  if ("js" == ext) then
    local res = string.gsub(file.name, "js$", "res")
    local function _5_(_241)
      return (res == _241.name)
    end
    hidden_3f = (hidden_3f or some_3f(files, _5_))
  else
  end
  hidden_3f = (hidden_3f or endswith_any(file.name, {".bs.js", ".o"}) or (".git" == file.name))
  return hidden_3f
end
local function cd(cmd)
  local store = require("udir.store")
  local state = store.get()
  vim.cmd((cmd .. " " .. vim.fn.fnameescape(state.cwd)))
  return vim.cmd("pwd")
end
local function sort_by_mtime(files)
  local store = require("udir.store")
  local _local_7_ = store.get()
  local cwd = _local_7_["cwd"]
  local mtimes = {}
  for _, file in ipairs(files) do
    local _3fstat = vim.loop.fs_stat(u["join-path"](cwd, file.name))
    local mtime
    if _3fstat then
      mtime = _3fstat.mtime.sec
    else
      mtime = 0
    end
    mtimes[file.name] = mtime
  end
  local function _9_(_241, _242)
    if (("directory" == _241.type) == ("directory" == _242.type)) then
      return (mtimes[_241.name] > mtimes[_242.name])
    else
      return ("directory" == _241.type)
    end
  end
  return table.sort(files, _9_)
end
local default_sort = udir.config.sort
local default_sort_3f = true
local function toggle_sort()
  local sort
  if default_sort_3f then
    sort = sort_by_mtime
  else
    sort = default_sort
  end
  default_sort_3f = not default_sort_3f
  udir.config["sort"] = sort
  return udir.reload()
end
local function _12_()
  return udir.open("split")
end
local function _13_()
  return udir.open("vsplit")
end
local function _14_()
  return udir.open("tabedit")
end
local function _15_()
  return cd("cd")
end
local function _16_()
  return cd("lcd")
end
udir["config"] = {is_file_hidden = is_file_hidden, keymaps = {q = udir.quit, h = udir.up_dir, ["-"] = udir.up_dir, l = udir.open, ["<CR>"] = udir.open, i = udir.open, s = _12_, v = _13_, t = _14_, R = udir.reload, d = udir.delete, ["+"] = udir.create, m = udir.move, r = udir.move, c = udir.copy, gh = udir.toggle_hidden_files, T = toggle_sort, C = _15_, L = _16_}, sort = default_sort, show_hidden_files = false}
return vim.keymap.set("n", "-", "<Cmd>Udir<CR>", {})
