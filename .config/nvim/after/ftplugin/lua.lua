local _local_1_ = require("util")
local f_exists_3f = _local_1_["f-exists?"]
local f_5c = _local_1_["f\\"]
local function goto_fnl()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.lua$", ".fnl")
  if f_exists_3f(to) then
    return vim.cmd(("edit " .. f_5c(to)))
  else
    return vim.api.nvim_err_writeln(("Cannot read file " .. to))
  end
end
local function goto_require()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(0, false)
  local form_text = vim.treesitter.get_node_text(cursor_node, 0)
  local _3fmod_name = form_text:match("[\"']([^\"']+)[\"']")
  if (nil ~= _3fmod_name) then
    local basename = _3fmod_name:gsub("%.", "/")
    local paths = {("lua/" .. basename .. ".lua"), ("lua/" .. basename .. "/init.lua")}
    local found = vim.api.nvim__get_runtime(paths, false, {is_lua = true})
    if (#found > 0) then
      local path = found[1]
      return vim.cmd(("edit " .. f_5c(path)))
    else
      return vim.api.nvim_err_writeln(("Cannot find module " .. basename))
    end
  else
    return nil
  end
end
vim["opt_local"]["keywordprg"] = ":help"
vim.keymap.set("n", "]f", goto_fnl, {buffer = true})
vim.keymap.set("n", "[f", goto_fnl, {buffer = true})
vim.keymap.set("n", "gd", goto_require, {buffer = true})
return vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | sil! nun <buffer> ]f | sil! nun <buffer> [f | sil! nun <buffer> gd"))
