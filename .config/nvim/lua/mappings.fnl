(import-macros {: no : map} :macros)

(set vim.g.mapleader :<s-f5>)
(set vim.g.maplocalleader ",")

(vim.cmd "cnoreabbrev ~? ~/")
(vim.cmd "cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'Man' : 'man'")

(no n :<Down> :gj)
(no n :<Up> :gk)
(no n :<c-e> :<c-e><c-e>)
(no n :<c-y> :<c-y><c-y>)
(no x "<" :<gv)
(no x ">" :>gv)
;; (no n :s "\"_s")
(no n :Z :zzzH)
(no x :Z :zzzH)
(no n :p "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'" :expr)
(no n :P "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'" :expr)
(no x :p "'\"_c<C-r>'.v:register.'<Esc>'" :expr)

(no x :K :k)
(no x :J :j)

(no n ";" ":")
(no x ";" ":")
(no n ":" ";")
(no x ":" ";")

(no n :Q "@q")
(no "" :Y :y$)
(no "" :H "^")
(no "" :L "$")
(no n :<C-p> :<C-i>)
(no n :<Home> "<CMD>keepj norm! gg<CR>" :silent)
(no n :<End> "<CMD>keepj norm! G<CR>" :silent)
(no n :<PageUp> "<PageUp>:keepj norm! H<CR>" :silent)
(no n :<PageDown> "<PageDown>:keepj norm! L<CR>" :silent)

(no n "`" "g`")
(no n "'" "g'")
(no "" "(" :H :silent)
(no "" ")" :L :silent)
(no n :M "<CMD>keepj norm! M<CR>" :silent)
(no n "{" "<CMD>keepj norm! {<CR>" :silent)
(no n "}" "<CMD>keepj norm! }<CR>" :silent)
(no n :gg "<CMD>keepj norm! gg<CR>" :silent)
(no n :G "<CMD>keepj norm! G<CR>" :silent)
(no n :n "<CMD>keepj norm! nzzzv<CR>" :silent)
(no n :N "<CMD>keepj norm! Nzzzv<CR>" :silent)

(no n "*" "<CMD>keepj norm! *<CR>zzzv" :silent)
(no n "#" "<CMD>keepj norm! #<CR>zzzv" :silent)
(no n :g* "<CMD>keepj norm! g*<CR>zzzv" :silent)
(no n "g#" "<CMD>keepj norm! g#<CR>zzzv" :silent)
;; XXX: doesn't support multiline selection
;; Adapted from lacygoill's vimrc.
(no x "*" "\"vyms:let @/='<c-r>v'<bar>keepj norm! n<CR>zzzv" :silent)
(no x "#" "\"vyms:let @/='<c-r>v'<bar>keepj norm! N<CR>zzzv" :silent)
(no x :g* "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! n<CR>zzzv" :silent)
(no x "g#" "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! N<CR>zzzv" :silent)

(no n :g/
    "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
    :silent)

(no n :<RightMouse>
    "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
    :silent)

;; Adapted from lacygoill's vimrc.
(no n :S
    "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:%s///g<left><left>"
    :silent)

(no n :<Space>s ":<C-u>%s///g<left><left>")

(no n :=v "mvg'[=g']g`v")

(no n :gs :gv)
(no n :gv "g`[vg`]")
(no n :gV "g'[Vg']")

(no ! :<A-h> :<Left>)
(no ! :<A-l> :<Right>)
(no ! :<A-j> :<C-Left>)
(no "!" :<A-k> :<C-Right>)

(no n :<A-l> :<C-w>L)
(no n :<A-h> :<C-w>H)
(no n :<A-j> :<C-w>J)
(no n :<A-k> :<C-w>K)

