local configs = require("nvim-treesitter.configs")
configs.setup({ensure_installed = {"query", "rescript"}, highlight = {enable = true}, playground = {disable = {}, enable = true, keybindings = {focus_language = "f", goto_node = "<cr>", show_help = "?", toggle_anonymous_nodes = "a", toggle_hl_groups = "i", toggle_injected_languages = "t", toggle_language_display = "I", toggle_query_editor = "o", unfocus_language = "F", update = "R"}, persist_queries = false, updatetime = 25}})
return vim.api.nvim_set_keymap("n", "gz", "<Cmd>TSHighlightCapturesUnderCursor<CR>", {noremap = true})
