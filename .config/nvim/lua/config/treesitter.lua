local configs = require("nvim-treesitter.configs")
local function large_buf_3f(_lang, bufnr)
  local size = vim.fn.getfsize(vim.fn.bufname(bufnr))
  return ((size > (1024 * 1024)) or (size == -2))
end
vim.g.ts_highlight_lua = true
configs.setup({ensure_installed = {"javascript", "fennel", "markdown", "markdown_inline", "query"}, highlight = {enable = true, disable = large_buf_3f}, playground = {enable = true, disable = {}, updatetime = 25, keybindings = {toggle_query_editor = "o", toggle_hl_groups = "i", toggle_injected_languages = "t", toggle_anonymous_nodes = "a", toggle_language_display = "I", focus_language = "f", unfocus_language = "F", update = "R", goto_node = "<cr>", show_help = "?"}, persist_queries = false}, textobjects = {select = {enable = true, disable = large_buf_3f, lookahead = true, keymaps = {aF = "@function.outer", iF = "@function.inner", af = "@call.outer", ["if"] = "@call.inner", aB = "@block.outer", iB = "@block.inner", aa = "@parameter.outer", ia = "@parameter.inner"}}}, query_linter = {enable = true, use_virtual_text = true, lint_events = {"BufWrite", "BufEnter"}}})
return vim.keymap.set("n", "gy", "<Cmd>TSHighlightCapturesUnderCursor<CR>", {})
