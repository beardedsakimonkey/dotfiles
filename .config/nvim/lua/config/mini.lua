local ai = require("mini.ai")
local surround = require("mini.surround")
local ts_spec = ai.gen_spec.treesitter
local function _1_()
  local from = {line = 1, col = 1}
  local to = {line = vim.fn.line("$"), col = (vim.fn.getline("$"):len() + 1)}
  return {from = from, to = to}
end
ai.setup({n_lines = 50, mappings = {goto_right = "", goto_left = "", inside = "i", around = "a", inside_next = "in", inside_last = "il", around_last = "al", around_next = "an"}, custom_textobjects = {F = ts_spec({a = "@function.outer", i = "@function.inner"}), f = ts_spec({a = "@call.outer", i = "@call.inner"}), B = ts_spec({a = "@block.outer", i = "@block.inner"}), o = ts_spec({a = {"@conditional.outer", "@loop.outer"}, i = {"@conditional.inner", "@loop.inner"}}), g = _1_}, search_method = "cover_or_next"})
local ts_input = surround.gen_spec.input.treesitter
surround.setup({mappings = {delete = "ds", find = "", replace = "cs", find_left = "", add = "ys", highlight = "", update_n_lines = ""}, custom_surroundings = {f = {input = ts_input({outer = "@call.outer", inner = "@call.inner"})}, F = {input = ts_input({outer = "@function.outer", inner = "@function.inner"})}, B = {input = ts_input({outer = "@block.outer", inner = "@block.inner"})}, o = {input = ts_input({outer = "@conditional.outer", inner = "@conditional.inner"})}}, search_method = "cover_or_next"})
vim.keymap.del("x", "ys")
return vim.keymap.set("x", "S", "<Cmd>lua MiniSurround.add('visual')<CR>")