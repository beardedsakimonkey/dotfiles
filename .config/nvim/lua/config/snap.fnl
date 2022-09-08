(local snap (require :snap))
(local {: $HOME : exists?} (require :util))
(import-macros {: map : command} :macros)

(local defaults {:mappings {:enter-split [:<C-s>]
                            :enter-vsplit [:<C-l>]
                            :next [:<C-v>]}
                 :consumer :fzy
                 :reverse true
                 :prompt ""})

(fn with-defaults [...]
  (vim.tbl_extend :force {} defaults ...))

;; Unlike the built-in buffers producer, this filters out the current buffer and
;; sorts buffers by last used.
(fn get-buffers [request]
  (fn []
    (let [original-buf (vim.api.nvim_win_get_buf (. request :winnr))
          bufs (vim.tbl_filter #(and (not= "" (vim.fn.bufname $1))
                                     (not (vim.startswith (vim.fn.bufname $1)
                                                          "man://"))
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

(local grep-cfg {:producer ((snap.get :consumer.limit) 10000
                                                       (snap.get :producer.ripgrep.vimgrep))
                 :select (. (snap.get :select.vimgrep) :select)
                 :multiselect (. (snap.get :select.vimgrep) :multiselect)
                 :views [(snap.get :preview.vimgrep)]
                 :prompt :Grep>})

(fn visual-grep [{: args}]
  (snap.run (with-defaults grep-cfg {:initial_filter args})))

(fn grep []
  (snap.run (with-defaults grep-cfg)))

(fn help []
  (snap.run (with-defaults {:prompt :Help>
                            :producer ((snap.get :consumer.fzy) (snap.get :producer.vim.help))
                            ;; The built-in help select function doesn't handle
                            ;; splits. Note that it won't split if a help buffer
                            ;; is currently visible.
                            :select (fn [selection _winnr type]
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
  ;; Blacklist lua files that have a fnl counterpart
  (local blacklist {})
  (->> vim.v.oldfiles
       (vim.tbl_filter (fn [file]
                         (if (not file) false
                             (let [not-wildignored #(= 0
                                                       (vim.fn.empty (vim.fn.glob file)))
                                   not-dir #(= 0 (vim.fn.isdirectory file))
                                   not-manpage #(not (vim.startswith file
                                                                     "man://"))
                                   keep (and (not-wildignored) (not-dir)
                                             (not-manpage))]
                               (when (and keep (not= nil (file:match "%.fnl$")))
                                 (tset blacklist (file:gsub "%.fnl$" :.lua)
                                       true))
                               keep))))
       (vim.tbl_filter (fn [file]
                         (not (. blacklist file))))))

(fn oldfiles []
  (snap.sync get-oldfiles))

(fn ls [path]
  (local dir (assert (vim.loop.fs_opendir path nil 1000)))
  ;; NOTE: `fs_readdir` fails on empty directories
  (local ?files (vim.loop.fs_readdir dir))
  (assert (vim.loop.fs_closedir dir))
  (or ?files []))

(fn ls-rec! [path results]
  (local files (ls path))
  (local dirs [])
  (each [_ {: name : type} (ipairs files)]
    (when (not (vim.startswith name "."))
      (local abs-path (.. path "/" name))
      (if (= :directory type)
          (table.insert dirs abs-path)
          (table.insert results abs-path))))
  (each [_ dir (ipairs dirs)]
    (ls-rec! dir results)))

(fn get-notes []
  (local ret [])
  (local dir (.. $HOME :/notes))
  (assert (exists? dir))
  (ls-rec! dir ret)
  ret)

(fn notes []
  (snap.sync get-notes))

(local file (snap.config.file:with defaults))

(map n :<space>b (file {:producer buffers}))
(map n :<space>o (file {:producer oldfiles}))
(map n :<space>f (file {:producer :ripgrep.file}))
(map n :<space>n (file {:producer notes}))
(map n :<space>a grep)
(command :Grep visual-grep {:nargs "+"})
(map x :<space>a "\"vy:Grep <C-r>v<CR>")
(map n :<space>h help)

