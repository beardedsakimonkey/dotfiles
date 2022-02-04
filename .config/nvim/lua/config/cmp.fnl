(local cmp (require :cmp))
(import-macros {: no} :macros)

(cmp.setup {:sources [{:name :buffer}
                      {:name :path}
                      {:name :nvim_lua}
                      {:name :nvim_lsp}]
            :mapping {:<Tab> (cmp.mapping.confirm {:select true})
                      :<C-j> (cmp.mapping.select_next_item)
                      :<C-k> (cmp.mapping.select_prev_item)}
            :experimental {:ghost_text true}})

