(local lint (require :lint))
(import-macros {: augroup : autocmd : command} :macros)

;; TODO: Try out selene?
(tset lint :linters_by_ft :lua [:luacheck])

;; TODO: Not sure why this doesn't work..
(fn clear-diagnostics []
  (local ns (vim.api.nvim_get_namespaces))
  (when ns.luacheck
    (vim.api.nvim_buf_clear_namespace 0 ns.luacheck 0 -1)))

(command :LintDisable #(do
                         (clear-diagnostics)
                         (set vim.g.lint_disabled true)))

(command :LintEnable #(set vim.g.lint_disabled false))

;; NOTE: Update `clear-diagnostics` when adding more linters
;; (augroup :my/lint (autocmd BufWritePost *.lua
;;                            #(when (not vim.g.lint_disabled)
;;                               (lint.try_lint nil nil))))
