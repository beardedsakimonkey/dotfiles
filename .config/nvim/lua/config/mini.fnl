(local ai (require :mini.ai))
(local surround (require :mini.surround))

(local ts-spec ai.gen_spec.treesitter)
(ai.setup {:n_lines 50
           :mappings {:goto_right "g]"
                      :inside_last :il
                      :inside :i
                      :around :a
                      :around_next :an
                      :inside_next :in
                      :goto_left "g["
                      :around_last :al}
           :custom_textobjects {:F (ts-spec {:a "@function.outer"
                                             :i "@function.inner"})
                                :f (ts-spec {:a "@call.outer" :i "@call.inner"})
                                :B (ts-spec {:a "@block.outer"
                                             :i "@block.inner"})
                                :o (ts-spec {:a ["@conditional.outer"
                                                 "@loop.outer"]
                                             :i ["@conditional.inner"
                                                 "@loop.inner"]})
                                :g (fn []
                                     (local from {:line 1 :col 1})
                                     (local to
                                            {:line (vim.fn.line "$")
                                             :col (-> (vim.fn.getline "$")
                                                      (: :len)
                                                      (+ 1))})
                                     {: to : from})}
           :search_method :cover_or_next})

(local ts-input surround.gen_spec.input.treesitter)

(surround.setup {:mappings {:delete :ds
                            :find ""
                            :replace :cs
                            :find_left ""
                            :add :ys
                            :highlight ""
                            :update_n_lines ""}
                 :custom_surroundings {:f {:input (ts-input {:outer "@call.outer"
                                                             :inner "@call.inner"})}
                                       :F {:input (ts-input {:outer "@function.outer"
                                                             :inner "@function.inner"})}
                                       :B {:input (ts-input {:outer "@block.outer"
                                                             :inner "@block.inner"})}
                                       :o {:input (ts-input {:outer "@conditional.outer"
                                                             :inner "@conditional.inner"})}}
                 :search_method :cover_or_next})

(vim.keymap.del :x :ys)
(vim.keymap.set :x :S "<Cmd>lua MiniSurround.add('visual')<CR>")

