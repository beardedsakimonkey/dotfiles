(local cmp (require :cmp))

(fn small? [buf]
  (local byte-size
         (vim.api.nvim_buf_get_offset buf (vim.api.nvim_buf_line_count buf)))
  ;; Less than 1 MB
  (< byte-size (* 1024 1024)))

;; Source buffer words from visible, non-huge buffers
(fn get-bufnrs []
  (local visible-bufs {}) ; table to ensure a unique set of bufs
  (each [_ win (ipairs (vim.api.nvim_list_wins))]
    (local buf (vim.api.nvim_win_get_buf win))
    (when (small? buf)
      (tset visible-bufs buf true)))
  (vim.tbl_keys visible-bufs))

(cmp.setup {:sources [{:name :buffer :option {:get_bufnrs get-bufnrs}}
                      {:name :path}
                      {:name :nvim_lua}
                      {:name :nvim_lsp}]
            :snippet {:expand #nil}
            :mapping {:<Tab> (cmp.mapping.confirm {:select true})
                      :<C-j> #(if (cmp.visible) (cmp.select_next_item)
                                  (cmp.complete))
                      :<C-k> #(if (cmp.visible) (cmp.select_prev_item)
                                  (cmp.complete))}
            :experimental {:ghost_text true}})

(cmp.setup.filetype [:neorepl] {:enabled false})
