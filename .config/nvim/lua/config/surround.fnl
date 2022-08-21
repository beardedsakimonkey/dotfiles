(local nvim-surround (require :nvim-surround))
(import-macros {: map : opt-local} :macros)

(local cfg
       {:surrounds {:l {:add (fn []
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
                                                [[""] [clipboard]])}}}})

(nvim-surround.setup cfg)

;; (fn _select-quote [char]
;;   (local {: get_nearest_selections} (require :nvim-surround.utils))
;;   (local selections (get_nearest_selections char))
;;   (when selections
;;     (local left selections.left.last_pos)
;;     (local right selections.right.last_pos)
;;     (vim.api.nvim_win_set_cursor 0 left)
;;     (vim.cmd "normal! v")
;;     (vim.api.nvim_win_set_cursor 0 [(. right 1) (- (. right 2) 2)])))

;; (fn handler [_motion _mode _char]
;;   (vim.api.nvim_win_set_cursor 0 0)
;;   (vim.cmd "norm! j"))

;; (fn ai [_motion _mode]
;;   (local _txtobj (vim.fn.nr2char (vim.fn.getchar)))
;;   "<Cmd>lua require('config.surround').handler()<CR>")

;; (map o :i #(ai :i :o) :expr)
;; (map o :a #(ai :a :o) :expr)

;; {: handler}

