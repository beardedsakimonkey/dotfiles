local snap = require("snap")
local defaults = {mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}, next = {"<C-v>"}}, consumer = "fzy", reverse = true, prompt = ""}
local function with_defaults(tbl)
  return vim.tbl_extend("force", {}, defaults, tbl)
end
local function get_buffers(request)
  local function _1_()
    local original_buf = vim.api.nvim_win_get_buf(request.winnr)
    local bufs
    local function _2_(_241)
      return ((vim.fn.bufname(_241) ~= "") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1) and (_241 ~= original_buf))
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
  return snap.run(with_defaults(vim.tbl_extend("force", {}, grep_cfg, {initial_filter = get_selected_text()})))
end
local function grep()
  return snap.run(with_defaults(grep_cfg))
end
local function help()
  local function _help_select(selection, _winnr, type)
    local cmd
    do
      local _5_ = type
      if (_5_ == "vsplit") then
        cmd = "vert "
      elseif (_5_ == "split") then
        cmd = "belowright "
      elseif (_5_ == "tab") then
        cmd = "tab "
      elseif true then
        local _ = _5_
        cmd = ""
      else
        cmd = nil
      end
    end
    return vim.api.nvim_command((cmd .. "help " .. tostring(selection)))
  end
  return snap.run(with_defaults({prompt = "Help>", producer = snap.get("consumer.fzy")(snap.get("producer.vim.help")), select = _help_select, views = {snap.get("preview.help")}}))
end
local function get_oldfiles()
  local function _7_(_3ffile)
    local file = (_3ffile or "")
    local wildignored = (1 == vim.fn.empty(vim.fn.glob(file)))
    local dir = (0 == vim.fn.isdirectory(file))
    local manpage = vim.startswith(file, "man://")
    return (not wildignored and dir and not manpage)
  end
  return vim.tbl_filter(_7_, vim.v.oldfiles)
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
