(local {: exists? : f\} (require :util))
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

;; -- goto-lua -----------------------------------------------------------------

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.fnl$" :.lua))
  (if (exists? to)
      (vim.cmd (.. "edit " (f\ to)))
      (vim.api.nvim_err_writeln (.. "Cannot read file " to))))

;; -- eval-form ----------------------------------------------------------------

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
  (if (= :comment (cursor-node:type))
      cursor-node
      ;; Walk up the syntax tree until we hit a node that is wrapped in `()`
      (get-outer-form* cursor-node bufnr)))

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

;; -- goto-require -------------------------------------------------------------

(fn convert-to-fnl [lua-path]
  (local fnl-path (lua-path:gsub "%.lua$" :.fnl))
  (if (exists? fnl-path) fnl-path lua-path))

(fn search-packagepath [basename]
  (local paths (package.path:gsub "%?" basename))
  (var ?found nil)
  (each [path (paths:gmatch "[^;]+") :until ?found]
    (when (exists? path)
      (set ?found path)))
  ?found)

(fn search-runtimepath [basename]
  ;; Adapted from $VIMRUNTIME/lua/vim/_load_package.lua
  (local [?path]
         (vim.api.nvim__get_runtime [(.. :lua/ basename :.lua)
                                     (.. :lua/ basename :/init.lua)]
                                    false {:is_lua true}))
  ?path)

(fn get-basename []
  (local form (get-outer-form 0 0))
  (local form-text (vim.treesitter.get_node_text form 0))
  (local ?mod-name (form-text:match "%(require [\":]?([^)]+)\"?%)"))
  (if ?mod-name
      (?mod-name:gsub "%." "/")
      nil))

(fn goto-require []
  (local ?basename (get-basename))
  (if ?basename
      (do
        (local ?path (or (search-runtimepath ?basename)
                         (search-packagepath ?basename)))
        (if ?path
            (vim.cmd (.. "edit " (f\ (convert-to-fnl ?path))))
            (vim.api.nvim_err_writeln (.. "Could not find module for "
                                          ?basename))))
      (vim.api.nvim_err_writeln "Could not parse form. Is it a require?")))

;; -----------------------------------------------------------------------------

;; fnlfmt: skip
(with-undo-ftplugin (opt-local expandtab)
                    (opt-local commentstring ";; %s")
                    (opt-local keywordprg ":help")
                    (opt-local iskeyword -= ["." ":" "]" "["])
                    (map n "]f" goto-lua :buffer)
                    (map n "[f" goto-lua :buffer)
                    (map x ",a" ":Antifennel<CR>" :buffer)
                    (map n ",ee" #(eval-form false) :buffer)
                    (map n ",er" #(eval-form true) :buffer)
                    (map n "gd" goto-require :buffer))
