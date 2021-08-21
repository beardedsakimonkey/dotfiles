local filetree = require("filetree")
filetree.init()
return vim.api.nvim_set_keymap("n", "-", ":<C-u>Filetree<CR>", {noremap = true})
