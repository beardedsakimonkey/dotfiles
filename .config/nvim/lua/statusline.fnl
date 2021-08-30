(import-macros {: set!} :macros)

(fn my__lsp_statusline_no_errors []
  (if (vim.tbl_isempty (vim.lsp.buf_get_clients 0)) ""
      (let [errors (or (vim.lsp.diagnostic.get_count :Error) 0)]
        (if (= errors 0) "✔" ""))))

(tset _G :my__lsp_statusline_no_errors my__lsp_statusline_no_errors)

(fn my__lsp_statusline_has_errors []
  (if (vim.tbl_isempty (vim.lsp.buf_get_clients 0)) ""
      (let [errors (or (vim.lsp.diagnostic.get_count :Error) 0)]
        (if (> errors 0) "✘" ""))))

(tset _G :my__lsp_statusline_has_errors my__lsp_statusline_has_errors)

(fn my__statusline []
  (let [rhs (if (= vim.g.statusline_winid (vim.fn.win_getid))
                "%6*%{session#status()}%*" "")
        lsp "%3*%{v:lua.my__lsp_statusline_no_errors()}%4*%{v:lua.my__lsp_statusline_has_errors()}%*"]
    (.. "%1*%{!&modifiable?'  X ':&ro?'  RO ':''}%2*%{&modified?'  + ':''}%*%7*%f%*"
        lsp " %=" rhs " ")))

(tset _G :my__statusline my__statusline)
(set! statusline "%!v:lua.my__statusline()")

;; Tabline

(fn my__tabline []
  (var s "")
  (for [i 1 (vim.fn.tabpagenr "$")]
    (set s (.. s (if (= i (vim.fn.tabpagenr)) "%#TabLineSel#" "%#TabLine#") "%"
               i "T %{v:lua.my__tab_label(" i ")}")))
  (.. s "%#TabLineFill#%T"))

(fn my__tab_label [n]
  (let [buflist (vim.fn.tabpagebuflist n)]
    (var modified "")
    (each [_ b (ipairs buflist) :until (not= modified "")]
      (if (vim.api.nvim_buf_get_option b :modified)
          (set modified "+ ")))
    (let [name (vim.fn.fnamemodify (vim.fn.bufname (. buflist
                                                      (vim.fn.tabpagewinnr n)))
                                   ":t:s/^$/[No Name]/")]
      (.. modified name " "))))

(tset _G :my__tab_label my__tab_label)

(tset _G :my__tabline my__tabline)
(set! tabline "%!v:lua.my__tabline()")

