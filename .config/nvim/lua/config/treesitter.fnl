(local configs (require :nvim-treesitter.configs))
(import-macros {: map} :macros)

(configs.setup {:ensure_installed [:query :javascript :glsl :lua :fennel]
                :highlight {:enable true}
                :playground {:enable true
                             :disable {}
                             :updatetime 25
                             :persist_queries false
                             :keybindings {:toggle_query_editor :o
                                           :toggle_hl_groups :i
                                           :toggle_injected_languages :t
                                           :toggle_anonymous_nodes :a
                                           :toggle_language_display :I
                                           :focus_language :f
                                           :unfocus_language :F
                                           :update :R
                                           :goto_node :<cr>
                                           :show_help "?"}}
                :textobjects {:select {:enable false
                                       :lookahead true
                                       :keymaps {:af "@function.outer"
                                                 :if "@function.inner"
                                                 :ac "@multicomment.outer"
                                                 :ic "@multicomment.outer"
                                                 :aP "@parameter.outer"
                                                 :iP "@parameter.inner"
                                                 :al "@loop.outer"
                                                 :il "@loop.inner"
                                                 :aC "@call.outer"
                                                 :iC "@call.inner"}}}
                :query_linter {:enable true
                               :use_virtual_text true
                               :lint_events [:BufWrite :BufEnter]}})

;; From nvim-treesitter/playground
(map n :gy :<Cmd>TSHighlightCapturesUnderCursor<CR>)

