vim.g.linediff_buffer_type = "scratch"
return vim.api.nvim_set_keymap("x", "D", "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true, noremap = true})
