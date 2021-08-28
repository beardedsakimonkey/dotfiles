(local snap (require :snap))

(let [mappings {:enter-split [:<C-s>] :enter-vsplit [:<C-l>]}
      file (snap.config.file:with {: mappings :reverse true})]
  (snap.maps [[:<space>b (file {:producer :vim.buffer})]
              [:<space>o (file {:producer :vim.oldfile})]
              [:<space>f (file {:producer :ripgrep.file})]
              [:<space>a
               #(snap.run {:producer ((snap.get :consumer.limit) 10000
                                                                 (snap.get :producer.ripgrep.vimgrep))
                           :select (. (snap.get :select.vimgrep) :select)
                           :multiselect (. (snap.get :select.vimgrep)
                                           :multiselect)
                           :views [(snap.get :preview.vimgrep)]})]
              [:<space>g
               #(snap.run {:prompt :Help>
                           :producer ((snap.get :consumer.fzy) (snap.get :producer.vim.help))
                           :select (. (snap.get :select.help) :select)
                           :views [(snap.get :preview.help)]})]]))

