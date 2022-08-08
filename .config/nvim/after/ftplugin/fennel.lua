vim.cmd("inoreabbrev <buffer> lambda \206\187")
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | unabbrev <buffer> lambda"))
if ("prompt" == (vim.opt.buftype):get()) then
  vim.keymap.set("n", "<CR>", "<Cmd>startinsert<CR><CR>", {buffer = true})
  vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | sil! nun <buffer> <CR>"))
else
end
local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.fnl$", ".lua")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
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
  local cursor_node = ts_utils.get_node_at_cursor(winid)
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
  local cursor_node = ts_utils.get_node_at_cursor(winid)
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
  local _4_
  if root_3f then
    _4_ = get_root_form
  else
    _4_ = get_outer_form
  end
  form = _4_(winid, bufnr)
  local text = vim.treesitter.get_node_text(form, bufnr)
  return repl.callback(repl_bufnr, text)
end
vim["opt_local"]["expandtab"] = true
vim["opt_local"]["commentstring"] = ";; %s"
vim["opt_local"]["comments"] = "n:;"
vim["opt_local"]["keywordprg"] = ":help"
vim["opt_local"]["iskeyword"] = "!,$,%,#,*,+,-,/,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94"
vim["opt_local"]["lisp"] = true
vim["opt_local"]["autoindent"] = true
vim["opt_local"]["lispwords"] = {"accumulate", "collect", "do", "doto", "each", "fn", "for", "icollect", "lambda", "let", "macro", "macros", "match", "when", "while", "with-open"}
vim.keymap.set("n", "]f", goto_lua, {buffer = true})
vim.keymap.set("n", "[f", goto_lua, {buffer = true})
local function _6_()
  return eval_form(false)
end
vim.keymap.set("n", ",ee", _6_, {buffer = true})
local function _7_()
  return eval_form(true)
end
vim.keymap.set("n", ",er", _7_, {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl expandtab< | setl commentstring< | setl comments< | setl keywordprg< | setl iskeyword< | setl lisp< | setl autoindent< | setl lispwords< | sil! nun <buffer> ]f | sil! nun <buffer> [f | sil! nun <buffer> ,ee | sil! nun <buffer> ,er"))
