(local udir (require :udir))
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

(local m udir.map)

(udir.setup {:auto_open true
             :show_hidden_files false
             :is_file_hidden is-file-hidden
             :keymaps {:q m.quit
                       :h m.up_dir
                       :- m.up_dir
                       :l m.open
                       :i m.open
                       :<CR> m.open
                       :s m.open_split
                       :v m.open_vsplit
                       ;; Don't clobber (t)eleport
                       :<C-t> m.open_tab
                       :R m.reload
                       :r m.move
                       :d m.delete
                       :+ m.create
                       :m m.move
                       :c m.copy
                       :C "<Cmd>lua vim.cmd('lcd ' .. vim.fn.fnameescape(require('udir.store').get().cwd))<BAR>pwd<CR>"
                       :gh m.toggle_hidden_files}})

(map n "-" :<Cmd>Udir<CR>)

