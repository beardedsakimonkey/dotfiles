(local cmp (require :cmp))
(import-macros {: no} :macros)

(cmp.setup {:sources [{:name :buffer}
                      {:name :path}
                      {:name :nvim_lua}
                      {:name :nvim_lsp}]
            :mapping {:<Tab> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                   :select true})}})

(no i :<C-j> :<C-n>)
(no i :<C-k> :<C-p>)

