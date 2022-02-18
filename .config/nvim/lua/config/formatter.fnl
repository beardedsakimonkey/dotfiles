(local formatter (require :formatter))
(import-macros {: au} :macros)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

(fn gofmt []
  {:exe :gofmt :args ["-w"] :stdin true})

;; NOTE: YOU MUST UPDATE plugins.fnl WHEN ADDING NEW FILETYPES.
(formatter.setup {:filetype {:fennel [fnlfmt]
                             :go [gofmt]}})

(vim.cmd "augroup my-formatter | au!")
(au BufWritePost [*.fnl *.go] ":silent FormatWrite")
(vim.cmd "augroup END")

