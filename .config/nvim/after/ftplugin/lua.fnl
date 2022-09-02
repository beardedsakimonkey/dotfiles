(local {: exists? : f\} (require :util))
(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

(fn goto-fnl []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.lua$" :.fnl))
  (if (exists? to)
      (vim.cmd (.. "edit " (f\ to)))
      (vim.api.nvim_err_writeln (.. "Cannot read file " to))))

(fn goto-require []
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local cursor-node (ts-utils.get_node_at_cursor 0 false))
  (local form-text (vim.treesitter.get_node_text cursor-node 0))
  (local ?mod-name (form-text:match "[\"']([^\"']+)[\"']"))
  (when (not= nil ?mod-name)
    ;; Adapted from $VIMRUNTIME/lua/vim/_load_package.lua
    (local basename (?mod-name:gsub "%." "/"))
    (local paths [(.. :lua/ basename :.lua) (.. :lua/ basename :/init.lua)])
    (local found (vim.api.nvim__get_runtime paths false {:is_lua true}))
    (if (> (length found) 0)
        (let [path (. found 1)]
          (vim.cmd (.. "edit " (f\ path))))
        (vim.api.nvim_err_writeln (.. "Cannot find module " basename)))))

;; fnlfmt: skip
(with-undo-ftplugin (opt-local keywordprg ":help")
                    (map n "]f" goto-fnl :buffer)
                    (map n "[f" goto-fnl :buffer)
                    (map n "gd" goto-require :buffer))

