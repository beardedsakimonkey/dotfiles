(local udir (require :udir))
(import-macros {: no} :macros)

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

(fn is-file-hidden [file files cwd]
  ;; Hide .lua file if there's a sibling .fnl file
  (if (vim.endswith file.name :.lua)
      (let [fnl (string.gsub file.name :.lua$ :.fnl)]
        (contains? #(= fnl $1.name) files))
      :else
      (let [suffixes [:.bs.js :.o]]
        (endswith-any file.name suffixes))))

(udir.setup {:auto_open true
             :show_hidden_files false
             :is_file_hidden is-file-hidden})

(no n "-" :<Cmd>Udir<CR>)

