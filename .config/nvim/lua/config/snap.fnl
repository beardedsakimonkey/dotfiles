(local snap (require :snap))
(import-macros {: map} :macros)

(local defaults {:mappings {:enter-split [:<C-s>]
                            :enter-vsplit [:<C-l>]
                            :next [:<C-v>]}
                 :consumer :fzy
                 :reverse true
                 :prompt ""})

(fn with-defaults [tbl]
  (vim.tbl_extend :force {} defaults tbl))

;; Unlike the built-in buffers producer, this filters out the current buffer and
;; sorts buffers by last used.
(fn get-buffers [request]
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

(fn buffers [request]
  (snap.sync (get-buffers request)))

(fn get-selected-text []
  (local reg (vim.fn.getreg "\""))
  (vim.cmd "normal! y")
  (local text (vim.fn.trim (vim.fn.getreg "@")))
  (vim.fn.setreg "\"" reg)
  text)

(local grep-cfg {:producer ((snap.get :consumer.limit) 10000
                                                       (snap.get :producer.ripgrep.vimgrep))
                 :select (. (snap.get :select.vimgrep) :select)
                 :multiselect (. (snap.get :select.vimgrep) :multiselect)
                 :views [(snap.get :preview.vimgrep)]
                 :prompt :Grep>})

;; TODO: Maybe just execute a command so that we can easily redo it.
(fn visual-grep []
  (snap.run (with-defaults (vim.tbl_extend :force {} grep-cfg
                                           {:initial_filter (get-selected-text)}))))

(fn grep []
  (snap.run (with-defaults grep-cfg)))

(fn help []
  (snap.run (with-defaults {:prompt :Help>
                            ;; FIXME: it seems like the producer is yielding
                            ;; stuff, but the consumer doesn't.
                            :producer ((snap.get :consumer.fzy) (snap.get :producer.vim.help))
                            ;; The built-in help select function doesn't handle splits
                            :select (fn _help-select [selection _winnr type]
                                      (let [cmd (match type
                                                  :vsplit "vert "
                                                  :split "belowright "
                                                  :tab "tab "
                                                  _ "")]
                                        (vim.api.nvim_command (.. cmd "help "
                                                                  (tostring selection)))))
                            :views [(snap.get :preview.help)]})))

;; Oldfiles producer that filters out directories and man pages
(fn get-oldfiles []
  (->> vim.v.oldfiles
       (vim.tbl_filter (fn [?file]
                         (local file (or ?file ""))
                         (local wildignored
                                (= 1 (vim.fn.empty (vim.fn.glob file))))
                         (local dir (= 0 (vim.fn.isdirectory file)))
                         (local manpage (vim.startswith file "man://"))
                         (and (not wildignored) dir (not manpage))))))

(fn oldfiles []
  (snap.sync get-oldfiles))

(local file (snap.config.file:with defaults))

(map n :<space>b (file {:producer buffers}))
(map n :<space>o (file {:producer oldfiles}))
(map n :<space>f (file {:producer :ripgrep.file}))
(map n :<space>a grep)
(map x :<space>a visual-grep)
(map n :<space>h help)

