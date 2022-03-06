(import-macros {: with-undo-ftplugin : opt-local} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (opt-local formatoptions += :t)
                    (opt-local textwidth 80)
                    (opt-local colorcolumn :80))

