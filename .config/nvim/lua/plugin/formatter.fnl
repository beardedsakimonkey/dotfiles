(local formatter (require :formatter))
(import-macros {: au} :macros)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

(fn gofmt []
  {:exe :gofmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

;; Set up file formatting 
(formatter.setup {:filetype {:fennel [fnlfmt]
                             :go [gofmt]}})

;; Need a new augroup here otherwise writing autocmds.fnl would wipe this.
(vim.cmd "augroup my-formatter | au!")

(fn format-write []
  (vim.cmd ":silent FormatWrite"))

(au BufWritePost *.fnl format-write)
(au BufWritePost *.go format-write)

(vim.cmd "augroup END")

