(import-macros {: opt-local : with-undo-ftplugin} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (opt-local formatoptions += :t)
                    (opt-local textwidth 100))

