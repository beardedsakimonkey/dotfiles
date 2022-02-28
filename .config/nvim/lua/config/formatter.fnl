(local formatter (require :formatter))
(import-macros {: augroup : autocmd} :macros)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

(fn gofmt []
  {:exe :gofmt :args [:-w] :stdin true})

;; NOTE: YOU MUST UPDATE plugins.fnl WHEN ADDING NEW FILETYPES.
(formatter.setup {:filetype {:fennel [fnlfmt] :go [gofmt]}})

(augroup :my/formatter
         (autocmd BufWritePost [*.fnl *.go] ":silent FormatWrite"))

