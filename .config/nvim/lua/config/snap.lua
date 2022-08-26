local snap = require("snap")
local defaults = {mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}, next = {"<C-v>"}}, consumer = "fzy", reverse = true, prompt = ""}
local function with_defaults(...)
  return vim.tbl_extend("force", {}, defaults, ...)
end
local function get_buffers(request)
  local function _1_()
    local original_buf = vim.api.nvim_win_get_buf(request.winnr)
    local bufs
    local function _2_(_241)
      return (("" ~= vim.fn.bufname(_241)) and not vim.startswith(vim.fn.bufname(_241), "man://") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1) and (_241 ~= original_buf))
    end
    bufs = vim.tbl_filter(_2_, vim.api.nvim_list_bufs())
    local function _3_(_241, _242)
      return ((vim.fn.getbufinfo(_241))[1].lastused > (vim.fn.getbufinfo(_242))[1].lastused)
    end
    table.sort(bufs, _3_)
    local function _4_(_241)
      return vim.fn.bufname(_241)
    end
    return vim.tbl_map(_4_, bufs)
  end
  return _1_
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
  local function _5_(selection, _winnr, type)
    local cmd
    do
      local _6_ = type
      if (_6_ == "vsplit") then
        cmd = "vert "
      elseif (_6_ == "split") then
        cmd = "belowright "
      elseif (_6_ == "tab") then
        cmd = "tab "
      elseif true then
        local _ = _6_
        cmd = ""
      else
        cmd = nil
      end
    end
    return vim.api.nvim_command((cmd .. "help " .. tostring(selection)))
  end
  return snap.run(with_defaults({prompt = "Help>", producer = snap.get("consumer.fzy")(snap.get("producer.vim.help")), select = _5_, views = {snap.get("preview.help")}}))
end
local function get_oldfiles()
  local blacklist = {}
  local function _8_(file)
    return not blacklist[file]
  end
  local function _9_(file)
    if not file then
      return false
    else
      local not_wildignored
      local function _10_()
        return (0 == vim.fn.empty(vim.fn.glob(file)))
      end
      not_wildignored = _10_
      local not_dir
      local function _11_()
        return (0 == vim.fn.isdirectory(file))
      end
      not_dir = _11_
      local not_manpage
      local function _12_()
        return not vim.startswith(file, "man://")
      end
      not_manpage = _12_
      local keep = (not_wildignored() and not_dir() and not_manpage())
      if (keep and (nil ~= file:match("%.fnl$"))) then
        blacklist[file:gsub("%.fnl$", ".lua")] = true
      else
      end
      return keep
    end
  end
  return vim.tbl_filter(_8_, vim.tbl_filter(_9_, vim.v.oldfiles))
end
local function oldfiles()
  return snap.sync(get_oldfiles)
end
local file = (snap.config.file):with(defaults)
vim.keymap.set("n", "<space>b", file({producer = buffers}), {})
vim.keymap.set("n", "<space>o", file({producer = oldfiles}), {})
vim.keymap.set("n", "<space>f", file({producer = "ripgrep.file"}), {})
vim.keymap.set("n", "<space>a", grep, {})
vim.keymap.set("x", "<space>a", visual_grep, {})
return vim.keymap.set("n", "<space>h", help, {})
