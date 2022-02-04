(local snap (require :snap))

(local defaults {:mappings {:enter-split [:<C-s>]
                            :enter-vsplit [:<C-l>]
                            :next [:<C-v>]}
                 :reverse true})

(fn with-defaults [tbl]
  (vim.tbl_extend :force {} defaults tbl))

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

(fn get-selected-text []
  (local reg (vim.fn.getreg "\""))
  (vim.cmd "normal! y")
  (local text (vim.fn.trim (vim.fn.getreg "@")))
  (vim.fn.setreg "\"" reg)
  text)

(local grep {:producer ((snap.get :consumer.limit) 10000
                                                   (snap.get :producer.ripgrep.vimgrep))
             :select (. (snap.get :select.vimgrep) :select)
             :multiselect (. (snap.get :select.vimgrep) :multiselect)
             :views [(snap.get :preview.vimgrep)]
             :prompt :Grep>})

;; TODO: Maybe just execute a command so that we can easily redo it.
(fn visual-grep []
  (snap.run (with-defaults (vim.tbl_extend :force {} grep
                                           {:initial_filter (get-selected-text)}))))

(fn normal-grep []
  (snap.run (with-defaults grep)))

(fn help-grep []
  (snap.run (with-defaults {:prompt :Help>
                            :producer ((snap.get :consumer.fzy) (snap.get :producer.vim.help))
                            ;; The built-in help select function doesn't handle splits
                            :select (fn help-select [selection winnr type]
                                      (let [cmd (match type
                                                  :vsplit "vert "
                                                  :split "belowright "
                                                  :tab "tab "
                                                  _ "")]
                                        (vim.api.nvim_command (.. cmd "help "
                                                                  (tostring selection)))))
                            :views [(snap.get :preview.help)]})))

(local file (snap.config.file:with defaults))

(snap.maps [[:<space>b (file {:producer sorted-buffers})]
            ;; TODO: filter out directories
            [:<space>o (file {:producer :vim.oldfile})]
            [:<space>f (file {:producer :ripgrep.file})]
            [:<space>a visual-grep {:modes [:v]}]
            [:<space>a normal-grep]
            [:<space>h help-grep]])

