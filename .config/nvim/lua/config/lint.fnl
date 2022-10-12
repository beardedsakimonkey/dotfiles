(local lint (require :lint))
(import-macros {: augroup : autocmd} :macros)

(tset lint :linters_by_ft :lua [:luacheck])

(augroup :my/lint (autocmd BufWritePost *.lua #(lint.try_lint nil nil)))
