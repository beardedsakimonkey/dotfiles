(module plugin.compe {autoload {compe compe}})

(compe.setup {:enabled true
              :autocomplete true
              :min_length 2
              :preselect :always
              :source {:path true
                       ; :omni true
                       :buffer true
                       :nvim_lsp true}})

(set vim.g.completion_chain_complete_list
     [{:complete_items [:lsp]} {:mode :<c-p>} {:mode :<c-n>}])

(set vim.g.completion_auto_change_source 1)
(set vim.g.completion_trigger_keyword_length 1)
(set vim.g.completion_enable_auto_signature 0)
(set vim.g.completion_enable_auto_hover 0)
(set vim.g.completion_confirm_key "\\<c-i>")

(vim.api.nvim_set_keymap :i :<C-j> :<C-n> {:noremap true})
(vim.api.nvim_set_keymap :i :<C-k> :<C-p> {:noremap true})
(vim.api.nvim_set_keymap :i :<Tab> "compe#confirm('<tab>')"
                         {:noremap true :expr true})

