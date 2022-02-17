(local minsnip (require :minsnip))
(import-macros {: map} :macros)

(minsnip.setup {:cl #(match vim.bo.filetype
                       :lua "print($0)"
                       :c "printf(\"$0\\n\");"
                       :fennel "(print $0)"
                       :javascript "console.log($0)"
                       :rescript "Js.log($0)")})

(fn expand-snippet []
  (if (not (minsnip.jump)) (vim.api.nvim_input :<C-l>)))

(map i :<C-l> expand-snippet)

