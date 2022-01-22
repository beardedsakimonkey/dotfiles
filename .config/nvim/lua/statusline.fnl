(import-macros {: set!} :macros)

(local M {})

(local {: ERROR : WARN} vim.diagnostic.severity)

(fn M.lsp_errors []
  (if (vim.tbl_isempty (vim.lsp.buf_get_clients 0)) ""
      (let [count (vim.tbl_count (vim.diagnostic.get 0 {:severity ERROR}))]
        (if (> count 0) (.. " ● " count) ""))))

(fn M.lsp_warns []
  (if (vim.tbl_isempty (vim.lsp.buf_get_clients 0)) ""
      (let [count (vim.tbl_count (vim.diagnostic.get 0 {:severity WARN}))]
        (if (> count 0) (.. " ● " count) ""))))

(fn M.show []
  (let [current-win? (= vim.g.statusline_winid (vim.fn.win_getid))
        rhs (if current-win? "%6*%{session#status()}%*" "")
        lsp "%3*%{v:lua.require'statusline'.lsp_errors()} %4*%{v:lua.require'statusline'.lsp_warns()}%*"]
    (.. "%1*%{!&modifiable?'  X ':&ro?'  RO ':''}%2*%{&modified?'  + ':''}%* %7*"
        "%{expand('%:t')}%* " lsp " %=" rhs " ")))

(set! statusline "%!v:lua.require'statusline'.show()")

;; Tabline ------------------------

(fn M.tabline []
  (var s "")
  (for [i 1 (vim.fn.tabpagenr "$")]
    (set s (.. s (if (= i (vim.fn.tabpagenr)) "%#TabLineSel#" "%#TabLine#") "%"
               i "T %{v:lua.require'statusline'.tablabel(" i ")}")))
  (.. s "%#TabLineFill#%T"))

(fn M.tablabel [n]
  (let [buflist (vim.fn.tabpagebuflist n)]
    (var modified "")
    (each [_ b (ipairs buflist) :until (not= modified "")]
      (if (vim.api.nvim_buf_get_option b :modified)
          (set modified "+ ")))
    (let [name (vim.fn.fnamemodify (vim.fn.bufname (. buflist
                                                      (vim.fn.tabpagewinnr n)))
                                   ":t:s/^$/[No Name]/")]
      (.. modified name " "))))

(set! tabline "%!v:lua.require'statusline'.tabline()")

M

