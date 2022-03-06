(import-macros {: opt-local : map : with-undo-ftplugin} :macros)

;; fnlfmt: skip
(with-undo-ftplugin (opt-local keywordprg :help)
                    (map n :q :<Cmd>lclose<Bar>q<CR> :buffer :silent :nowait)
                    (map n :<CR> "<C-]>" :buffer)
                    ;; Adapted from gpanders' config
                    (map n :u :<C-u> :buffer :nowait)
                    (map n :d :<C-d> :buffer :nowait)
                    (map n :U :<C-b> :buffer :nowait)
                    (map n :D :<C-f> :buffer :nowait)
                    (map n :<Tab>
                         "/\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>"
                         :buffer)
                    (map n :<S-Tab>
                         "?\\C\\%>1l\\f\\+([1-9][a-z]\\=)\\ze\\_.\\+\\%$<CR><Cmd>nohlsearch<CR>"
                         :buffer))

