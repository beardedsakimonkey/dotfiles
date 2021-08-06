(module mappings)

(fn no [mode lhs rhs opt]
  (let [opts (vim.tbl_extend :force {:noremap true} (or opt {}))]
    (vim.api.nvim_set_keymap mode lhs rhs opts)))

(set vim.g.mapleader :<s-f5>)
(set vim.g.maplocalleader ",")

(no :n :<Down> :gj)
(no :n :<Up> :gk)
(no :n :<c-e> :<c-e><c-e>)
(no :n :<c-y> :<c-y><c-y>)
(no :x "<" :<gv)
(no :x ">" :>gv)
(no :n :s "\"_s")
(no :n :Z :zzzH)
(no :x :Z :zzzH)
(no :n :p "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'" {:expr true})
(no :n :P "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'" {:expr true})
(no :x :p "'\"_c<C-r>'.v:register.'<Esc>'" {:expr true})

(no :x :K :k)
(no :x :J :j)

(no :n ";" ":")
(no :x ";" ":")
(no :n ":" ";")
(no :x ":" ";")

(no :n :Q "@q")
(no "" :Y :y$)
(no "" :H "^")
(no "" :L "$")
(no :n :<C-p> :<C-i>)
(no :n :<Home> "<Cmd>keepj norm! gg<CR>" {:silent true})
(no :n :<End> "<Cmd>keepj norm! G<CR>" {:silent true})
(no :n :<PageUp> "<PageUp>:keepj norm! H<CR>" {:silent true})
(no :n :<PageDown> "<PageDown>:keepj norm! L<CR>" {:silent true})
(no :n :<CR> :<Cmd>w<CR> {:silent true})

(no :n "`" "g`")
(no :n "'" "g'")
(no "" "(" :H {:silent true})
(no "" ")" :L {:silent true})
(no :n :M "<Cmd>keepj norm! M<CR>" {:silent true})
(no :n "{" "<Cmd>keepj norm! {<CR>" {:silent true})
(no :n "}" "<Cmd>keepj norm! }<CR>" {:silent true})
(no :n :gg "<Cmd>keepj norm! gg<CR>" {:silent true})
(no :n :G "<Cmd>keepj norm! G<CR>" {:silent true})
(no :n :n "<Cmd>keepj norm! nzzzv<CR>" {:silent true})
(no :n :N "<Cmd>keepj norm! Nzzzv<CR>" {:silent true})

(no :n "*" "<Cmd>keepj norm! *<CR>zzzv" {:silent true})
(no :n "#" "<Cmd>keepj norm! #<CR>zzzv" {:silent true})
(no :n :g* "<Cmd>keepj norm! g*<CR>zzzv" {:silent true})
(no :n "g#" "<Cmd>keepj norm! g#<CR>zzzv" {:silent true})
; XXX: doesn't support multiline selection
(no :x "*" "\"vyms:let @/='<c-r>v'<bar>keepj norm! n<CR>zzzv" {:silent true})
(no :x "#" "\"vyms:let @/='<c-r>v'<bar>keepj norm! N<CR>zzzv" {:silent true})
(no :x :g* "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! n<CR>zzzv"
    {:silent true})
(no :x "g#" "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! N<cr>zzzv"
    {:silent true})
(no :n :g/
    "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<cr>\\>'<cr>:set hls<cr>"
    {:silent true})
(no :n :<RightMouse>
    "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<cr>\\>'<cr>:set hls<cr>"
    {:silent true})

; TODO: combine these
(no :n :S
    "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<cr>:%s///g<left><left>"
    {:silent true})
(no :n :<Space>s "<Cmd>%s///g<left><left>")

(no :n :=v "mvg'[=g']g`v")

(no :n :gs :gv)
(no :n :gv "g`[vg`]")
(no :n :gV "g'[Vg']")

(no "!" :<A-h> :<Left>)
(no "!" :<A-l> :<Right>)
(no "!" :<A-j> :<C-Left>)
(no "!" :<A-k> :<C-Right>)

; (no :n :<C-l> ":<c-u>call <sid>navigate('l')<cr>" {:silent true})
; (no :n :<C-h> ":<c-u>call <sid>navigate('h')<cr>" {:silent true})
; (no :n :<C-j> ":<c-u>call <sid>navigate('j')<cr>" {:silent true})
; (no :n :<C-k> ":<c-u>call <sid>navigate('k')<cr>" {:silent true})

