(local udir (require :udir))
(local u (require :udir.util))
(import-macros {: map} :macros)

(fn endswith-any [str suffixes]
  (var found false)
  (each [_ suf (ipairs suffixes) :until found]
    (when (vim.endswith str suf)
      (set found true)))
  found)

(fn some? [list pred?]
  (var found false)
  (each [_ v (ipairs list) :until found]
    (when (pred? v)
      (set found true)))
  found)

(fn is-file-hidden [file files _cwd]
  (local ext (string.match file.name "%.(%w-)$"))
  (match ext
    :lua (let [fnl (string.gsub file.name :lua$ :fnl)]
           (some? files #(= fnl $1.name)))
    :js (let [res (string.gsub file.name :js$ :res)]
          (some? files #(= res $1.name)))
    _ (endswith-any file.name [:.bs.js :.o])))

(fn cd [cmd]
  (local store (require :udir.store))
  (local state (store.get))
  (vim.cmd (.. cmd " " (vim.fn.fnameescape state.cwd)))
  (vim.cmd :pwd))

(fn sort-recent [files]
  (local store (require :udir.store))
  (local {: cwd} (store.get))
  (local mtimes {})
  (each [_ file (ipairs files)]
    (local stat (assert (vim.loop.fs_stat (u.join-path cwd file.name))))
    (tset mtimes file.name stat.mtime.sec))
  (table.sort files #(if (= $1.type $2.type)
                         (> (. mtimes $1.name) (. mtimes $2.name))
                         (= :directory $1.type)))
  files)

(local default-sort udir.config.sort)

(fn toggle-sort []
  (local sort (if (= udir.config.sort default-sort) sort-recent default-sort))
  (tset udir.config :sort sort)
  (udir.reload))

(tset udir :config {:is_file_hidden is-file-hidden
                    :show_hidden_files false
                    :keymaps {:q udir.quit
                              :h udir.up_dir
                              :- udir.up_dir
                              :l udir.open
                              :<CR> udir.open
                              :i udir.open
                              :s #(udir.open :split)
                              :v #(udir.open :vsplit)
                              :t #(udir.open :tabedit)
                              :R udir.reload
                              :d udir.delete
                              :+ udir.create
                              :m udir.move
                              :r udir.move
                              :c udir.copy
                              :gh udir.toggle_hidden_files
                              :T toggle-sort
                              :C #(cd :cd)
                              :L #(cd :lcd)}})

(map n "-" :<Cmd>Udir<CR>)

