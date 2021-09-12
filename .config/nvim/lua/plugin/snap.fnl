(local snap (require :snap))

;; Based off of
;; https://github.com/camspiers/snap/blob/main/fnl/snap/producer/vim/buffer.fnl
(fn get-sorted-buffers [request]
  (fn []
    (let [original-buf (vim.api.nvim_win_get_buf (. request :winnr))
          bufs (vim.tbl_filter #(and (not= (vim.fn.bufname $1) "")
                                     (= (vim.fn.buflisted $1) 1)
                                     (= (vim.fn.bufexists $1) 1)
                                     (not= $1 original-buf))
                               (vim.api.nvim_list_bufs))]
      (table.sort bufs
                  #(> (. (vim.fn.getbufinfo $1) 1 :lastused)
                      (. (vim.fn.getbufinfo $2) 1 :lastused)))
      (vim.tbl_map #(vim.fn.bufname $1) bufs))))

(fn sorted-buffers [request]
  (snap.sync (get-sorted-buffers request)))

(let [mappings {:enter-split [:<C-s>] :enter-vsplit [:<C-l>] :next [:<C-v>]}
      file (snap.config.file:with {: mappings :reverse true})]
  (snap.maps [[:<space>b (file {:producer sorted-buffers})]
              [:<space>o (file {:producer :vim.oldfile})]
              [:<space>f (file {:producer :ripgrep.file})]
              [:<space>a
               #(snap.run {:producer ((snap.get :consumer.limit) 10000
                                                                 (snap.get :producer.ripgrep.vimgrep))
                           :select (. (snap.get :select.vimgrep) :select)
                           :multiselect (. (snap.get :select.vimgrep)
                                           :multiselect)
                           :views [(snap.get :preview.vimgrep)]})]
              [:<space>h
               #(snap.run {:prompt :Help>
                           :producer ((snap.get :consumer.fzy) (snap.get :producer.vim.help))
                           :select (. (snap.get :select.help) :select)
                           :views [(snap.get :preview.help)]})]]))

