(local qdir (require :qdir))
(import-macros {: no} :macros)

(fn endswith-any [str suffixes]
  (var hidden false)
  (each [_ suf (ipairs suffixes) :until hidden]
    (when (vim.endswith str suf)
      (set hidden true)))
  hidden)

(qdir.setup {:auto-open true
             :show-hidden-files false
             :is-file-hidden (fn [file cwd]
                               (let [suffixes [:.bs.js :.o]]
                                 (when (vim.startswith cwd
                                                       (vim.fn.stdpath :config))
                                   (table.insert suffixes :.lua))
                                 (endswith-any file.name suffixes)))})

(no n "-" :<Cmd>Qdir<CR>)

