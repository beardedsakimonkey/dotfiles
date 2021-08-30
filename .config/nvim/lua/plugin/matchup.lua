vim.g.matchup_surround_enabled = 1
vim.g.matchup_transmute_enabled = 1
vim.g.matchup_matchparen_offscreen = {}
vim.g.matchup_motion_keepjumps = 1
vim.g.matchup_matchpref = {html = {nolists = 1}}
do
  vim.cmd("autocmd FileType vim,lua,zsh,c,cpp  let b:matchup_matchparen_enabled = 0")
end
return vim.api.nvim_set_keymap("", "<tab>", "<plug>(matchup-%)", {})
