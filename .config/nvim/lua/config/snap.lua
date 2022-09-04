local snap = require("snap")
local _local_1_ = require("util")
local _24HOME = _local_1_["$HOME"]
local defaults = {mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}, next = {"<C-v>"}}, consumer = "fzy", reverse = true, prompt = ""}
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
local function get_selected_text()
  local reg = vim.fn.getreg("\"")
  vim.cmd("normal! y")
  local text = vim.fn.trim(vim.fn.getreg("@"))
  vim.fn.setreg("\"", reg)
  return text
end
local grep_cfg = {producer = snap.get("consumer.limit")(10000, snap.get("producer.ripgrep.vimgrep")), select = (snap.get("select.vimgrep")).select, multiselect = (snap.get("select.vimgrep")).multiselect, views = {snap.get("preview.vimgrep")}, prompt = "Grep>"}
local function visual_grep()
  return snap.run(with_defaults(grep_cfg, {initial_filter = get_selected_text()}))
end
local function grep()
  return snap.run(with_defaults(grep_cfg))
end
local function help()
  local function _6_(selection, _winnr, type)
    local cmd
    do
      local _7_ = type
      if (_7_ == "vsplit") then
        cmd = "vert "
      elseif (_7_ == "split") then
        cmd = "belowright "
      elseif (_7_ == "tab") then
        cmd = "tab "
      elseif true then
        local _ = _7_
        cmd = ""
      else
        cmd = nil
      end
    end
    return vim.api.nvim_command((cmd .. "help " .. tostring(selection)))
  end
  return snap.run(with_defaults({prompt = "Help>", producer = snap.get("consumer.fzy")(snap.get("producer.vim.help")), select = _6_, views = {snap.get("preview.help")}}))
end
local function get_oldfiles()
  local blacklist = {}
  local function _9_(file)
    return not blacklist[file]
  end
  local function _10_(file)
    if not file then
      return false
    else
      local not_wildignored
      local function _11_()
        return (0 == vim.fn.empty(vim.fn.glob(file)))
      end
      not_wildignored = _11_
      local not_dir
      local function _12_()
        return (0 == vim.fn.isdirectory(file))
      end
      not_dir = _12_
      local not_manpage
      local function _13_()
        return not vim.startswith(file, "man://")
      end
      not_manpage = _13_
      local keep = (not_wildignored() and not_dir() and not_manpage())
      if (keep and (nil ~= file:match("%.fnl$"))) then
        blacklist[file:gsub("%.fnl$", ".lua")] = true
      else
      end
      return keep
    end
  end
  return vim.tbl_filter(_9_, vim.tbl_filter(_10_, vim.v.oldfiles))
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
  for _, _16_ in ipairs(files) do
    local _each_17_ = _16_
    local name = _each_17_["name"]
    local type = _each_17_["type"]
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
  local paths = {}
  ls_rec_21((_24HOME .. "/notes"), paths)
  return paths
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
vim.keymap.set("x", "<space>a", visual_grep, {})
return vim.keymap.set("n", "<space>h", help, {})
