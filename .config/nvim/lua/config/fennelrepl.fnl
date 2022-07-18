(fn start-repl []
  (local {: start} (require :fennel-repl))
  (start {:autoinsert false}))

(vim.api.nvim_create_user_command :FennelRepl start-repl {})

