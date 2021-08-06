(module plugin.snap {autoload {snap snap}})

(local mappings {
                :enter-split [:<C-s>]
                :enter-vsplit [:<C-l>]
                })

(local file (snap.config.file:with { :mappings mappings }))

(snap.maps [
                [:<space>b (file {:producer :vim.buffer})]
                [:<space>o (file {:producer :vim.oldfile})]
            ])
  
