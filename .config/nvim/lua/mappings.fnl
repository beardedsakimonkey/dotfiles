(import-macros {: map : map} :macros)

;; NOTE: Don't use <Cmd> if the mapping contains <C-r>

(set vim.g.mapleader :<s-f5>)
(set vim.g.maplocalleader ",")

(fn prev-change-list []
  (local [row _] (vim.api.nvim_win_get_cursor 0))
  (vim.cmd "normal! g;")
  (local [row2 _] (vim.api.nvim_win_get_cursor 0))
  (local delta (math.abs (- row row2)))
  (when (<= delta 1)
    (vim.cmd "normal! g;")))

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
(fn visual-slash []
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

;; Navigate to the window you came from. Adapted from lacygoill's vimrc.
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

;;
;; Augmented deafults
;;
(map n :<Down> :gj)
(map n :<Up> :gk)
(map n :<c-e> :<c-e><c-e>)
(map n :<c-y> :<c-y><c-y>)
(map "" :<C-g> :g<C-g>)
(map [n x] "<" "<<")
(map [n x] ">" ">>")
(map [n x] :s "\"_s")
(map n :p "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'" :expr)
(map n :P "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'" :expr)
(map x :p "'\"_c<C-r>'.v:register.'<Esc>'" :expr)
(map n "`" "g`")
(map n "'" "g'")
;; Select previously changed/yanked text
(map n :gv "g`[vg`]")
(map n :gV "g'[Vg']")
(map n :<C-l> #(navigate :l) :silent)
(map n :<C-h> #(navigate :h) :silent)
(map n :<C-j> #(navigate :j) :silent)
(map n :<C-k> #(navigate :k) :silent)

;;
;; Rearrange some default mappings
;;
(map [n x] ";" ":")
(map [n x] ":" ";")
(map "" :H "^")
(map "" :L "$")
(map "" "(" :H :silent)
(map "" ")" :L :silent)
;; Increment number
(map n :<C-s> :<C-a> :silent)
(map "" :<tab> "<CMD>keepj norm! %<CR>" :silent)
;; Move <Tab>'s original behavior to <C-p>
(map n :<C-p> :<C-i>)

;;
;; Misc
;;
(map n :cn :cgn :silent)
(map [n x] :Z :zzzH)
;; `qq` to start recording, `Q` to repeat
(map n :Q "@q")
(map n :<CR> :<CMD>w<CR> :silent)
(map "" :<C-q> :<CMD>q<CR> :silent)
(map n :<space>l :<CMD>vsplit<CR> :silent)
(map n :<space>j :<CMD>split<CR> :silent)
(map n :<space>t :<CMD>tabedit<CR> :silent)
(map "" :<Space>d "<CMD>call Kwbd(1)<CR>" :silent)
(map "" :<Space>q "<CMD>b#<CR>" :silent)
(map n :g> :<CMD>40messages<CR> :silent)
;; Reselect previous selection
(map n :gs :gv)
;; Jump to where insert mode was last exited
(map n :gi "g`^")
(map n :<space>z zoom-toggle :silent)
(map x "." ":norm! .<CR>" :silent)
;; Repeat last edit on last changed text.
(map n :g. repeat-last-edit)
;; Adapted from justinmk's vimrc
(vim.cmd "xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')")
(vim.cmd "xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')")
;; Search only in visual selection.
(map x "/" visual-slash)
(map n "g;" prev-change-list)

;;
;; Command mode
;;
(map c :<C-p> :<Up>)
(map c :<C-n> :<Down>)
(map c :<C-j> :<C-g>)
(map c :<C-k> :<C-t>)
(map c :<C-a> :<Home>)

;;
;; Keep jumps
;;
(map n :<Home> "<CMD>keepj norm! gg<CR>" :silent)
(map n :<End> "<CMD>keepj norm! G<CR>" :silent)
(map n :<PageUp> "<PageUp>:keepj norm! H<CR>" :silent)
(map n :<PageDown> "<PageDown>:keepj norm! L<CR>" :silent)
(map n :M "<CMD>keepj norm! M<CR>" :silent)
(map n "{" "<CMD>keepj norm! {<CR>" :silent)
(map n "}" "<CMD>keepj norm! }<CR>" :silent)
(map n :gg "<CMD>keepj norm! gg<CR>" :silent)
(map n :G "<CMD>keepj norm! G<CR>" :silent)
(map n :n "<CMD>keepj norm! nzzzv<CR>" :silent)
(map n :N "<CMD>keepj norm! Nzzzv<CR>" :silent)

;;
;; Search
;;
(map n "*" "<CMD>norm! *<CR>zzzv" :silent)
(map n "#" "<CMD>norm! #<CR>zzzv" :silent)
(map n :g* "<CMD>norm! g*<CR>zzzv" :silent)
(map n "g#" "<CMD>norm! g#<CR>zzzv" :silent)
;; NOTE: Doesn't support multiline selection. Adapted from lacygoill's vimrc.
(map x "*" "\"vy:let @/='<c-r>v'<bar>norm! n<CR>zzzv" :silent)
(map x "#" "\"vy:let @/='<c-r>v'<bar>norm! N<CR>zzzv" :silent)
(map x :g* "\"vy:let @/='\\<<c-r>v\\>'<bar>norm! n<CR>zzzv" :silent)
(map x "g#" "\"vy:let @/='\\<<c-r>v\\>'<bar>norm! N<CR>zzzv" :silent)
(map n :g/ ":<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
     :silent)

(map x :g/ "\"vy:let @/='<c-r>v'<Bar>set hls<CR>" :silent)
(map n :<RightMouse>
     "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
     :silent)

;; Adapted from lacygoill's vimrc.
(map n :S
     "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:%s///g<left><left>"
     :silent)

(map n :<Space>s "ms:<C-u>%s///g<left><left>")

;;
;; Alt key
;;
(map ! :<A-h> :<Left>)
(map ! :<A-l> :<Right>)
(map ! :<A-j> :<C-Left>)
(map "!" :<A-k> :<C-Right>)
(map n :<A-l> :<C-w>L)
(map n :<A-h> :<C-w>H)
(map n :<A-j> :<C-w>J)
(map n :<A-k> :<C-w>K)

;;
;; Unimpaired
;;
(map n "]b" :<CMD>bnext<CR> :silent)
(map n "[b" :<CMD>bprev<CR> :silent)
(map n "[t" :<CMD>tabprev<CR> :silent)
(map n "]t" :<CMD>tabnext<CR> :silent)
(map n "]T" :<CMD>+tabmove<CR> :silent)
(map n "[T" :<CMD>-tabmove<CR> :silent)
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
(map n "[e" #(move-line :up))
(map n "]e" #(move-line :down))

;;
;; Bookmarks
;;
(map n "'V" "<CMD>e ~/.config/nvim/lua<CR>" :silent)
(map n "'P" "<CMD>e ~/.local/share/nvim/site/pack/packer/start/<CR>" :silent)
(map n "'Z" "<CMD>e ~/.zshrc<CR>" :silent)
(map n "'N" "<CMD>e ~/notes/notes.md<CR>" :silent)
(map n "'T" "<CMD>e ~/notes/todo.md<CR>" :silent)
(map n "'A" "<CMD>e ~/.config/alacritty/alacritty.yml<CR>" :silent)
(map n "'U"
     "<CMD>e ~/Library/Application\\ Support/Firefox/Profiles/2a6723nr.default-release/user.js<CR>"
     :silent)

;;
;; Grab file name
;;
(map i :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(map c :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(map n :yo ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<CR>'<CR>" :silent)
(map n :yO ":<c-u>let @\"='<c-r>=expand(\"%:p\")<CR>'<CR>" :silent)

;;
;; Toggle options
;;
(map n :con "<CMD>set number!<CR>" :silent)
(map n :coc "<CMD>set cursorline!<CR>" :silent)
(map n :cow "<CMD>set wrap!<CR>" :silent)
(map n :col "<CMD>set hlsearch!<CR>" :silent)
(map n :coi "<CMD>set ignorecase!<CR>" :silent)

;;
;; Avoid typo
;;
(map x :K :k)
(map x :J :j)
(vim.cmd "cnoreabbrev ~? ~/")

;;
;; Abbreviations
;;
(vim.cmd "cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'vert Man' : 'man'")

