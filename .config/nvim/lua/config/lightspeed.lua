local lightspeed = require("lightspeed")
lightspeed.setup({jump_to_unique_chars = {safety_timeout = 400}, match_only_the_start_of_same_char_seqs = true, limit_ft_matches = 5})
vim.cmd("silent! unmap s")
do
  vim.api.nvim_set_keymap("n", "t", "<Plug>Lightspeed_s", {})
end
do
  vim.api.nvim_set_keymap("n", "T", "<Plug>Lightspeed_S", {})
end
do
  vim.api.nvim_set_keymap("n", "f", "<Plug>Lightspeed_f", {})
end
do
  vim.api.nvim_set_keymap("n", "F", "<Plug>Lightspeed_F", {})
end
return vim.api.nvim_set_keymap("n", ":", "<Plug>Lightspeed_;_ft", {})
