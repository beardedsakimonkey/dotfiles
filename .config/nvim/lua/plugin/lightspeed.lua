local lightspeed = require("lightspeed")
lightspeed.setup({full_inclusive_prefix_key = "<c-x>", grey_out_search_area = true, highlight_unique_chars = false, jump_on_partial_input_safety_timeout = 400, jump_to_first_match = true, limit_ft_matches = 5, match_only_the_start_of_same_char_seqs = true})
vim.api.nvim_del_keymap("", "s")
do
  vim.api.nvim_set_keymap("n", "f", "<Plug>Lightspeed_s", {})
end
do
  vim.api.nvim_set_keymap("n", "F", "<Plug>Lightspeed_S", {})
end
do
  vim.api.nvim_set_keymap("n", "t", "<Plug>Lightspeed_f", {})
end
return vim.api.nvim_set_keymap("n", "T", "<Plug>Lightspeed_F", {})
