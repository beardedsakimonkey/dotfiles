local configs = require("nvim-treesitter.configs")
configs.setup({ensure_installed = {"query", "rescript", "javascript", "glsl", "lua", "fennel"}, highlight = {enable = true}, playground = {enable = true, disable = {}, updatetime = 25, persist_queries = false, keybindings = {toggle_query_editor = "o", toggle_hl_groups = "i", toggle_injected_languages = "t", toggle_anonymous_nodes = "a", toggle_language_display = "I", focus_language = "f", unfocus_language = "F", update = "R", goto_node = "<cr>", show_help = "?"}}, query_linter = {enable = true, use_virtual_text = true, lint_events = {"BufWrite", "BufEnter"}}})
return vim.keymap.set("n", "gy", "<Cmd>TSHighlightCapturesUnderCursor<CR>", {})
