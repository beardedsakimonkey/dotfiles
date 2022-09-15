(import-macros {: with-undo-ftplugin : opt-local} :macros)

;; The default keywordprg uses the `run-help` zsh module which kinda sucks.
(with-undo-ftplugin (opt-local keywordprg ":vert Man"))
