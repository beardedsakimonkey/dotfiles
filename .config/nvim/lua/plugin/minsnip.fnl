(local minsnip (require :minsnip))
(import-macros {: no} :macros)

(minsnip.setup {:log #(match vim.bo.filetype
                        :lua "print($0)"
                        :fennel "(print $0)"
                        :javascript "console.log($0)"
                        :rescript "Js.log($0)")})

(fn expand-snippet []
  (if (not (minsnip.jump)) (vim.api.nvim_input :<C-l>)))

(no i :<C-l> expand-snippet)

