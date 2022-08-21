(local minsnip (require :minsnip))
(import-macros {: map} :macros)

(minsnip.setup {:cl #(match vim.bo.filetype
                       :c "printf(\"$0\\n\");"
                       :vim "echom $0"
                       :lua "print($0)"
                       :fennel "(print $0)"
                       :javascript "console.log($0)"
                       :rescript "Js.log($0)"
                       :rust "println!(\"$0\");")})

(fn expand-snippet []
  (if (not (minsnip.jump)) (vim.api.nvim_input :<C-l>)))

(map i :<C-l> expand-snippet)

