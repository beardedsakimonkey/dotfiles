(import-macros {: opt-local : with-undo-ftplugin} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (opt-local formatoptions += :t) ; autowrap using textwidth
                    (opt-local formatoptions -= :l) ; break long lines
                    (opt-local breakindent) ; auto-indent wrapped lines
                    (opt-local expandtab)
                    (opt-local conceallevel 3)
                    (opt-local textwidth 100))

