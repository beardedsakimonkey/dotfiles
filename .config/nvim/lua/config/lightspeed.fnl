(local lightspeed (require :lightspeed))
(import-macros {: map} :macros)

(lightspeed.setup {:jump_to_unique_chars {:safety_timeout 400}
                   :match_only_the_start_of_same_char_seqs true
                   :limit_ft_matches 6})

;; Prevent lightspeed from creating mappings for `s`
(map ["" x] :s :s)
;; No need to unmap `S` since it already has a custom mapping

;; Repeat f/t with f/t
(vim.cmd "
augroup my/lightspeed | autocmd!
  autocmd User LightspeedFtEnter let g:lightspeed_active = 1
  autocmd User LightspeedFtLeave unlet! g:lightspeed_active
augroup END

nmap <expr> f exists('g:lightspeed_active') ? \"<Plug>Lightspeed_;_ft\" : \"<Plug>Lightspeed_f\"
nmap <expr> F exists('g:lightspeed_active') ? \"<Plug>Lightspeed_,_ft\" : \"<Plug>Lightspeed_F\"

nmap <expr> t exists('g:lightspeed_active') ? \"<Plug>Lightspeed_;_ft\" : \"<Plug>Lightspeed_t\"
nmap <expr> T exists('g:lightspeed_active') ? \"<Plug>Lightspeed_,_ft\" : \"<Plug>Lightspeed_T\"
")
