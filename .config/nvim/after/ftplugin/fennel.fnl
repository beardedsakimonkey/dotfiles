(import-macros {: opt-local : map : undo_ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")

(opt-local commentstring ";; %s")
(opt-local comments ":;")
(opt-local keywordprg ":help")
(opt-local iskeyword
           "!,$,%,#,*,+,-,/,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94")

(opt-local lisp)
(opt-local autoindent)
;; Adapted from gpanders' config
(opt-local lispwords [:accumulate
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

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub :.fnl$ :.lua))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

(map n "]f" goto-lua :buffer)
(map n "[f" goto-lua :buffer)

;; fnlfmt: skip
(undo_ftplugin "setl cms< com< keywordprg< iskeyword< lisp< autoindent< lispwords<"
               "unabbrev <buffer> lambda"
               "sil! nunmap <buffer> ]f"
               "sil! nunmap <buffer> [f")

