(local {: f-exists? : f\} (require :util))
(import-macros {: with-undo-ftplugin : opt-local : map : undo-ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")
(undo-ftplugin "unabbrev <buffer> lambda")

;; fennel-repl
(when (= :prompt (vim.opt.buftype:get))
  (vim.api.nvim_clear_autocmds {:event :BufEnter :buffer 0})
  (map n :<CR> :<Cmd>startinsert<CR><CR> :buffer)
  (map i :<C-p> "pumvisible() ? '<C-p>' : '<C-x><C-l><C-p>'" :buffer :expr)
  (map i :<C-n> "pumvisible() ? '<C-n>' : '<C-x><C-l><C-n>'" :buffer :expr)
  (undo-ftplugin "sil! nun <buffer> <CR>")
  (undo-ftplugin "sil! nun <buffer> <C-p>")
  (undo-ftplugin "sil! nun <buffer> <C-n>"))

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.fnl$" :.lua))
  (if (f-exists? to)
      (vim.cmd (.. "edit " (f\ to)))
      (vim.api.nvim_err_writeln (.. "Cannot read file " to))))

(fn get-root-node [node]
  (var parent node)
  (var result node)
  (while (not= nil (parent:parent))
    (set result parent)
    (set parent (result:parent)))
  result)

(fn get-root-form [winid _bufnr]
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local cursor-node (ts-utils.get_node_at_cursor winid false))
  (get-root-node cursor-node))

(fn form? [node bufnr]
  (local text (vim.treesitter.get_node_text node bufnr))
  (local first (text:sub 1 1))
  (local last (text:sub -1))
  (and (= "(" first) (= ")" last)))

(fn get-outer-form* [node bufnr]
  (if (not node) nil
      (form? node bufnr) node
      (get-outer-form* (node:parent) bufnr)))

(fn get-outer-form [winid bufnr]
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local cursor-node (ts-utils.get_node_at_cursor winid false))
  ;; Walk up the syntax tree until we hit a node that is wrapped in `()`
  (get-outer-form* cursor-node bufnr))

;; NOTE: After inserting lines into the prompt buffer, the prompt prefix is not
;; drawn until entering insert mode. (`init_prompt()` in edit.c)
(fn eval-form [root?]
  (local repl (require :fennel-repl))
  (local repl-bufnr (repl.open))
  (local repl-focused (vim.startswith (vim.api.nvim_buf_get_name repl-bufnr)
                                      :fennel-repl))
  ;; Initializing the repl moves us to a new win, so use the alt win
  (local winid (if (not repl-focused)
                   (vim.fn.win_getid (vim.fn.winnr "#"))
                   0))
  (local bufnr (vim.fn.winbufnr winid))
  (local form ((if root? get-root-form get-outer-form) winid bufnr))
  (local text (vim.treesitter.get_node_text form bufnr))
  (repl.callback repl-bufnr text))

(fn goto-require []
  (local form (get-outer-form 0 0))
  (local form-text (vim.treesitter.get_node_text form 0))
  (local ?mod-name (form-text:match "%(require [\":]?([^)]+)\"?%)"))
  (when (not= nil ?mod-name)
    ;; Adapted from $VIMRUNTIME/lua/vim/_load_package.lua
    (local basename (?mod-name:gsub "%." "/"))
    (local paths [(.. :lua/ basename :.lua) (.. :lua/ basename :/init.lua)])
    (local found (vim.api.nvim__get_runtime paths false {:is_lua true}))
    ;; TODO: Fallback to package.path
    (if (> (length found) 0)
        (let [lua-path (. found 1)
              fnl-path (lua-path:gsub "%.lua$" :.fnl)
              path (if (f-exists? fnl-path) fnl-path lua-path)]
          (vim.cmd (.. "edit " (f\ path))))
        (vim.api.nvim_err_writeln (.. "Cannot find module " basename)))))

;; fnlfmt: skip
(with-undo-ftplugin (opt-local expandtab)
                    (opt-local commentstring ";; %s")
                    (opt-local keywordprg ":help")
                    (opt-local iskeyword -= ["." ":"])
                    (map n "]f" goto-lua :buffer)
                    (map n "[f" goto-lua :buffer)
                    (map n ",ee" #(eval-form false) :buffer)
                    (map n ",er" #(eval-form true) :buffer)
                    (map n "gd" goto-require :buffer))

