(import-macros {: no} :macros)

(set vim.g.mapleader :<s-f5>)
(set vim.g.maplocalleader ",")

(vim.cmd "cabbrev ~? ~/")

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

(vim.cmd "xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')")
(vim.cmd "xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')")

(no n :con "<CMD>set number!<CR>" :silent)
(no n :coc "<CMD>set cursorline<CR>" :silent)
(no n :cow "<CMD>set wrap!<CR>" :silent)
(no n :cow "<CMD>set wrap!<CR>" :silent)
(no n :col "<CMD>set hlsearch!<CR>" :silent)
(no n :coi "<CMD>set ignorecase!<CR>" :silent)

(no n :g>
    ":set nomore<bar>echo repeat(\"\\n\",&cmdheight)<bar>40messages<bar>set more<CR>"
    :silent)

;; Repeat last edit on all the visually selected lines with dot
(no x "." ":norm! .<CR>" :silent)

