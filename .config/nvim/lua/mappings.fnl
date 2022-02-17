(import-macros {: no : map} :macros)

;; NOTE: Don't use <Cmd> if the mapping contains <C-r>

(set vim.g.mapleader :<s-f5>)
(set vim.g.maplocalleader ",")

(fn move-line [dir]
  (vim.cmd "keepj norm! mv")
  (vim.cmd (.. "move " (if (= dir :up) "--" "+") vim.v.count1))
  (vim.cmd "keepj norm! =`v"))

(fn move-line-up []
  (move-line :up))

(fn move-line-down []
  (move-line :down))

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

;; Adapted form lacygoill's vimrc.
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

;; Adapted from gpanders' config
(fn jump [forward?]
  (let [bufnr (vim.api.nvim_get_current_buf)
        [jumplist index] (vim.fn.getjumplist)
        (start stop step) (if forward?
                              (values (+ index 2) (length jumplist) 1)
                              (values index 1 -1))]
    (var target nil)
    (var count vim.v.count1)
    (for [i start stop step :until (= count 0)]
      (match (. jumplist i)
        {: bufnr} (do
                    (set count (- count 1))
                    (set target i))))
    (when target
      (let [cmd (.. "normal! "
                    (if forward?
                        (.. (+ 1 (- target start))
                            (vim.api.nvim_replace_termcodes :<C-I> true true
                                                            true))
                        (.. (+ 1 (- start target))
                            (vim.api.nvim_replace_termcodes :<C-O> true true
                                                            true))))]
        (vim.cmd cmd)))))

(fn jump-backward []
  (jump false))

(fn jump-forward []
  (jump true))

;;
;; Augmented deafults
;;
(no n :<Down> :gj)
(no n :<Up> :gk)
(no n :<c-e> :<c-e><c-e>)
(no n :<c-y> :<c-y><c-y>)
(no x "<" :<gv)
(no x ">" :>gv)
(no n :s "\"_s")
(no x :s "\"_s")
(no n :Z :zzzH)
(no x :Z :zzzH)
(no n :p "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'" :expr)
(no n :P "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'" :expr)
(no x :p "'\"_c<C-r>'.v:register.'<Esc>'" :expr)
(no n "`" "g`")
(no n "'" "g'")
(no "" :<C-g> :g<C-g>)
;; Navigate to the window you came from.
(no n :<C-l> navigate-l :silent)
(no n :<C-h> navigate-h :silent)
(no n :<C-j> navigate-j :silent)
(no n :<C-k> navigate-k :silent)

;;
;; Remapped builtins
;;
(no n ";" ":")
(no x ";" ":")
(no n ":" ";")
(no x ":" ";")
;; `qq` to start recording, `Q` to repeat
(no n :Q "@q")
(no "" :H "^")
(no "" :L "$")
(no "" "(" :H :silent)
(no "" ")" :L :silent)
;; Increment number
(no n :<C-s> :<C-a> :silent)
(map "" :<tab> "<CMD>keepj norm! %<CR>" :silent)
;; Move <Tab>'s original behavior to <C-p>
(no n :<C-p> :<C-i>)
(no n :cn :cgn :silent)

;;
;; Misc
;;
(no n :<CR> :<CMD>w<CR> :silent)
(no "" :<C-q> :<CMD>q<CR> :silent)
(no n :<space>l :<CMD>vsplit<CR> :silent)
(no n :<space>j :<CMD>split<CR> :silent)
(no n :<space>t :<CMD>tabedit<CR> :silent)
(no "" :<Space>d "<CMD>call Kwbd(1)<CR>" :silent)
(no "" :<Space>q "<CMD>b#<CR>" :silent)
(no n :g> :<CMD>40messages<CR> :silent)
;; Select previously changed/yanked text
(no n :gv "g`[vg`]")
(no n :gV "g'[Vg']")
;; Format previously changed/yanked text
(no n :=v "mvg'[=g']g`v")
;; Reselect previous selection
(no n :gs :gv)
;; Jump to where last change was made
(no n :gl "g`.")
;; Jump to where insert mode was last exited
(no n :gi "g`^")
(no n :<space>z zoom-toggle :silent)
(no x "." ":norm! .<CR>" :silent)
;; Repeat last edit on last changed text.
(no :n :g. repeat-last-edit)
;; Adapted from justinmk's vimrc
(vim.cmd "xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')")
(vim.cmd "xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')")
;; Search only in visual selection.
(no x "/" visual-slash)

;;
;; Command mode
;;
(no c :<C-p> :<Up>)
(no c :<C-n> :<Down>)
(no c :<C-j> :<C-g>)
(no c :<C-k> :<C-t>)
(no c :<C-a> :<Home>)

