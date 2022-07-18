vim.cmd("inoreabbrev <buffer> lambda \206\187")
vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | unabbrev <buffer> lambda"))
local function goto_lua()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.fnl$", ".lua")
  return vim.cmd(("edit " .. vim.fn.fnameescape(to)))
end
local function get_outer_node(node)
  local parent = node
  local result = node
  while (nil ~= parent:parent()) do
    result = parent
    parent = result:parent()
  end
  return result
end
local function get_outer_form_text(init_repl_3f)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local alt_win = vim.fn.win_getid(vim.fn.winnr("#"))
  local winid
  if init_repl_3f then
    winid = alt_win
  else
    winid = 0
  end
  local node = ts_utils.get_node_at_cursor(winid)
  local outer = get_outer_node(node)
  return vim.treesitter.get_node_text(outer, tonumber(vim.fn.winbufnr(winid)))
end
local function eval_outer_form()
  local _local_2_ = require("fennel-repl")
  local get_bufnr = _local_2_["get_bufnr"]
  local callback = _local_2_["callback"]
  local start = _local_2_["start"]
  local buf = get_bufnr()
  local init_repl_3f = (nil == buf)
  if init_repl_3f then
    start()
    buf = get_bufnr()
  else
  end
  local text = get_outer_form_text(init_repl_3f)
  return callback(buf, text)
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
vim.keymap.set("n", "<space>ev", eval_outer_form, {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl expandtab< | setl commentstring< | setl comments< | setl keywordprg< | setl iskeyword< | setl lisp< | setl autoindent< | setl lispwords< | sil! nun <buffer> ]f | sil! nun <buffer> [f | sil! nun <buffer> <space>ev"))
