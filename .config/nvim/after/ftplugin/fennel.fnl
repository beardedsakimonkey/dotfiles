(import-macros {: with-undo-ftplugin : opt-local : map : undo-ftplugin} :macros)

(vim.cmd "inoreabbrev <buffer> lambda λ")
(undo-ftplugin "unabbrev <buffer> lambda")

(fn goto-lua []
  (local from (vim.fn.expand "%:p"))
  (local to (from:gsub "%.fnl$" :.lua))
  (vim.cmd (.. "edit " (vim.fn.fnameescape to))))

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
                    (map n "[f" goto-lua :buffer))