;;
;; Keep jumps
;;
(no n :<Home> "<CMD>keepj norm! gg<CR>" :silent)
(no n :<End> "<CMD>keepj norm! G<CR>" :silent)
(no n :<PageUp> "<PageUp>:keepj norm! H<CR>" :silent)
(no n :<PageDown> "<PageDown>:keepj norm! L<CR>" :silent)
(no n :M "<CMD>keepj norm! M<CR>" :silent)
(no n "{" "<CMD>keepj norm! {<CR>" :silent)
(no n "}" "<CMD>keepj norm! }<CR>" :silent)
(no n :gg "<CMD>keepj norm! gg<CR>" :silent)
(no n :G "<CMD>keepj norm! G<CR>" :silent)
(no n :n "<CMD>keepj norm! nzzzv<CR>" :silent)
(no n :N "<CMD>keepj norm! Nzzzv<CR>" :silent)

;;
;; Search
;;
(no n "*" "<CMD>norm! *<CR>zzzv" :silent)
(no n "#" "<CMD>norm! #<CR>zzzv" :silent)
(no n :g* "<CMD>norm! g*<CR>zzzv" :silent)
(no n "g#" "<CMD>norm! g#<CR>zzzv" :silent)
;; NOTE: Doesn't support multiline selection. Adapted from lacygoill's vimrc.
(no x "*" "\"vy:let @/='<c-r>v'<bar>norm! n<CR>zzzv" :silent)
(no x "#" "\"vy:let @/='<c-r>v'<bar>norm! N<CR>zzzv" :silent)
(no x :g* "\"vy:let @/='\\<<c-r>v\\>'<bar>norm! n<CR>zzzv" :silent)
(no x "g#" "\"vy:let @/='\\<<c-r>v\\>'<bar>norm! N<CR>zzzv" :silent)
(no n :g/ ":<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
    :silent)

(no x :g/ "\"vy:let @/='<c-r>v'<Bar>set hls<CR>" :silent)
(no n :<RightMouse>
    "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>"
    :silent)

;; Adapted from lacygoill's vimrc.
(no n :S
    "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:%s///g<left><left>"
    :silent)

(no n :<Space>s "ms:<C-u>%s///g<left><left>")

;;
;; Alt key
;;
(no ! :<A-h> :<Left>)
(no ! :<A-l> :<Right>)
(no ! :<A-j> :<C-Left>)
(no "!" :<A-k> :<C-Right>)
(no n :<A-l> :<C-w>L)
(no n :<A-h> :<C-w>H)
(no n :<A-j> :<C-w>J)
(no n :<A-k> :<C-w>K)

;;
;; Unimpaired
;;
(no n "]b" :<CMD>bnext<CR> :silent)
(no n "[b" :<CMD>bprev<CR> :silent)
(no n "[t" :<CMD>tabprev<CR> :silent)
(no n "]t" :<CMD>tabnext<CR> :silent)
(no n "]T" :<CMD>+tabmove<CR> :silent)
(no n "[T" :<CMD>-tabmove<CR> :silent)
(no n "]q" ":<C-u><C-r>=v:count1<CR>cnext<CR>zz" :silent)
(no n "[q" ":<C-u><C-r>=v:count1<CR>cprev<CR>zz" :silent)
(no n "]Q" :<Cmd>cnfile<CR>zz :silent)
(no n "[Q" :<Cmd>cpfile<CR>zz :silent)
(no n "]l" ":<C-u><c-r>=v:count1<CR>lnext<CR>zz" :silent)
(no n "[l" ":<C-u><c-r>=v:count1<CR>lprev<CR>zz" :silent)
(no n "]L" :<Cmd>lnfile<CR>zz :silent)
(no n "[L" :<Cmd>lpfile<CR>zz :silent)
;; Adapted from lacygoill's vimrc.
(no "" "]n" "/\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(no "" "[n" "?\\v^[<\\|=>]{7}<CR>zvzz" :silent)
(no n "[e" move-line-up)
(no n "]e" move-line-down)
;; Jump to previous buffer in jumplist.
(no n "[j" jump-backward)
(no n "]j" jump-forward)

;;
;; Bookmarks
;;
(no n "'V" "<CMD>e ~/.config/nvim/lua<CR>" :silent)
(no n "'P" "<CMD>e ~/.local/share/nvim/site/pack/packer/start/<CR>" :silent)
(no n "'Z" "<CMD>e ~/.zshrc<CR>" :silent)
(no n "'N" "<CMD>e ~/notes/notes.md<CR>" :silent)
(no n "'T" "<CMD>e ~/notes/todo.md<CR>" :silent)
(no n "'A" "<CMD>e ~/.config/alacritty/alacritty.yml<CR>" :silent)

;;
;; Grab file name
;;
(no i :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(no c :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<CR>")
(no n :yo ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<CR>'<CR>" :silent)
(no n :yO ":<c-u>let @\"='<c-r>=expand(\"%:p\")<CR>'<CR>" :silent)

;;
;; Toggle options
;;
(no n :con "<CMD>set number!<CR>" :silent)
(no n :coc "<CMD>set cursorline!<CR>" :silent)
(no n :cow "<CMD>set wrap!<CR>" :silent)
(no n :col "<CMD>set hlsearch!<CR>" :silent)
(no n :coi "<CMD>set ignorecase!<CR>" :silent)

;;
;; Avoid typo
;;
(no x :K :k)
(no x :J :j)
(vim.cmd "cnoreabbrev ~? ~/")

;;
;; Abbreviations
;;
(vim.cmd "cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'vert Man' : 'man'")

