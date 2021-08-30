(import-macros {: au : map} :macros)

(set vim.g.matchup_surround_enabled 1)
(set vim.g.matchup_transmute_enabled 1)
(set vim.g.matchup_matchparen_offscreen {})
(set vim.g.matchup_motion_keepjumps 1)
(set vim.g.matchup_matchpref {:html {:nolists 1}})

;; NOTE: matchparen must be enabled for transmutation to work (useful for html)
(au FileType [vim lua zsh c cpp] "let b:matchup_matchparen_enabled = 0")

(map "" :<tab> "<plug>(matchup-%)")

