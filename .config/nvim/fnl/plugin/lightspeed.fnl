(local lightspeed (require :lightspeed))
(import-macros {: map} :macros)

(lightspeed.setup {:jump_to_first_match true
                   :jump_on_partial_input_safety_timeout 400
                   ;; This can get _really_ slow if the window has a lot of content
                   ;; turn it on only if your machine can always cope with it.
                   :highlight_unique_chars false
                   :grey_out_search_area true
                   :match_only_the_start_of_same_char_seqs true
                   :limit_ft_matches 5
                   :full_inclusive_prefix_key :<c-x>})

(vim.api.nvim_del_keymap "" :s)
;; No need to unmap `S` since it already has a custom mapping

;; "Find"
(map n :f :<Plug>Lightspeed_s)
(map n :F :<Plug>Lightspeed_S)

;; "To"
(map n :t :<Plug>Lightspeed_f)
(map n :T :<Plug>Lightspeed_F)

