(module plugin.formatter {autoload {formatter formatter}})

;; Register formatters into a table
(local formatters {})

(fn formatters.fnlfmt []
  "The fennel formatter"
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

;; Set up file formatting 
(formatter.setup {:filetype {:fennel [formatters.fnlfmt]}})

;; Register autocommands for file formatting on save
(vim.cmd "augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.fnl FormatWrite
augroup END" true)

