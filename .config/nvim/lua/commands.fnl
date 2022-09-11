(local {: FF-PROFILE} (require :util))
(import-macros {: command} :macros)

(fn update-userjs []
  (vim.cmd (.. "lcd " FF-PROFILE))
  (vim.cmd "terminal ./updater.sh && ./prefsCleaner.sh")
  (vim.cmd "lcd -"))

(command :UpdateUserJs update-userjs)
