local cmp = require("cmp")
cmp.setup({experimental = {ghost_text = true}, mapping = {["<C-j>"] = cmp.mapping.select_next_item(), ["<C-k>"] = cmp.mapping.select_prev_item(), ["<Tab>"] = cmp.mapping.confirm({select = true})}, sources = {{name = "buffer"}, {name = "path"}, {name = "nvim_lua"}, {name = "nvim_lsp"}}})
return cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})
