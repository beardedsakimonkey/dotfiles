local exists = require("util").exists
local fe = vim.fn.fnameescape

local function goto_fnl()
  local from = vim.fn.expand("%:p")
  local to = from:gsub("%.lua$", ".fnl")
  if exists(to) then
    vim.cmd("edit " .. fe(to))
  else
    vim.api.nvim_err_writeln("Cannot read file " .. to)
  end
end

local function goto_require()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cursor_node = ts_utils.get_node_at_cursor(0, false)
  local form_text = vim.treesitter.get_node_text(cursor_node, 0)
  local mod_name = form_text:match("[\"']([^\"']+)[\"']")
  if nil ~= mod_name then
    -- Adapted from $VIMRUNTIME/lua/vim/_load_package.lua
    local basename = mod_name:gsub("%.", "/")
    local paths = {("lua/" .. basename .. ".lua"), ("lua/" .. basename .. "/init.lua")}
    local found = vim.api.nvim__get_runtime(paths, false, {is_lua = true})
    if #found > 0 then
      local path = found[1]
      vim.cmd("edit " .. fe(path))
    else
      vim.api.nvim_err_writeln("Cannot find module " .. basename)
    end
  end
end

vim["opt_local"]["keywordprg"] = ":help"
vim["opt_local"]["textwidth"] = 100
vim.keymap.set("n", "]f", goto_fnl, {buffer = true})
vim.keymap.set("n", "[f", goto_fnl, {buffer = true})
vim.keymap.set("n", "gd", goto_require, {buffer = true})

vim.api.nvim_buf_set_var(0, "undo_ftplugin", ((vim.b.undo_ftplugin or "exe") .. " | setl keywordprg< | setl textwidth< | sil! nun <buffer> ]f | sil! nun <buffer> [f | sil! nun <buffer> gd"))
