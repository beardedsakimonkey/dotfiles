local _local_1_ = require("util")
local exists_3f = _local_1_["exists?"]
local f_5c = _local_1_["f\\"]
vim.cmd("inoreabbrev <buffer> lambda \206\187")
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | unabbrev <buffer> lambda"))
if ("prompt" == (vim.opt.buftype):get()) then
  vim.api.nvim_clear_autocmds({event = "BufEnter", buffer = 0})
  vim.keymap.set("n", "<CR>", "<Cmd>startinsert<CR><CR>", {buffer = true})
  vim.keymap.set("i", "<C-p>", "pumvisible() ? '<C-p>' : '<C-x><C-l><C-p>'", {buffer = true, expr = true})
  vim.keymap.set("i", "<C-n>", "pumvisible() ? '<C-n>' : '<C-x><C-l><C-n>'", {buffer = true, expr = true})
  vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> <CR>"))
  vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> <C-p>"))
  vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> <C-n>"))
else
end
local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.fnl$", ".lua")
  if exists_3f(to) then
    return vim.cmd(("edit " .. f_5c(to)))
  else
    return vim.api.nvim_err_writeln(("Cannot read file " .. to))
  end
end
local function get_root_node(node)
  local parent = node
  local result = node
  while (nil ~= parent:parent()) do
    result = parent
    parent = result:parent()
  end
  return result
end
local function get_root_form(winid, _bufnr)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(winid, false)
  return get_root_node(cursor_node)
end
local function form_3f(node, bufnr)
  local text = vim.treesitter.get_node_text(node, bufnr)
  local first = text:sub(1, 1)
  local last = text:sub(-1)
  return (("(" == first) and (")" == last))
end
local function get_outer_form_2a(node, bufnr)
  if not node then
    return nil
  elseif form_3f(node, bufnr) then
    return node
  else
    return get_outer_form_2a(node:parent(), bufnr)
  end
end
local function get_outer_form(winid, bufnr)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(winid, false)
  return get_outer_form_2a(cursor_node, bufnr)
end
local function eval_form(root_3f)
  local repl = require("fennel-repl")
  local repl_bufnr = repl.open()
  local repl_focused = vim.startswith(vim.api.nvim_buf_get_name(repl_bufnr), "fennel-repl")
  local winid
  if not repl_focused then
    winid = vim.fn.win_getid(vim.fn.winnr("#"))
  else
    winid = 0
  end
  local bufnr = vim.fn.winbufnr(winid)
  local form
  local _6_
  if root_3f then
    _6_ = get_root_form
  else
    _6_ = get_outer_form
  end
  form = _6_(winid, bufnr)
  local text = vim.treesitter.get_node_text(form, bufnr)
  return repl.callback(repl_bufnr, text)
end
local function goto_require()
  local form = get_outer_form(0, 0)
  local form_text = vim.treesitter.get_node_text(form, 0)
  local _3fmod_name = form_text:match("%(require [\":]?([^)]+)\"?%)")
  if _3fmod_name then
    local basename = _3fmod_name:gsub("%.", "/")
    local paths = {("lua/" .. basename .. ".lua"), ("lua/" .. basename .. "/init.lua")}
    local found = vim.api.nvim__get_runtime(paths, false, {is_lua = true})
    if (#found > 0) then
      local lua_path = found[1]
      local fnl_path = lua_path:gsub("%.lua$", ".fnl")
      local path
      if exists_3f(fnl_path) then
        path = fnl_path
      else
        path = lua_path
      end
      return vim.cmd(("edit " .. f_5c(path)))
    else
      return vim.api.nvim_err_writeln(("Cannot find module " .. basename))
    end
  else
    return nil
  end
end
vim["opt_local"]["expandtab"] = true
vim["opt_local"]["commentstring"] = ";; %s"
vim["opt_local"]["keywordprg"] = ":help"
do
  do end (vim.opt_local.iskeyword):remove(".")
  do end (vim.opt_local.iskeyword):remove(":")
  do end (vim.opt_local.iskeyword):remove("]")
  do end (vim.opt_local.iskeyword):remove("[")
end
vim.keymap.set("n", "]f", goto_lua, {buffer = true})
vim.keymap.set("n", "[f", goto_lua, {buffer = true})
local function _11_()
  return eval_form(false)
end
vim.keymap.set("n", ",ee", _11_, {buffer = true})
local function _12_()
  return eval_form(true)
end
vim.keymap.set("n", ",er", _12_, {buffer = true})
vim.keymap.set("n", "gd", goto_require, {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl expandtab< | setl commentstring< | setl keywordprg< | setl iskeyword< | sil! nun <buffer> ]f | sil! nun <buffer> [f | sil! nun <buffer> ,ee | sil! nun <buffer> ,er | sil! nun <buffer> gd"))
