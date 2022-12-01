(import-macros {: map} :macros)

(set vim.g.mapleader :<s-f5>)
(set vim.g.maplocalleader ",")

(fn nav-change-list [cmd]
  (local [line] (vim.api.nvim_win_get_cursor 0))
  (vim.cmd (.. "sil! normal! " cmd))
  (local [line2] (vim.api.nvim_win_get_cursor 0))
  (when (= line line2)
    (vim.cmd (.. "sil! normal! " cmd))))

(fn move-line [dir]
  (vim.cmd "keepj norm! mv")
  (vim.cmd (.. "move " (if (= dir :up) "--" "+") vim.v.count1))
  (vim.cmd "keepj norm! =`v"))

;; Adapted from lacygoill's vimrc
(fn zoom-toggle []
  (when (not= (vim.fn.winnr "$") 1)
    (if vim.t.zoom_restore
        (do
          (vim.cmd "exe t:zoom_restore")
          (vim.cmd "unlet t:zoom_restore"))
        (do
          (set vim.t.zoom_restore (vim.fn.winrestcmd))
          (vim.cmd "wincmd |")
          (vim.cmd "wincmd _")))))

;; Adapted from lacygoill's vimrc.
(fn search-in-visual-selection []
  (vim.api.nvim_input "/\\%V"))

;; Adapted from lacygoill's vimrc.
(fn repeat-last-edit []
  (let [changed (vim.fn.getreg "\"" 1 1)]
    (when changed
      (let [;; Escape backslashes
            changed (vim.tbl_map #(vim.fn.escape $1 "\\") changed)
            pat (table.concat changed "\\n")]
        ;; Put the last changed text inside the search register, so that we can refer
        ;; to it with the text-object `gn`
        (vim.fn.setreg "/" (.. "\\V" pat) :c)
        (vim.cmd "exe \"norm! cgn\\<c-@>\"")))))

;; Adapted from lacygoill's vimrc.
(fn previous-window-in-same-direction [dir]
  (let [cnr (vim.fn.winnr)
        pnr (vim.fn.winnr "#")]
    (match dir
      :h (let [leftedge-current-window (. (vim.fn.win_screenpos cnr) 2)
               rightedge-previous-window (- (+ (. (vim.fn.win_screenpos pnr) 2)
                                               (vim.fn.winwidth pnr))
                                            1)]
           (= (- leftedge-current-window 1) (+ rightedge-previous-window 1)))
      :l (let [leftedge-previous-window (. (vim.fn.win_screenpos pnr) 2)
               rightedge-current-window (- (+ (. (vim.fn.win_screenpos cnr) 2)
                                              (vim.fn.winwidth cnr))
                                           1)]
           (= (- leftedge-previous-window 1) (+ rightedge-current-window 1)))
      :j (let [topedge-previous-window (. (vim.fn.win_screenpos pnr) 1)
               bottomedge-current-window (- (+ (. (vim.fn.win_screenpos cnr) 1)
                                               (vim.fn.winheight cnr))
                                            1)]
           (= (- topedge-previous-window 1) (+ bottomedge-current-window 1)))
      :k (let [topedge-current-window (. (vim.fn.win_screenpos cnr) 1)
               bottomedge-previous-window (- (+ (. (vim.fn.win_screenpos pnr) 1)
                                                (vim.fn.winheight pnr))
                                             1)]
           (= (- topedge-current-window 1) (+ bottomedge-previous-window 1))))))

(fn navigate [dir]
  (if (previous-window-in-same-direction dir)
      (vim.cmd "try | wincmd p | catch | entry")
      (vim.cmd (.. "try | wincmd " dir " | catch | endtry"))))

;; Adapted from nvim-treesitter-refactor
(fn ts-substitute []
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local locals (require :nvim-treesitter.locals))
  (local bufnr (vim.api.nvim_get_current_buf))
  (local cursor-node (ts-utils.get_node_at_cursor 0 false))

  (fn complete-rename [new-name]
    (when (and new-name (> (length new-name) 0))
      (local (definition scope) (locals.find_definition cursor-node bufnr))
      (local nodes-to-rename {})
      (tset nodes-to-rename (cursor-node:id) cursor-node)
      (tset nodes-to-rename (definition:id) definition)
      (each [_ n (ipairs (locals.find_usages definition scope bufnr))]
        (tset nodes-to-rename (n:id) n))
      (local edits {})
      (each [_ node (pairs nodes-to-rename)]
        (local lsp-range (ts-utils.node_to_lsp_range node))
        (local text-edit {:range lsp-range :newText new-name})
        (table.insert edits text-edit))
      (vim.lsp.util.apply_text_edits edits bufnr :utf-8)))

  (if (not cursor-node)
      (vim.api.nvim_err_writeln "No node to rename!")
      ;; NOTE: can eventually use `:h command-preview` on neovim 0.8+
      (vim.ui.input {:default "" :prompt "New name: "} complete-rename)))

