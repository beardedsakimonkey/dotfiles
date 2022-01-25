(import-macros {: no} :macros)

(set vim.g.linediff_buffer_type :scratch)
(no x :D "mode() is# 'V' ? ':Linediff<cr>' : 'D'" :expr)

