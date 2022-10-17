local ufind = require("ufind")
local _local_1_ = require("util")
local _24HOME = _local_1_["$HOME"]
local exists_3f = _local_1_["exists?"]
local system = _local_1_["system"]
local function oldfiles()
  local blacklist = {}
  local oldfiles0
  local function _2_(file)
    return not blacklist[file]
  end
  local function _3_(file)
    if not file then
      return false
    else
      local not_wildignored
      local function _4_()
        return (0 == vim.fn.empty(vim.fn.glob(file)))
      end
      not_wildignored = _4_
      local not_dir
      local function _5_()
        return (0 == vim.fn.isdirectory(file))
      end
      not_dir = _5_
      local not_manpage
      local function _6_()
        return not vim.startswith(file, "man://")
      end
      not_manpage = _6_
      local keep = (not_wildignored() and not_dir() and not_manpage())
      if (keep and (nil ~= file:match("%.fnl$"))) then
        blacklist[file:gsub("%.fnl$", ".lua")] = true
      else
      end
      return keep
    end
  end
  oldfiles0 = vim.tbl_filter(_2_, vim.tbl_filter(_3_, vim.v.oldfiles))
  return ufind.open(oldfiles0, nil)
end
local uv = vim.loop
local function find()
  local cwd = vim.loop.cwd()
  local function ls(path)
    local ret = {}
    do
      local fs_2_auto = assert(uv.fs_scandir(path))
      local done_3f_3_auto = false
      while not done_3f_3_auto do
        local name, type = uv.fs_scandir_next(fs_2_auto)
        if not name then
          done_3f_3_auto = true
          assert(not type)
        else
          table.insert(ret, {name = name, type = type})
        end
      end
    end
    return ret
  end
  local function on_complete(cmd, item)
    if ("file" == item.type) then
      return vim.cmd((cmd .. " " .. vim.fn.fnameescape(item.name)))
    else
      local function _10_()
        return ufind.open(ls((cwd .. "/" .. item.name)), {on_complete = on_complete})
      end
      return vim.schedule(_10_)
    end
  end
  local function _12_(_241)
    return _241.name
  end
  return ufind.open(ls(cwd), {get_value = _12_, on_complete = on_complete})
end
local function ls(path)
  local dir = assert(vim.loop.fs_opendir(path, nil, 1000))
  local _3ffiles = vim.loop.fs_readdir(dir)
  assert(vim.loop.fs_closedir(dir))
  return (_3ffiles or {})
end
local function ls_rec_21(path, results)
  local files = ls(path)
  local dirs = {}
  for _, _13_ in ipairs(files) do
    local _each_14_ = _13_
    local name = _each_14_["name"]
    local type = _each_14_["type"]
    if not vim.startswith(name, ".") then
      local abs_path = (path .. "/" .. name)
      if ("directory" == type) then
        table.insert(dirs, abs_path)
      else
        table.insert(results, abs_path)
      end
    else
    end
  end
  for _, dir in ipairs(dirs) do
    ls_rec_21(dir, results)
  end
  return nil
end
local function notes()
  local notes0 = {}
  local dir = (_24HOME .. "/notes")
  assert(exists_3f(dir))
  ls_rec_21(dir, notes0)
  return ufind.open(notes0, nil)
end
local function buffers()
  local buffers0
  do
    local origin_buf = vim.api.nvim_win_get_buf(0)
    local bufs
    local function _17_(_241)
      return (("" ~= vim.fn.bufname(_241)) and not vim.startswith(vim.fn.bufname(_241), "man://") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1) and (_241 ~= origin_buf))
    end
    bufs = vim.tbl_filter(_17_, vim.api.nvim_list_bufs())
    local function _18_(_241, _242)
      return ((vim.fn.getbufinfo(_241))[1].lastused > (vim.fn.getbufinfo(_242))[1].lastused)
    end
    table.sort(bufs, _18_)
    local function _19_(_241)
      return vim.fn.bufname(_241)
    end
    buffers0 = vim.tbl_map(_19_, bufs)
  end
  return ufind.open(buffers0, nil)
end
local function grep(query)
  local query0, _3fpath = nil, nil
  if query:match("%%$") then
    query0, _3fpath = query:sub(1, -3), vim.fn.expand("%:p")
  else
    query0, _3fpath = query, nil
  end
  local function cb(stdout, stderr, exit)
    if (0 ~= exit) then
      return vim.notify(("Grep failed:" .. stderr), vim.log.levels.ERROR)
    else
      local function _21_()
        local function _22_(cmd, item)
          local found_3f, _, matched_filename, matched_line_nr = item:find("^([^:]+):(%d+):")
          if found_3f then
            return vim.cmd((cmd .. " " .. vim.fn.fnameescape(matched_filename) .. "|" .. matched_line_nr))
          else
            return print("pattern match failed")
          end
        end
        return ufind.open(vim.split(stdout, "\n", {trimempty = true}), {delimiter = ":", on_complete = _22_})
      end
      return vim.schedule(_21_)
    end
  end
  return system({"rg", "--vimgrep", "-M", 200, "--no-heading", "--no-line-number", "--no-column", "--", query0, _3fpath}, cb)
end
local function visual_grep(_25_)
  local _arg_26_ = _25_
  local args = _arg_26_["args"]
  return grep(args)
end
local function grep_expr()
  local dir_3f = (vim.fn.isdirectory(vim.fn.expand("%:p")) == 1)
  local function _27_()
    if dir_3f then
      return " %<Left><Left>"
    else
      return ""
    end
  end
  return (":<C-u>Grep " .. _27_())
end
vim.keymap.set("n", "<space>o", oldfiles, {})
vim.keymap.set("n", "<space>f", find, {})
vim.keymap.set("n", "<space>n", notes, {})
vim.keymap.set("n", "<space>b", buffers, {})
vim.keymap.set("n", "<space>a", grep_expr, {expr = true})
vim.api.nvim_create_user_command("Grep", visual_grep, {nargs = "+"})
return vim.keymap.set("x", "<space>a", "\"vy:Grep <C-r>v<CR>", {})
