(import-macros {: with-undo-ftplugin : opt-local : map : undo-ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")
(undo-ftplugin "unabbrev <buffer> lambda")

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

(fn get-outer-form-text [init-repl?]
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local alt-win (-> (vim.fn.winnr "#")
                     (vim.fn.win_getid)))
  ;; Initializing the repl moves us to a new win, so use the alt win
  (local winid (if init-repl? alt-win 0))
  (local node (ts-utils.get_node_at_cursor winid))
  (local outer (get-outer-node node))
  (vim.treesitter.get_node_text outer (tonumber (vim.fn.winbufnr winid))))

;; NOTE: After inserting lines into the prompt buffer, the prompt prefix is not
;; drawn until entering insert mode. (`init_prompt()` in edit.c)
(fn eval-outer-form []
  (local {: get_bufnr : callback : start} (require :fennel-repl))
  (var buf (get_bufnr))
  (local init-repl? (= nil buf))
  (when init-repl?
    (start)
    (set buf (get_bufnr)))
  (local text (get-outer-form-text init-repl?))
  (callback buf text))

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