(fn plain-substitute []
  (local cword (vim.fn.expand :<cword>))
  (vim.fn.setreg "/" (.. "\\<" cword "\\>") :c)
  (local keys (vim.api.nvim_replace_termcodes ":%s///g<left><left>" true false
                                              true))
  (vim.api.nvim_feedkeys keys :n false))

(fn substitute []
  (local parsers (require :nvim-treesitter.parsers))
  (local ts-enabled (parsers.has_parser nil))
  (if ts-enabled
      (ts-substitute)
      (plain-substitute)))

(fn yank-doc [exp]
  (local txt (vim.fn.expand exp))
  (vim.fn.setreg "\"" txt :c)
  (vim.fn.setreg "+" txt :c))

;; Enhanced deafults
;; -----------------
(map n :j :gj)
(map n :k :gk)
(map n :<Down> :gj)
(map n :<Up> :gk)
(map n :<c-e> :<c-e><c-e>)
(map n :<c-y> :<c-y><c-y>)
(map "" :<C-g> :g<C-g>)
(map n "<" "<<")
(map n ">" ">>")
(map x "<" :<gv)
(map x ">" :>gv)
(map [n x] :s "\"_s")
(map n :p "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'" :expr)
(map n :P "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'" :expr)
(map x :p "'\"_c<C-r>'.v:register.'<Esc>'" :expr)
(map n "`" "g`")
(map n "'" "g'")
(map n :n "<Cmd>keepj norm! nzzzv<CR>" :silent)
(map n :N "<Cmd>keepj norm! Nzzzv<CR>" :silent)
(map n "*" :*zzzv :silent)
(map n "#" "#zzzv" :silent)
(map n :g* :g*zzzv :silent)
(map n "g#" "g#zzzv" :silent)
(map n "g;" #(nav-change-list "g;"))
(map n "g'" #(nav-change-list "g,"))
(map n :<PageUp> "<PageUp>:keepj norm! H<CR>" :silent)
(map n :<PageDown> "<PageDown>:keepj norm! L<CR>" :silent)
(map n "/" "/\\V")

;; Rearrange some default mappings
;; -------------------------------
(map [n x] ";" ":")
(map [n x] ":" ";")
(map n "`" "'")
(map n "'" "`")
(map "" :H "^")
(map "" :L "$")
(map "" "(" :H :silent)
(map "" ")" :L :silent)
(map n :<Home> "<Cmd>keepj norm! gg<CR>" :silent)
(map n :<End> "<Cmd>keepj norm! G<CR>" :silent)
(map n :<C-s> :<C-a> :silent)
(map "" :<tab> "<Cmd>keepj norm! %<CR>" :silent)
(map n :<C-p> :<Tab>)
(map n :<C-l> #(navigate :l) :silent)
(map n :<C-h> #(navigate :h) :silent)
(map n :<C-j> #(navigate :j) :silent)
(map n :<C-k> #(navigate :k) :silent)

;; Miscellaneous
;; -------------
(map n :cn :cgn :silent)
(map [n x] :Z :zzzH)
(map n :Q "@q")
(map n :<A-LeftMouse> :<nop>)
(map n :<CR> :<Cmd>w<CR> :silent)
(map "" :<C-q> :<Cmd>q<CR> :silent)
(map n :<space>l :<Cmd>vsplit<CR> :silent)
(map n :<space>j :<Cmd>split<CR> :silent)
(map n :<space>t :<Cmd>tabedit<CR> :silent)
(map "" :<Space>d "<Cmd>call Kwbd(1)<CR>" :silent)
(map "" :<Space>q "<Cmd>b#<CR>" :silent)
(map n :g> :<Cmd>40messages<CR> :silent)
;; Go to last insert
(map n :gi "g`^")
;; Go to last change
(map n :g. "g`.")
;; Select last changed/yanked text
(map n :gs "g`[vg`]")
(map n :gS "g'[Vg']")
(map n :<space>z zoom-toggle :silent)
(map x "." ":norm! .<CR>" :silent)
(map n :<space>. repeat-last-edit)
(map x "/" search-in-visual-selection)
(map x :<space>y "\"*y")
;; Adapted from justinmk's vimrc
(map x :I "mode() =~# '[vV]' ? '<C-v>^o^I' : 'I'" :expr)
(map x :A "mode() =~# '[vV]' ? '<C-v>0o$A' : 'A'" :expr)

;; Command mode
;; ------------
(map c :<C-p> :<Up>)
(map c :<C-n> :<Down>)
(map c :<C-j> :<C-g>)
(map c :<C-k> :<C-t>)
(map c :<C-a> :<Home>)

;; Keep jumps
;; ----------
(map n :M "<Cmd>keepj norm! M<CR>" :silent)
(map n "{" "<Cmd>keepj norm! {<CR>" :silent)
(map n "}" "<Cmd>keepj norm! }<CR>" :silent)
(map n :gg "<Cmd>keepj norm! gg<CR>" :silent)
(map n :G "<Cmd>keepj norm! G<CR>" :silent)

;; Search & substitute
;; -------------------
;; NOTE: Doesn't support multiline selection. Adapted from lacygoill's vimrc.
(map x "*" "\"vy:let @/='\\<<c-r>v\\>'<CR>nzzzv" :silent)
(map x "#" "\"vy:let @/='\\<<c-r>v\\>'<CR>Nzzzv" :silent)
(map x :g* "\"vy:let @/='<c-r>v'<CR>nzzzv" :silent)
(map x "g#" "\"vy:let @/='<c-r>v'<CR>Nzzzv" :silent)
(map n :g/ ":<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
     :silent)

(map x :g/ "\"vy:let @/='<c-r>v'<Bar>set hls<CR>")
(map [n x] :<RightMouse>
     "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
     :silent)

(map n :<Space>s "ms:<C-u>%s///g<left><left>")
(map x :<space>s "\"vy:let @/='<c-r>v'<CR>:<C-u>%s///g<left><left>")
(map n :R substitute)
(map n :gr :R)

;; Alt key
;; -------
(map ! :<A-h> :<Left>)
(map ! :<A-l> :<Right>)
(map ! :<A-j> :<C-Left>)
(map ! :<A-k> :<C-Right>)
(map n :<A-l> :<C-w>L)
(map n :<A-h> :<C-w>H)
(map n :<A-j> :<C-w>J)
(map n :<A-k> :<C-w>K)

;; Bracket
;; -------
(map n "]b" :<Cmd>bnext<CR> :silent)
(map n "[b" :<Cmd>bprev<CR> :silent)
(map n "[t" :<Cmd>tabprev<CR> :silent)
(map n "]t" :<Cmd>tabnext<CR> :silent)
(map n "]T" :<Cmd>+tabmove<CR> :silent)
(map n "[T" :<Cmd>-tabmove<CR> :silent)
;; NOTE: Don't use <Cmd> if the mapping contains <C-r>
(map n "]q" ":<C-u><C-r>=v:count1<CR>cnext<CR>zz" :silent)
(map n "[q" ":<C-u><C-r>=v:count1<CR>cprev<CR>zz" :silent)
(map n "]Q" :<Cmd>cnfile<CR>zz :silent)
(map n "[Q" :<Cmd>cpfile<CR>zz :silent)
(map n "]l" ":<C-u><c-r>=v:count1<CR>lnext<CR>zz" :silent)
(map n "[l" ":<C-u><c-r>=v:count1<CR>lprev<CR>zz" :silent)
(map n "]L" :<Cmd>lnfile<CR>zz :silent)
(map n "[L" :<Cmd>lpfile<CR>zz :silent)
;; Adapted from lacygoill's vimrc.
(map "" "]n" "/\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(map "" "[n" "?\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(map n "[d" #(move-line :up))
(map n "]d" #(move-line :down))

;; Bookmarks
;; ---------
(map n ":V" "<Cmd>e ~/.config/nvim/<CR>" :silent)
(map n ":L" "<Cmd>e ~/.config/nvim/lua/<CR>" :silent)
(map n ":C" "<Cmd>e ~/.config/nvim/lua/config/<CR>" :silent)
(map n ":A" "<Cmd>e ~/.config/nvim/after/ftplugin/<CR>" :silent)
(map n ":P" "<Cmd>e ~/.local/share/nvim/site/pack/packer/start/<CR>" :silent)
(map n ":R" "<Cmd>e $VIMRUNTIME<CR>" :silent)
(map n ":Z" "<Cmd>e ~/.zshrc<CR>" :silent)
(map n ":N" "<Cmd>e ~/notes/_notes.md<CR>" :silent)
(map n ":T" "<Cmd>e ~/notes/_todo.md<CR>" :silent)
(map n ":X" "<Cmd>e ~/.config/tmux/tmux.conf<CR>" :silent)
(map n ":U"
     "<Cmd>e ~/Library/Application\\ Support/Firefox/Profiles/2a6723nr.default-release/user.js<CR>"
     :silent)

;; Text objects
;; ------------
(map [x o] :il "<Cmd>norm! g_v^<CR>" :silent)
(map [x o] :al "<Cmd>norm! $v0<CR>" :silent)
(map x :id "<Cmd>norm! G$Vgg0<CR>" :silent)
(map o :id "<Cmd>norm! GVgg<CR>" :silent)

;; Document/file name
;; ------------------
(map i :<C-d> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(map c :<C-d> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(map n :yd #(yank-doc "%:t:r:r:r") :silent)
(map n :yD #(yank-doc "%:p") :silent)

;; Toggle options
;; --------------
(map n :gon "<Cmd>set number!<CR>" :silent)
(map n :goc "<Cmd>set cursorline!<CR>" :silent)
(map n :gow "<Cmd>set wrap!<Bar>set wrap?<CR>" :silent)
(map n :gol "<Cmd>set hlsearch!<Bar>set hlsearch?<CR>" :silent)
(map n :goi "<Cmd>set ignorecase!<Bar>set ignorecase?<CR>" :silent)
(map n :gof
     "<Cmd>let g:format_disabled = !get(g:, 'format_disabled', 0)<Bar>let g:format_disabled<CR>"
     :silent)

;; Diagnostics
;; -----------
(map n :ge "<Cmd>lua vim.diagnostic.open_float()<CR>" :silent)
(map n "[e" "<Cmd>lua vim.diagnostic.goto_prev()<CR>" :silent)
(map n "]e" "<Cmd>lua vim.diagnostic.goto_next()<CR>" :silent)
(map n :gl "<Cmd>lua vim.diagnostic.setloclist()<CR>" :silent)

;; Avoid typo
;; ----------
(map x :K :k)
(map x :J :j)
(vim.cmd "cnoreabbrev ~? ~/")
(vim.cmd "cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'vert Man' : 'man'")
