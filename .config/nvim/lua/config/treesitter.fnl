(local configs (require :nvim-treesitter.configs))
(import-macros {: map} :macros)

(fn large-buf? [lang bufnr]
  (local size (vim.fn.getfsize (vim.fn.bufname bufnr)))
  (or (> size (* 1024 1024)) (= size -2) (= lang :markdown)))

;; Enable treesitter highlighting for lua
(set vim.g.ts_highlight_lua true)

(configs.setup {:ensure_installed [:javascript
                                   :fennel
                                   :markdown
                                   :markdown_inline
                                   :query]
                :highlight {:enable true :disable large-buf?}
                :playground {:enable true
                             :disable {}
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
                                       :disable large-buf?
                                       :lookahead true
                                       :keymaps {:aF "@function.outer"
                                                 :iF "@function.inner"
                                                 :af "@call.outer"
                                                 :if "@call.inner"
                                                 :aB "@block.outer"
                                                 :iB "@block.inner"
                                                 ;; :ao "@loop.outer"
                                                 ;; :io "@loop.inner"
                                                 :aa "@parameter.outer"
                                                 :ia "@parameter.inner"}}}
                ;; :refactor {:smart_rename {:enable true
                ;;                           :keymaps {:smart_rename :gR}}}
                :query_linter {:enable true
                               :use_virtual_text true
                               :lint_events [:BufWrite :BufEnter]}})

;; From nvim-treesitter/playground
(map n :gy :<Cmd>TSHighlightCapturesUnderCursor<CR>)
