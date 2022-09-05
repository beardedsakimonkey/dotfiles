(local configs (require :nvim-treesitter.configs))
(local highlight (require :nvim-treesitter.highlight))
(import-macros {: map} :macros)

(configs.setup {:ensure_installed [:javascript
                                   :lua
                                   :fennel
                                   :markdown
                                   :markdown_inline]
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
                :textobjects {:select {:enable true
                                       :lookahead true
                                       :keymaps {:aF "@function.outer"
                                                 :iF "@function.inner"
                                                 :af "@call.outer"
                                                 :if "@call.inner"
                                                 :aB "@block.outer"
                                                 :iB "@block.inner"
                                                 :ao "@loop.outer"
                                                 :io "@loop.inner"
                                                 :aa "@parameter.outer"
                                                 :ia "@parameter.inner"}}}
                :query_linter {:enable true
                               :use_virtual_text true
                               :lint_events [:BufWrite :BufEnter]}})

;; From nvim-treesitter/playground
(map n :gy :<Cmd>TSHighlightCapturesUnderCursor<CR>)

;; Custom '@' captures used in after/queries/*
(highlight.set_custom_captures {:text.title1 :markdownH1
                                :text.title2 :markdownH2})

