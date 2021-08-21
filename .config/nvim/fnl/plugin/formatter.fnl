(local formatter (require :formatter))
(import-macros {: autocmd} :macros)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

;; Set up file formatting 
(formatter.setup {:filetype {:fennel [fnlfmt]}})

(fn format-write [] (vim.cmd ":silent FormatWrite"))

(autocmd BufWritePost *.fnl format-write)

