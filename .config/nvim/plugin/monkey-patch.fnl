(local print-ORIG _G.print)

;; Patch `print` to call vim.inspect on each arg
(fn print-PATCHED [...]
  (let [args (vim.tbl_map #(vim.inspect $1) [...])]
    (print-ORIG (unpack args))))

(set _G.print print-PATCHED)

