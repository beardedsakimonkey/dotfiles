(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

(with-undo-ftplugin (opt-local formatprg "tidy -quiet -indent -ashtml -utf8"))

