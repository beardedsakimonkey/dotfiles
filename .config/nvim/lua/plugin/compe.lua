local compe = require("compe")
compe.setup({autocomplete = true, enabled = true, min_length = 2, preselect = "always", source = {buffer = true, nvim_lsp = true, path = true}})
vim.g.completion_chain_complete_list = {{complete_items = {"lsp"}}, {mode = "<c-p>"}, {mode = "<c-n>"}}
vim.g.completion_auto_change_source = 1
vim.g.completion_trigger_keyword_length = 1
vim.g.completion_enable_auto_signature = 0
vim.g.completion_enable_auto_hover = 0
vim.g.completion_confirm_key = "\\<c-i>"
vim.api.nvim_set_keymap("i", "<C-j>", "<C-n>", {noremap = true})
vim.api.nvim_set_keymap("i", "<C-k>", "<C-p>", {noremap = true})
return vim.api.nvim_set_keymap("i", "<Tab>", "compe#confirm('<tab>')", {expr = true, noremap = true})
