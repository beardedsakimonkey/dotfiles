;; (local ai (require :mini.ai))
;; (local surround (require :mini.surround))

;; (local ts-spec ai.gen_spec.treesitter)
;; (ai.setup {:n_lines 50
;;            :mappings {:goto_right ""
;;                       :goto_left ""
;;                       :inside :i
;;                       :around :a
;;                       :inside_next :in
;;                       :inside_last :il
;;                       :around_last :al
;;                       :around_next :an}
;;            :custom_textobjects {:F (ts-spec {:a "@function.outer"
;;                                              :i "@function.inner"})
;;                                 :f (ts-spec {:a "@call.outer" :i "@call.inner"})
;;                                 :B (ts-spec {:a "@block.outer"
;;                                              :i "@block.inner"})
;;                                 ;; :a (ts-spec {:a "@parameter.outer"
;;                                 ;;              :i "@parameter.inner"})
;;                                 :o (ts-spec {:a ["@conditional.outer"
;;                                                  "@loop.outer"]
;;                                              :i ["@conditional.inner"
;;                                                  "@loop.inner"]})
;;                                 :g (fn []
;;                                      (local from {:line 1 :col 1})
;;                                      (local to
;;                                             {:line (vim.fn.line "$")
;;                                              :col (-> (vim.fn.getline "$")
;;                                                       (: :len)
;;                                                       (+ 1))})
;;                                      {: from : to})}
;;            :search_method :cover_or_next})

;; (local ts-input surround.gen_spec.input.treesitter)

;; (surround.setup {:mappings {:delete :ds
;;                             :find ""
;;                             :replace :cs
;;                             :find_left ""
;;                             :add :ys
;;                             :highlight ""
;;                             :update_n_lines ""}
;;                  :custom_surroundings {:f {:input (ts-input {:outer "@call.outer"
;;                                                              :inner "@call.inner"})}
;;                                        :F {:input (ts-input {:outer "@function.outer"
;;                                                              :inner "@function.inner"})}
;;                                        :B {:input (ts-input {:outer "@block.outer"
;;                                                              :inner "@block.inner"})}
;;                                        :o {:input (ts-input {:outer "@conditional.outer"
;;                                                              :inner "@conditional.inner"})}}
;;                  :search_method :cover_or_next})

;; (vim.keymap.del :x :ys)
;; (vim.keymap.set :x :S "<Cmd>lua MiniSurround.add('visual')<CR>")

