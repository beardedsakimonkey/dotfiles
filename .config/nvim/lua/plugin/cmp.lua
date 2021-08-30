local cmp = require("cmp")
cmp.setup({mapping = {["<Tab>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})}, sources = {{name = "buffer"}, {name = "path"}, {name = "nvim_lua"}, {name = "nvim_lsp"}}})
do
  vim.api.nvim_set_keymap("i", "<C-j>", "<C-n>", {noremap = true})
end
return vim.api.nvim_set_keymap("i", "<C-k>", "<C-p>", {noremap = true})
