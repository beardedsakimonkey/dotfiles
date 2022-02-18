(local udir (require :udir))
(import-macros {: map} :macros)

(fn endswith-any [str suffixes]
  (var hidden false)
  (each [_ suf (ipairs suffixes) :until hidden]
    (when (vim.endswith str suf)
      (set hidden true)))
  hidden)

(fn contains? [matches? list]
  (var found false)
  (each [_ v (ipairs list) :until found]
    (when (matches? v)
      (set found true)))
  found)

(fn is-file-hidden [file files _cwd]
  ;; Hide .lua file if there's a sibling .fnl file
  (if (vim.endswith file.name :.lua)
      (let [fnl (string.gsub file.name :.lua$ :.fnl)]
        (contains? #(= fnl $1.name) files))
      :else
      (let [suffixes [:.bs.js :.o]]
        (endswith-any file.name suffixes))))

(local m udir.map)

(udir.setup {:auto_open true
             :show_hidden_files false
             :is_file_hidden is-file-hidden
             :keymaps {:q m.quit
                       :h m.up_dir
                       :- m.up_dir
                       :l m.open
                       :<CR> m.open
                       :s m.open_split
                       :v m.open_vsplit
                       ;; Don't clobber (t)eleport
                       :T m.open_tab
                       :R m.reload
                       :r m.move
                       :d m.delete
                       :+ m.create
                       :m m.move
                       :c m.copy
                       :C "<Cmd>lua vim.cmd('lcd ' .. vim.fn.fnameescape(require('udir.store').get().cwd))<CR>"
                       :gh m.toggle_hidden_files}})

(map n "-" :<Cmd>Udir<CR>)

