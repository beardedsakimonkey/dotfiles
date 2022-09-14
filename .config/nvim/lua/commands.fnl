(local {: FF-PROFILE : s\} (require :util))
(import-macros {: command} :macros)

(fn update-userjs []
  (vim.cmd (.. "botright new | terminal cd " (s\ FF-PROFILE)
               " && ./updater.sh && ./prefsCleaner.sh")))

(command :UpdateUserJs update-userjs)

(command :Scratch "call my#scratch(<q-args>, <q-mods>)"
         {:nargs 1 :complete :command})

(command :Messages "<mods> Scratch messages" {:nargs 0})
(command :Marks "<mods> Scratch marks <args>" {:nargs "?"})
(command :Highlight "<mods> Scratch highlight <args>"
         {:nargs "?" :complete :highlight})

(command :Jumps "<mods> Scratch jumps" {:nargs 0})
(command :Scriptnames "<mods> Scratch scriptnames" {:nargs 0})
