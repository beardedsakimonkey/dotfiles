(local udir (require :udir))
(local u (require :udir.util))
(local {: some?} (require :util))
(import-macros {: map} :macros)

(fn endswith-any [str suffixes]
  (var found false)
  (each [_ suf (ipairs suffixes) :until found]
    (when (vim.endswith str suf)
      (set found true)))
  found)

(fn is-file-hidden [file files _cwd]
  (var hidden? false)
  (local ext (string.match file.name "%.(%w-)$"))
  (when (= :lua ext)
    (local fnl (string.gsub file.name :lua$ :fnl))
    (set hidden? (or hidden? (some? files #(= fnl $1.name)))))
  (when (= :js ext)
    (local res (string.gsub file.name :js$ :res))
    (set hidden? (or hidden? (some? files #(= res $1.name)))))
  (set hidden? (or hidden? (endswith-any file.name [:.bs.js :.o])
                   (= :.git file.name)))
  hidden?)

(fn cd [cmd]
  (local store (require :udir.store))
  (local state (store.get))
  (vim.cmd (.. cmd " " (vim.fn.fnameescape state.cwd)))
  (vim.cmd :pwd))

(fn sort-by-mtime [files]
  (local store (require :udir.store))
  (local {: cwd} (store.get))
  (local mtimes {})
  (each [_ file (ipairs files)]
    ;; `fs_stat` fails in case of a broken symlink
    (local ?stat (vim.loop.fs_stat (u.join-path cwd file.name)))
    (local mtime (if ?stat ?stat.mtime.sec 0))
    (tset mtimes file.name mtime))
  (table.sort files #(if (= (= :directory $1.type) (= :directory $2.type))
                         (> (. mtimes $1.name) (. mtimes $2.name))
                         (= :directory $1.type))))

(local default-sort udir.config.sort)
(var default-sort? true)

(fn toggle-sort []
  (local sort (if default-sort?
                  sort-by-mtime
                  default-sort))
  (set default-sort? (not default-sort?))
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
                              :L #(cd :lcd)}
                    :sort default-sort})

(map n "-" :<Cmd>Udir<CR>)
