local snap = require("snap")
local _local_1_ = require("util")
local _24HOME = _local_1_["$HOME"]
local exists_3f = _local_1_["exists?"]
local defaults = {mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}, next = {"<C-v>"}}, consumer = require("snap.consumer.fzy"), reverse = true, prompt = ""}
local function with_defaults(...)
  return vim.tbl_extend("force", {}, defaults, ...)
end
local function get_buffers(request)
  local function _2_()
    local original_buf = vim.api.nvim_win_get_buf(request.winnr)
    local bufs
    local function _3_(_241)
      return (("" ~= vim.fn.bufname(_241)) and not vim.startswith(vim.fn.bufname(_241), "man://") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1) and (_241 ~= original_buf))
    end
    bufs = vim.tbl_filter(_3_, vim.api.nvim_list_bufs())
    local function _4_(_241, _242)
      return ((vim.fn.getbufinfo(_241))[1].lastused > (vim.fn.getbufinfo(_242))[1].lastused)
    end
    table.sort(bufs, _4_)
    local function _5_(_241)
      return vim.fn.bufname(_241)
    end
    return vim.tbl_map(_5_, bufs)
  end
  return _2_
end
local function buffers(request)
  return snap.sync(get_buffers(request))
end
local grep_cfg = {producer = snap.get("consumer.limit")(10000, snap.get("producer.ripgrep.vimgrep")), select = (snap.get("select.vimgrep")).select, multiselect = (snap.get("select.vimgrep")).multiselect, views = {snap.get("preview.vimgrep")}, prompt = "Grep>"}
local function visual_grep(_6_)
  local _arg_7_ = _6_
  local args = _arg_7_["args"]
  return snap.run(with_defaults(grep_cfg, {initial_filter = args}))
end
local function grep()
  return snap.run(with_defaults(grep_cfg))
end
local function help()
  local function _8_(selection, _winnr, type)
    local cmd
    do
      local _9_ = type
      if (_9_ == "vsplit") then
        cmd = "vert "
      elseif (_9_ == "split") then
        cmd = "belowright "
      elseif (_9_ == "tab") then
        cmd = "tab "
      elseif true then
        local _ = _9_
        cmd = ""
      else
        cmd = nil
      end
    end
    return vim.api.nvim_command((cmd .. "help " .. tostring(selection)))
  end
  return snap.run(with_defaults({prompt = "Help>", producer = require("snap.consumer.fzy")(require("snap.producer.vim.help")), select = _8_, views = {snap.get("preview.help")}}))
end
local function get_oldfiles()
  local blacklist = {}
  local function _11_(file)
    return not blacklist[file]
  end
  local function _12_(file)
    if not file then
      return false
    else
      local not_wildignored
      local function _13_()
        return (0 == vim.fn.empty(vim.fn.glob(file)))
      end
      not_wildignored = _13_
      local not_dir
      local function _14_()
        return (0 == vim.fn.isdirectory(file))
      end
      not_dir = _14_
      local not_manpage
      local function _15_()
        return not vim.startswith(file, "man://")
      end
      not_manpage = _15_
      local keep = (not_wildignored() and not_dir() and not_manpage())
      if (keep and (nil ~= file:match("%.fnl$"))) then
        blacklist[file:gsub("%.fnl$", ".lua")] = true
      else
      end
      return keep
    end
  end
  return vim.tbl_filter(_11_, vim.tbl_filter(_12_, vim.v.oldfiles))
end
local function oldfiles()
  return snap.sync(get_oldfiles)
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
  for _, _18_ in ipairs(files) do
    local _each_19_ = _18_
    local name = _each_19_["name"]
    local type = _each_19_["type"]
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
local function get_notes()
  local ret = {}
  local dir = (_24HOME .. "/notes")
  assert(exists_3f(dir))
  ls_rec_21(dir, ret)
  return ret
end
local function notes()
  return snap.sync(get_notes)
end
local file = (snap.config.file):with(defaults)
vim.keymap.set("n", "<space>b", file({producer = buffers}), {})
vim.keymap.set("n", "<space>o", file({producer = oldfiles}), {})
vim.keymap.set("n", "<space>f", file({producer = "ripgrep.file"}), {})
vim.keymap.set("n", "<space>n", file({producer = notes}), {})
vim.keymap.set("n", "<space>a", grep, {})
vim.api.nvim_create_user_command("Grep", visual_grep, {nargs = "+"})
vim.keymap.set("x", "<space>a", "\"vy:Grep <C-r>v<CR>", {})
return vim.keymap.set("n", "<space>h", help, {})
