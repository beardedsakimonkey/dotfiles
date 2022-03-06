vim.g.linediff_buffer_type = "scratch"
return vim.keymap.set("x", "D", "mode() is# 'V' ? ':Linediff<cr>' : 'D'", {expr = true})