(no n "]b" :<CMD>bnext<CR> :silent)
(no n "[b" :<CMD>bprev<CR> :silent)
(no n "[t" :<CMD>tabprev<CR> :silent)
(no n "]t" :<CMD>tabnext<CR> :silent)
(no n "]T" :<CMD>+tabmove<CR> :silent)
(no n "[T" :<CMD>-tabmove<CR> :silent)
;; Adapted from lacygoill's vimrc.
(no n "]n" "/\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(no n "[n" "?\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(no x "]n" "/\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(no x "[n" "[n ?\\v^[<\\|=>]{7}<CR>zvzz" :silent)

(no n "]q" "<CMD><C-r>=v:count1<CR>cnext<CR>zz" :silent)
(no n "[q" "<CMD><C-r>=v:count1<CR>cprev<CR>zz" :silent)
(no n "]Q" :<CMD>cnfile<CR>zz :silent)
(no n "[Q" :<CMD>cpfile<CR>zz :silent)
(no n "]l" "<CMD><c-r>=v:count1<CR>lnext<CR>zz" :silent)
(no n "[l" "<CMD><c-r>=v:count1<CR>lprev<CR>zz" :silent)
(no n "]L" :<CMD>lnfile<CR>zz :silent)
(no n "[L" :<CMD>lpfile<CR>zz :silent)

(no "" :<Space>d "<CMD>call Kwbd(1)<CR>" :silent)
(no "" :<Space>q "<CMD>b#<CR>" :silent)

(no n :<Space>ev "<CMD>e ~/.config/nvim/init.lua<CR>" :silent)
(no n :<Space>el "<CMD>e ~/.config/nvim/fnl/<CR>" :silent)
(no n :<Space>ep "<CMD>e ~/.local/share/nvim/site/pack/packer/start/<CR>"
    :silent)

(no n :<Space>ez "<CMD>e ~/.zshrc<CR>" :silent)
(no n :<Space>en "<CMD>e ~/notes/notes.md<CR>" :silent)
(no n :<Space>et "<CMD>e ~/.config/tmux/tmux.conf<CR>" :silent)
(no n :<Space>ea "<CMD>e ~/.config/alacritty/alacritty.yml<CR>" :silent)

(no c :<C-p> :<Up>)
(no c :<C-n> :<Down>)
(no c :<C-j> :<C-g>)
(no c :<C-k> :<C-t>)
(no c :<C-a> :<Home>)

(no i :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(no c :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(no n :yo ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<CR>'<CR>" :silent)
(no n :yO ":<c-u>let @\"='<c-r>=expand(\"%:p\")<CR>'<CR>" :silent)

(no n :<space>t :<CMD>tabedit<CR> :silent)
(no n :cn :cgn :silent)

(no n :<space>l :<CMD>vsplit<CR> :silent)
(no n :<space>j :<CMD>split<CR> :silent)
(no n :<space>h "<CMD>vsplit<Bar>wincmd p<CR>" :silent)
(no n :<space>k "<CMD>split<Bar>wincmd p<CR>" :silent)

(no "" :<C-q> :<CMD>q<CR> :silent)
(no n :<C-s> :<C-a> :silent)
(no n :<CR> :<CMD>w<CR> :silent)
;; (no n "g;" "g;zvzz")

;; Adapted from justinmk's vimrc
(vim.cmd "xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')")
(vim.cmd "xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')")

(no n :con "<CMD>set number!<CR>" :silent)
(no n :coc "<CMD>set cursorline<CR>" :silent)
(no n :cow "<CMD>set wrap!<CR>" :silent)
(no n :cow "<CMD>set wrap!<CR>" :silent)
(no n :col "<CMD>set hlsearch!<CR>" :silent)
(no n :coi "<CMD>set ignorecase!<CR>" :silent)

;; Adapted from justinmk's vimrc
(no n :g.
    ":set nomore<bar>echo repeat(\"\\n\",&cmdheight)<bar>40messages<bar>set more<CR>"
    :silent)

(no x "." ":norm! .<CR>" :silent)

;; Paste from insert mode
(no i :<C-p> :<C-o>p)

(fn move-line [dir]
  (vim.cmd "keepj norm! mv")
  (vim.cmd (.. "move " (if (= dir :up) "--" "+") vim.v.count1))
  (vim.cmd "keepj norm! =`v"))

(fn move-line-up []
  (move-line :up))

(fn move-line-down []
  (move-line :down))

(no n "[e" move-line-up)
(no n "]e" move-line-down)

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

(no n :<space>z zoom-toggle :silent)

;; Search only in visual selection
(fn visual-slash []
  (vim.api.nvim_input "/\\%V"))

(no x "/" visual-slash)

(map o :ac "<Cmd>call my#inner_comment(0)<CR>" :silent)

;; Repeat last edit on last changed text. Adapted from lacygoill's vimrc.
(fn repeat-last-edit-on-last-changed-text []
  (let [changed (vim.fn.getreg "\"" 1 1)]
    (when changed
      (let [;; Escape backslashes
            changed (vim.tbl_map #(vim.fn.escape $1 "\\") changed)
            pat (table.concat changed "\\n")]
        ;; Put the last changed text inside the search register, so that we can refer
        ;; to it with the text-object `gn`
        (vim.fn.setreg "/" (.. "\\V" pat) :c)
        (vim.cmd "exe \"norm! cgn\\<c-@>\"")))))

(no :n :<space>. repeat-last-edit-on-last-changed-text)

;; Adapted form lacygoill's vimrc.
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

(fn navigate-l []
  (navigate :l))

(fn navigate-h []
  (navigate :h))

(fn navigate-j []
  (navigate :j))

(fn navigate-k []
  (navigate :k))

(no n :<C-l> navigate-l :silent)
(no n :<C-h> navigate-h :silent)
(no n :<C-j> navigate-j :silent)
(no n :<C-k> navigate-k :silent)

