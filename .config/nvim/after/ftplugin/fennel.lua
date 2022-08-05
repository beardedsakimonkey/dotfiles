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
local function get_outer_node(node)
  local parent = node
  local result = node
  while (nil ~= parent:parent()) do
    result = parent
    parent = result:parent()
  end
  return result
end
local function get_outer_form_text(winid)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(winid)
  local outer_node = get_outer_node(cursor_node)
  return vim.treesitter.get_node_text(outer_node, vim.fn.winbufnr(winid))
end
local function eval_outer_form()
  local repl = require("fennel-repl")
  local bufnr = repl.open()
  local repl_focused = vim.startswith(vim.api.nvim_buf_get_name(bufnr), "fennel-repl")
  local text
  local function _2_()
    if not repl_focused then
      return vim.fn.win_getid(vim.fn.winnr("#"))
    else
      return 0
    end
  end
  text = get_outer_form_text(_2_())
  return repl.callback(bufnr, text)
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
