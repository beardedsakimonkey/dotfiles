(local lightspeed (require :lightspeed))
(import-macros {: map} :macros)

(lightspeed.setup {:jump_to_unique_chars {:safety_timeout 400}
                   :match_only_the_start_of_same_char_seqs true
                   :limit_ft_matches 5})

;; Prevent lightspeed from creating mappings for `s`
(vim.cmd "map s s")
(vim.cmd "xmap s s")
;; No need to unmap `S` since it already has a custom mapping

;; "Teleport"
(map n :t :<Plug>Lightspeed_s :remap)
(map n :T :<Plug>Lightspeed_S :remap)

(map n :f :<Plug>Lightspeed_f :remap)
(map n :F :<Plug>Lightspeed_F :remap)

;; Go to next result from f/t (use , for going to prev results)
(map n ":" "<Plug>Lightspeed_;_ft" :remap)

