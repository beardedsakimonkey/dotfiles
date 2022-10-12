(local print-ORIG _G.print)

;; Patch `print` to call vim.inspect on each table arg
(fn print-PATCHED [...]
  (local args [])
  (local num-args (select "#" ...))
  ;; Use for loop instead of `tbl_map` because `pairs` iteration stops at nil
  (for [i 1 num-args]
    (local arg (select i ...))
    (if (= :table (type arg)) (table.insert args (vim.inspect arg))
        (= :nil (type arg)) (table.insert args :nil) ; lest it be ignored
        (table.insert args arg)))
  (print-ORIG (unpack args)))

(set _G.print print-PATCHED)
