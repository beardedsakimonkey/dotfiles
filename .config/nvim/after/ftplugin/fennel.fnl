(import-macros {: with-undo-ftplugin : opt-local : map : undo-ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")
(undo-ftplugin "unabbrev <buffer> lambda")

;; fennel-repl
(when (= :prompt (: vim.opt.buftype :get))
  (map n :<CR> :<Cmd>startinsert<CR><CR> :buffer)
  (undo-ftplugin "sil! nun <buffer> <CR>"))

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.fnl$" :.lua))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

(fn get-outer-node [node]
  (var parent node)
  (var result node)
  (while (not= nil (parent:parent))
    (set result parent)
    (set parent (result:parent)))
  result)

(fn get-outer-form-text [winid]
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local cursor-node (ts-utils.get_node_at_cursor winid))
  (local outer-node (get-outer-node cursor-node))
  (vim.treesitter.get_node_text outer-node (vim.fn.winbufnr winid)))

;; NOTE: After inserting lines into the prompt buffer, the prompt prefix is not
;; drawn until entering insert mode. (`init_prompt()` in edit.c)
(fn eval-outer-form []
  (local repl (require :fennel-repl))
  (local bufnr (repl.open))
  ;; (vim.api.nvim_clear_autocmds {:buffer bufnr})
  (local repl-focused (vim.startswith (vim.api.nvim_buf_get_name bufnr)
                                      :fennel-repl))
  ;; Initializing the repl moves us to a new win, so use the alt win
  (local text (get-outer-form-text (if (not repl-focused)
                                       (vim.fn.win_getid (vim.fn.winnr "#"))
                                       0)))
  (repl.callback bufnr text))

;; fnlfmt: skip
(with-undo-ftplugin (opt-local expandtab)
                    (opt-local commentstring ";; %s")
                    (opt-local comments "n:;")
                    (opt-local keywordprg ":help")
                    (opt-local iskeyword
                               "!,$,%,#,*,+,-,/,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94")
                    (opt-local lisp)
                    (opt-local autoindent)
                    ;; Adapted from gpanders' config
                    (opt-local lispwords
                               [:accumulate
                                :collect
                                :do
                                :doto
                                :each
                                :fn
                                :for
                                :icollect
                                :lambda
                                :let
                                :macro
                                :macros
                                :match
                                :when
                                :while
                                :with-open])
                    (map n "]f" goto-lua :buffer)
                    (map n "[f" goto-lua :buffer)
                    (map n "<space>ev" eval-outer-form :buffer))

