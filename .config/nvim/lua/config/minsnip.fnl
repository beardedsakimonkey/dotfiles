(local minsnip (require :minsnip))
(import-macros {: map} :macros)

(fn join [seq]
  (table.concat seq "\n"))

(minsnip.setup {:cl #(match vim.bo.filetype
                       :c "printf(\"$0\\n\");"
                       :vim "echom $0"
                       :lua "print($0)"
                       :fennel "(print $0)"
                       :javascript "console.log($0)"
                       :rescript "Js.log($0)"
                       :rust "println!(\"$0\")")
                :d #(match vim.bo.filetype
                      :lua (join ["local dbg = require'debugger'"
                                  "dbg.auto_where = 10"
                                  "dbg()"]))
                :table #(join ["| $0 |    |    |"
                               "| -- | -- | -- |"
                               "|    |    |    |"])})

(fn expand-snippet []
  (if (not (minsnip.jump)) (vim.api.nvim_input :<C-l>)))

(map i :<C-l> expand-snippet)
