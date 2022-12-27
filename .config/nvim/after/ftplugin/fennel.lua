local exists = require("util").exists
local fe = vim.fn.fnameescape

vim.cmd("inoreabbrev <buffer> lambda \206\187")
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | unabbrev <buffer> lambda"))

-- fennel-repl
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

-- goto-lua -----------------------------------------------------------------

local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.fnl$", ".lua")
  if exists(to) then
    return vim.cmd(("edit " .. fe(to)))
  else
    return vim.api.nvim_err_writeln(("Cannot read file " .. to))
  end
end

-- eval-form ----------------------------------------------------------------

local function get_root_node(node)
  local parent = node
  local result = node
  while (nil ~= parent:parent()) do
    result = parent
    parent = result:parent()
  end
  return result
end

local function get_root_form(winid)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(winid, false)
  return get_root_node(cursor_node)
end

local function is_form(node, bufnr)
  local text = vim.treesitter.get_node_text(node, bufnr)
  local first = text:sub(1, 1)
  local last = text:sub(-1)
  return "(" == first and ")" == last
end

local function get_outer_form_aux(node, bufnr)
  if not node then
    return nil
  elseif is_form(node, bufnr) then
    return node
  else
    -- Walk up the syntax tree until we hit a node that is wrapped in `()`
    return get_outer_form_aux(node:parent(), bufnr)
  end
end

local function get_outer_form(winid, bufnr)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(winid, false)
  if "comment" == cursor_node:type() then
    return cursor_node
  else
    return get_outer_form_aux(cursor_node, bufnr)
  end
end

-- NOTE: After inserting lines into the prompt buffer, the prompt prefix is not
-- drawn until entering insert mode. (`init_prompt()` in edit.c)
local function eval_form(is_root)
  local repl = require("fennel-repl")
  local repl_bufnr = repl.open()
  local repl_focused = vim.startswith(vim.api.nvim_buf_get_name(repl_bufnr), "fennel-repl")
  -- Initializing the repl moves us to a new win, so use the alt win
  local winid
  if not repl_focused then
    winid = vim.fn.win_getid(vim.fn.winnr("#"))
  else
    winid = 0
  end
  local bufnr = vim.fn.winbufnr(winid)
  local form
  form = (is_root and get_root_form or get_outer_form)(winid, bufnr)
  local text = vim.treesitter.get_node_text(form, bufnr)
  repl.callback(repl_bufnr, text)
end

-- goto-require -------------------------------------------------------------

local function convert_to_fnl(lua_path)
  local fnl_path = lua_path:gsub("%.lua$", ".fnl")
  if exists(fnl_path) then
    return fnl_path
  else
    return lua_path
  end
end

local function search_packagepath(basename)
  local paths = (package.path):gsub("%?", basename)
  local found = nil
  for path in paths:gmatch("[^;]+") do
    if found then break end
    if exists(path) then
      found = path
    else
    end
  end
  return found
end

local function search_runtimepath(basename)
  -- Adapted from $VIMRUNTIME/lua/vim/_load_package.lua
  local path = vim.api.nvim__get_runtime({
    ("lua/" .. basename .. ".lua"),
    ("lua/" .. basename .. "/init.lua")
  }, false, {is_lua = true})[1]
  return path
end

local function get_basename()
  local form = get_outer_form(0, 0)
  local form_text = vim.treesitter.get_node_text(form, 0)
  local mod_name = form_text:match("%(require [\":]?([^)]+)\"?%)")
  if mod_name then
    return mod_name:gsub("%.", "/")
  end
end

local function goto_require()
  local basename = get_basename()
  if basename then
    local path = (search_runtimepath(basename) or search_packagepath(basename))
    if path then
      vim.cmd("edit " .. fe(convert_to_fnl(path)))
    else
      vim.api.nvim_err_writeln("Could not find module for " .. basename)
    end
  else
    vim.api.nvim_err_writeln("Could not parse form. Is it a require?")
  end
end

vim["opt_local"]["expandtab"] = true
vim["opt_local"]["commentstring"] = ";; %s"
vim["opt_local"]["keywordprg"] = ":help"
vim.opt_local.iskeyword:remove(".")
vim.opt_local.iskeyword:remove(":")
vim.opt_local.iskeyword:remove("]")
vim.opt_local.iskeyword:remove("[")
vim.keymap.set("n", "]f", goto_lua, {buffer = true})
vim.keymap.set("n", "[f", goto_lua, {buffer = true})
vim.keymap.set("x", ",a", ":Antifennel<CR>", {buffer = true})
vim.keymap.set("n", ",ee", function() eval_form(false) end, {buffer = true})
vim.keymap.set("n", ",er", function() eval_form(true) end, {buffer = true})
vim.keymap.set("n", "gd", goto_require, {buffer = true})

vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl expandtab< | setl commentstring< | setl keywordprg< | setl iskeyword< | sil! nun <buffer> ]f | sil! nun <buffer> [f | sil! nun <buffer> ,a | sil! nun <buffer> ,ee | sil! nun <buffer> ,er | sil! nun <buffer> gd"))
