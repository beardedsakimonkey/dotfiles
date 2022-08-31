(local nvim-surround (require :nvim-surround))
(local {: get_selection : get_selections} (require :nvim-surround.config))
(import-macros {: map : opt-local} :macros)

(local l {:add (fn []
                 (local clipboard (: (vim.fn.getreg "+") :gsub "\n" ""))
                 [["["] [(.. "](" clipboard ")")]])
          :find "%b[]%b()"
          :delete "^(%[)().-(%]%b())()$"
          :change {:target "^()()%b[]%((.-)()%)$"
                   :replacement (fn []
                                  (local clipboard
                                         (: (vim.fn.getreg "+") :gsub "\n" ""))
                                  [[""] [clipboard]])}})

(local F {:delete #(get_selections {:char :F
                                    :exclude #(get_selection {:query {:capture "@function.inner"
                                                                      :type :textobjects}})})
          :find #(get_selection {:query {:capture "@function.outer"
                                         :type :textobjects}})})

(local o {:delete (fn [c]
                    (get_selections {:char c
                                     :exclude #(get_selection {:query {:capture "@conditional.inner"
                                                                       :type :textobjects}})}))
          :find #(get_selection {:query {:capture "@conditional.outer"
                                         :type :textobjects}})})

;; (local loop {:find (fn []
;;                      (local utils (require :nvim-surround.utils))
;;                      (local s1
;;                             (get_selection {:query {:capture "@loop.outer"
;;                                                     :type :textobjects}}))
;;                      (local s2
;;                             (get_selection {:query {:capture "@conditional.outer"
;;                                                     :type :textobjects}}))
;;                      (local l [])
;;                      (when s1
;;                        (table.insert l s1))
;;                      (when s2
;;                        (table.insert l s2))
;;                      (print l)
;;                      (local best (utils.filter_selections_list l))
;;                      best)})

(nvim-surround.setup {:surrounds {: l : F : o}
                      ;; NOTE: use `false to disable aliases
                      :indent_lines false})

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

