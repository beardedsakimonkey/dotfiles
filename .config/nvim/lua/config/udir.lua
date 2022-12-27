local udir = require("udir")
local join_path = require("udir.util")["join-path"]

local function find(tbl, fn)
  for _, v in ipairs(tbl) do
    if fn(v) then
      return v
    end
  end
end

local function some(tbl, fn)
  return find(tbl, fn) ~= nil
end

local function endswith_any(str, suffixes)
  local found = false
  for _, suf in ipairs(suffixes) do
    if found then break end
    if vim.endswith(str, suf) then
      found = true
    end
  end
  return found
end

local function is_file_hidden(file, files)
  local is_hidden = false
  local ext = string.match(file.name, "%.(%w-)$")
  -- if "lua" == ext then
  --   local fnl = string.gsub(file.name, "lua$", "fnl")
  --   is_hidden = is_hidden or some(files, function(f)
  --     return fnl == f.name
  --   end)
  -- end
  if "js" == ext then
    local res = string.gsub(file.name, "js$", "res")
    is_hidden = is_hidden or some(files, function(f)
      return res == f.name
    end)
  end
  is_hidden = is_hidden or
            endswith_any(file.name, {".bs.js", ".o"}) or
            ".git" == file.name
  return is_hidden
end

local function cd(cmd)
  local store = require"udir.store"
  local state = store.get()
  vim.cmd(cmd .. " " .. vim.fn.fnameescape(state.cwd))
  vim.cmd("pwd")
end

local function sort_by_mtime(files)
  local store = require("udir.store")
  local cwd = store.get().cwd
  local mtimes = {}
  for _, file in ipairs(files) do
    --`fs_stat` fails in case of a broken symlink
    local fstat = vim.loop.fs_stat(join_path(cwd, file.name))
    mtimes[file.name] = fstat and fstat.mtime.sec or 0
  end
  table.sort(files, function(a, b)
    if ("directory" == a.type) == ("directory" == b.type) then
      return mtimes[a.name] > mtimes[b.name]
    else
      return "directory" == a.type
    end
  end)
end

local default_sort = udir.config.sort

local function toggle_sort()
  local new_sort
  if udir.config.sort == sort_by_mtime then
    new_sort = default_sort
  else
    new_sort = sort_by_mtime
  end
  udir.config["sort"] = new_sort
  udir.reload()
end

udir.config = {
  is_file_hidden = is_file_hidden,
  keymaps = {
    q = udir.quit,
    h = udir.up_dir,
    ["-"] = udir.up_dir,
    l = udir.open,
    ["<CR>"] = udir.open,
    i = udir.open,
    s = function() udir.open'split' end,
    v = function() udir.open'vsplit' end,
    t = function() udir.open'tabedit' end,
    R = udir.reload,
    d = udir.delete,
    ["+"] = udir.create,
    m = udir.move,
    r = udir.move,
    c = udir.copy,
    gh = udir.toggle_hidden_files,
    T = toggle_sort,
    C = function() cd'cd' end,
    L = function() cd'lcd' end,
  },
  sort = default_sort,
  show_hidden_files = false,
}

vim.keymap.set("n", "-", "<Cmd>Udir<CR>", {})
