(import-macros {: with-undo-ftplugin : opt-local : map : undo-ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")
(undo-ftplugin "unabbrev <buffer> lambda")

;; fennel-repl
(when (= :prompt (vim.opt.buftype:get))
  (map n :<CR> :<Cmd>startinsert<CR><CR> :buffer)
  (undo-ftplugin "sil! nun <buffer> <CR>"))

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.fnl$" :.lua))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

(fn get-root-node [node]
  (var parent node)
  (var result node)
  (while (not= nil (parent:parent))
    (set result parent)
    (set parent (result:parent)))
  result)

(fn get-root-form [winid _bufnr]
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local cursor-node (ts-utils.get_node_at_cursor winid))
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
  (local cursor-node (ts-utils.get_node_at_cursor winid))
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

;; NOTE: not setting 'lisp' so that nvim-surround doesn't format

;; fnlfmt: skip
(with-undo-ftplugin (opt-local expandtab)
                    (opt-local commentstring ";; %s")
                    (opt-local comments "n:;")
                    (opt-local keywordprg ":help")
                    (opt-local iskeyword
                               "!,$,%,#,*,+,-,/,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94")
                    (opt-local autoindent)
                    (map n "]f" goto-lua :buffer)
                    (map n "[f" goto-lua :buffer)
                    (map n ",ee" #(eval-form false) :buffer)
                    (map n ",er" #(eval-form true) :buffer))

