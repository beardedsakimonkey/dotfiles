local udir = require("udir")
local m = udir.map
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
local function some_3f(list, pred_3f)
  local found = false
  for _, v in ipairs(list) do
    if found then break end
    if pred_3f(v) then
      found = true
    else
    end
  end
  return found
end
local function is_file_hidden(file, files, _cwd)
  local ext = string.match(file.name, "%.(%w-)$")
  local _3_ = ext
  if (_3_ == "lua") then
    local fnl = string.gsub(file.name, "lua$", "fnl")
    local function _4_(_241)
      return (fnl == _241.name)
    end
    return some_3f(files, _4_)
  elseif (_3_ == "js") then
    local res = string.gsub(file.name, "js$", "res")
    local function _5_(_241)
      return (res == _241.name)
    end
    return some_3f(files, _5_)
  elseif true then
    local _ = _3_
    return endswith_any(file.name, {".bs.js", ".o"})
  else
    return nil
  end
end
local function cd(cmd)
  local store = require("udir.store")
  local state = store.get()
  vim.cmd((cmd .. " " .. vim.fn.fnameescape(state.cwd)))
  return vim.cmd("pwd")
end
local function _7_()
  return cd("cd")
end
local function _8_()
  return cd("lcd")
end
udir.setup({auto_open = true, show_hidden_files = false, is_file_hidden = is_file_hidden, keymaps = {q = m.quit, h = m.up_dir, ["-"] = m.up_dir, l = m.open, i = m.open, ["<CR>"] = m.open, s = m.open_split, v = m.open_vsplit, ["<C-t>"] = m.open_tab, R = m.reload, r = m.move, d = m.delete, ["+"] = m.create, m = m.move, c = m.copy, C = _7_, L = _8_, gh = m.toggle_hidden_files}})
return vim.keymap.set("n", "-", "<Cmd>Udir<CR>", {})
