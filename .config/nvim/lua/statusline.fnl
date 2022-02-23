(import-macros {: opt} :macros)

(local M {})

;; fnlfmt: skip
(fn M.statusline []
  (let [current-win (= vim.g.statusline_winid (vim.fn.win_getid))]
    (.. "%1*%{!&modifiable ? '  X ' : &ro ? '  RO ' : ''}%2*%{&modified ? '  + ' : ''}%* %7*"
        "%{expand('%:t')}%* "
        "%{&fileformat != 'unix' ? '[' . &fileformat . '] ' : ''}"
        "%{&fileencoding != 'utf-8' && &fileencoding != '' ? '[' . &fileencoding . '] ' : ''}"
        "%="
        (if current-win "%6*%{session#status()}%* " ""))))

(opt statusline "%!v:lua.require'statusline'.statusline()")

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

(opt tabline "%!v:lua.require'statusline'.tabline()")

M

