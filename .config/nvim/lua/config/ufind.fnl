(local ufind (require :ufind))
(local {: $HOME : exists? : system : f\} (require :util))
(import-macros {: map : command} :macros)

(fn oldfiles []
  ;; Blacklist lua files that have a fnl counterpart
  (local blacklist {})
  (local oldfiles
         (->> vim.v.oldfiles
              (vim.tbl_filter (fn [file]
                                (if (not file) false
                                    (let [not-wildignored #(= 0
                                                              (vim.fn.empty (vim.fn.glob file)))
                                          not-dir #(= 0
                                                      (vim.fn.isdirectory file))
                                          not-manpage #(not (vim.startswith file
                                                                            "man://"))
                                          keep (and (not-wildignored) (not-dir)
                                                    (not-manpage))]
                                      (when (and keep
                                                 (not= nil
                                                       (file:match "%.fnl$")))
                                        (tset blacklist
                                              (file:gsub "%.fnl$" :.lua) true))
                                      keep))))
              (vim.tbl_filter (fn [file]
                                (not (. blacklist file))))))
  (ufind.open oldfiles nil))

(local uv vim.loop)

(macro foreach-entry [path syms form]
  (let [name-sym (. syms 1)
        type-sym (. syms 2)]
    `(let [fs# (assert (uv.fs_scandir ,path))]
       (var done?# false)
       (while (not done?#)
         (let [(,name-sym ,type-sym) (uv.fs_scandir_next fs#)]
           (if (not ,name-sym)
               (do
                 (set done?# true)
                 ;; If the first return value is nil and the second
                 ;; return value is non-nil then there was an error.
                 (assert (not ,type-sym)))
               ,form))))))

(fn find []
  (local cwd (vim.loop.cwd))

  (fn ls [path]
    (local ret [])
    ;; TODO: need the full path!
    (foreach-entry path [name type] (table.insert ret {: name : type}))
    ret)

  (fn on_complete [cmd item]
    (if (= :file item.type)
        (vim.cmd (.. cmd " " (f\ item.name)))
        ;; Not sure why `schedule` is needed, but without it, we won't
        ;; startinsert.
        (vim.schedule #(ufind.open (ls (.. cwd "/" item.name)) {: on_complete}))))

  (ufind.open (ls cwd) {:get_value #$1.name : on_complete}))

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
          (table.insert results {:path abs-path :base name}))))
  (each [_ dir (ipairs dirs)]
    (ls-rec! dir results)))

(fn notes []
  (local notes [])
  (local dir (.. $HOME :/notes))
  (assert (exists? dir))
  (ls-rec! dir notes)
  (ufind.open notes
              {:get_value #$.base
               :on_complete #(vim.cmd (.. $1 " " (f\ $2.path)))}))

(fn buffers []
  (local buffers (let [origin-buf (vim.api.nvim_win_get_buf 0)
                       bufs (vim.tbl_filter #(and (not= "" (vim.fn.bufname $1))
                                                  (not (vim.startswith (vim.fn.bufname $1)
                                                                       "man://"))
                                                  (= (vim.fn.buflisted $1) 1)
                                                  (= (vim.fn.bufexists $1) 1)
                                                  (not= $1 origin-buf))
                                            (vim.api.nvim_list_bufs))]
                   (table.sort bufs
                               #(> (. (vim.fn.getbufinfo $1) 1 :lastused)
                                   (. (vim.fn.getbufinfo $2) 1 :lastused)))
                   (vim.tbl_map #(vim.fn.bufname $1) bufs)))
  (ufind.open buffers nil))

(fn grep [query]
  (local (query ?path) (if (query:match "%%$")
                           (values (query:sub 1 -3) (vim.fn.expand "%:p"))
                           (values query nil)))

  (fn cb [stdout stderr exit]
    (if (not= 0 exit)
        (vim.notify (.. "Grep failed:" stderr) vim.log.levels.ERROR)
        (do
          (vim.schedule #(ufind.open (vim.split stdout "\n" {:trimempty true})
                                     {:pattern "^([^:]-):%d+:(.*)$"
                                      :on_complete (fn [cmd item]
                                                     (local (found? _
                                                                    matched-filename
                                                                    matched-line-nr)
                                                            (item:find "^([^:]-):(%d+):"))
                                                     (if found?
                                                         (vim.cmd (.. cmd " "
                                                                      (f\ matched-filename)
                                                                      "|"
                                                                      matched-line-nr))
                                                         (print "pattern match failed")))})))))

  (system [:rg :--vimgrep :-M 200 :--no-heading :--no-column "--" query ?path]
          cb))

(fn visual-grep [{: args}]
  (grep args))

(fn grep-expr []
  (local dir? (-> (vim.fn.expand "%:p") (vim.fn.isdirectory) (= 1)))
  (.. ":<C-u>Grep " (if dir? " %<Left><Left>" "")))

(map n :<space>o oldfiles)
(map n :<space>f find)
(map n :<space>n notes)
(map n :<space>b buffers)
(map n :<space>a grep-expr :expr)
(command :Grep visual-grep {:nargs "+"})
(map x :<space>a "\"vy:Grep <C-r>v<CR>")
