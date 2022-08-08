(local nvim-surround (require :nvim-surround))
(import-macros {: map : opt-local} :macros)

(local cfg {:keymaps {:insert :<C-g>s
                      :insert_line :<C-g>S
                      :normal :ys
                      :normal_cur :yss
                      :normal_line :yS
                      :normal_cur_line :ySS
                      :visual :S
                      :visual_line :gS
                      :delete :ds
                      :change :cs}
            :surrounds {:l {:add (fn []
                                   (local clipboard
                                          (: (vim.fn.getreg "+") :gsub "\n" ""))
                                   [["["] [(.. "](" clipboard ")")]])
                            :find "%b[]%b()"
                            :delete "^(%[)().-(%]%b())()$"
                            :change {:target "^()()%b[]%((.-)()%)$"
                                     :replacement (fn []
                                                    (local clipboard
                                                           (: (vim.fn.getreg "+")
                                                              :gsub "\n" ""))
                                                    [[""] [clipboard]])}}}
            :aliases {:a ">"
                      :b ")"
                      :B "}"
                      :r "]"
                      "'" ["\"" "'" "`"]
                      :s ["}" "]" ")" ">" "\"" "'" "`"]}
            :highlight {:duration 0}
            :move_cursor :begin})

(nvim-surround.setup cfg)

;; (fn select-quote [char]
;;   (local {: get_nearest_selections} (require :nvim-surround.utils))
;;   (local selections (get_nearest_selections char))
;;   (when selections
;;     (local left selections.left.last_pos)
;;     (local right selections.right.last_pos)
;;     (vim.api.nvim_win_set_cursor 0 left)
;;     (vim.cmd "normal! v")
;;     (vim.api.nvim_win_set_cursor 0 [(. right 1) (- (. right 2) 2)])))

;; (fn _i []
;;   (local char (vim.fn.nr2char (vim.fn.getchar)))
;;   (when (or (. cfg.delimiters.pairs char) (. cfg.delimiters.separators char)
;;             (. cfg.delimiters.aliases char))
;;     (select-quote char)))

;; TODO: visual mode, repeat
;; (map o :i i)

