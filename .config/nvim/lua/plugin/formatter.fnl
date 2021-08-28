(local formatter (require :formatter))
(import-macros {: autocmd} :macros)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

;; Set up file formatting 
(formatter.setup {:filetype {:fennel [fnlfmt]}})

;; Need a new augroup here otherwise writing autocmds.fnl would wipe this.
(vim.cmd "augroup my-formatter | au!")

(fn format-write []
  (vim.cmd ":silent FormatWrite"))

(autocmd BufWritePost *.fnl format-write)

(vim.cmd "augroup END")