(no :n :<A-l> :<C-w>L)
(no :n :<A-h> :<C-w>H)
(no :n :<A-j> :<C-w>J)
(no :n :<A-k> :<C-w>K)

(no :n "]b" :<Cmd>bnext<CR> {:silent true})
(no :n "[b" :<Cmd>bprev<CR> {:silent true})
(no :n "[t" :<Cmd>tabprev<CR> {:silent true})
(no :n "]t" :<Cmd>tabnext<CR> {:silent true})
(no :n "]T" :<Cmd>+tabmove<CR> {:silent true})
(no :n "[T" :<Cmd>-tabmove<CR> {:silent true})
(no :n "]n" "/\\v^[<\\|=>]{7}<cr>zvzz" {:silent true})
(no :n "[n" "?\\v^[<\\|=>]{7}<cr>zvzz" {:silent true})
(no :x "]n" "/\\v^[<\\|=>]{7}<cr>zvzz" {:silent true})
(no :x "[n" "[n ?\\v^[<\\|=>]{7}<cr>zvzz" {:silent true})

; nno <expr> [e <sid>move_line_setup('up')
; nno <expr> ]e <sid>move_line_setup('down')

(no :n "]q" "<Cmd><C-r>=v:count1<CR>cnext<CR>zz" {:silent true})
(no :n "[q" "<Cmd><C-r>=v:count1<CR>cprev<CR>zz" {:silent true})
(no :n "]Q" :<Cmd>cnfile<CR>zz {:silent true})
(no :n "[Q" :<Cmd>cpfile<CR>zz {:silent true})
(no :n "]l" "<Cmd><c-r>=v:count1<cr>lnext<cr>zz" {:silent true})
(no :n "[l" "<Cmd><c-r>=v:count1<cr>lprev<cr>zz" {:silent true})
(no :n "]L" :<Cmd>lnfile<cr>zz {:silent true})
(no :n "[L" :<Cmd>lpfile<cr>zz {:silent true})

; (no "" :<Space>d "<Cmd>bd<CR>" {:silent true})
(no "" :<Space>q "<Cmd>b#<CR>" {:silent true})

; nno <silent> <space>ev :<c-u>edit ~/.vim/vimrc<cr>
; nno <silent> <space>el :<c-u>edit ~/.vim/lua/my<cr>
; nno <silent> <space>ep :<c-u>edit ~/.vim/pack/mine/start<cr>
; nno <silent> <space>ez :<c-u>edit ~/.zshrc<cr>
; nno <silent> <space>ec :<c-u>edit ~/.vim/pack/mine/start/gruvburn/gruvburn.colortemplate<cr>
; nno <silent> <space>en :<c-u>edit ~/notes/notes.md<cr>
; nno <silent> <space>et :<c-u>edit ~/.config/tmux/tmux.conf<cr>
; nno <silent> <space>ea :<c-u>edit ~/.config/alacritty/alacritty.yml<cr>

(no :c :<C-p> :<Up>)
(no :c :<C-n> :<Down>)
(no :c :<C-j> :<C-g>)
(no :c :<C-k> :<C-t>)
(no :c :<C-a> :<Home>)

(no :i :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<cr>")
(no :c :<C-o> "<c-r>=expand(\"%:t:r:r:r\")<cr>")
(no :n :yo ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<cr>'<cr>" {:silent true})
(no :n :yO ":<c-u>let @\"='<c-r>=expand(\"%:p\")<cr>'<cr>" {:silent true})

(no :n :<space>t :<Cmd>tabedit<cr> {:silent true})
(no :n "\\" :za {:silent true})
(no :n :cn :cgn {:silent true})

(no :n :<space>l :<Cmd>vsplit<cr> {:silent true})
(no :n :<space>j :<Cmd>split<cr> {:silent true})
(no :n :<space>h :<Cmd>vsplit<Bar>wincmd p<cr> {:silent true})
(no :n :<space>k :<Cmd>split<Bar>wincmd p<cr> {:silent true})

(no :n :<c-q> :<Cmd>q<cr> {:silent true})
(no :n "g;" "g;zvzz")

; ca ~? ~/

; xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
; xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')

; nno <silent> g> :set nomore<bar>echo repeat("\n",&cmdheight)<bar>40messages<bar>set more<CR>

