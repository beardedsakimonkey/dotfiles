(local print-ORIG _G.print)

;; Patch `print` to call vim.inspect on each table arg
(fn print-PATCHED [...]
  (let [args (vim.tbl_map #(if (= :table (type $1)) (vim.inspect $1) $1) [...])]
    (print-ORIG (unpack args))))

(set _G.print print-PATCHED)

;; (fn dump []
;;   )

;; (set _G.dump dump)

