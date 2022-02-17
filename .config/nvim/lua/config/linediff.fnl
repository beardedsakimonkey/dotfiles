(import-macros {: map} :macros)

(set vim.g.linediff_buffer_type :scratch)
(map x :D "mode() is# 'V' ? ':Linediff<cr>' : 'D'" :expr)

