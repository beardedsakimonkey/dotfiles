(import-macros {: au} :macros)

(set vim.g.targets_jumpRanges "")
(set vim.g.targets_aiAI :aIAi)

;; NOTE: you can do `cin` or `cil` to target the next or previous instance.
(fn setup-targets []
  ((. vim.fn "targets#mappings#extend") {"'" {:quote [{:d "'"} {:d "\""}]}
                                         :b {:pair [{:o "(" :c ")"}]}}))

(au User targets#mappings#user setup-targets)

