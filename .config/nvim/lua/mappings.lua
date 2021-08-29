vim.g.mapleader = "<s-f5>"
vim.g.maplocalleader = ","
vim.cmd("cnoreabbrev ~? ~/")
vim.cmd("cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'Man' : 'man'")
do
  vim.api.nvim_set_keymap("n", "<Down>", "gj", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<Up>", "gk", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<c-e>", "<c-e><c-e>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<c-y>", "<c-y><c-y>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "<", "<gv", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", ">", ">gv", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "Z", "zzzH", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "Z", "zzzH", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "p", "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'", {expr = true, noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "P", "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'", {expr = true, noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "p", "'\"_c<C-r>'.v:register.'<Esc>'", {expr = true, noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "K", "k", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", "J", "j", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", ";", ":", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", ";", ":", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", ":", ";", {noremap = true})
end
do
  vim.api.nvim_set_keymap("x", ":", ";", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "Q", "@q", {noremap = true})
end
do
  vim.api.nvim_set_keymap("", "Y", "y$", {noremap = true})
end
do
  vim.api.nvim_set_keymap("", "H", "^", {noremap = true})
end
do
  vim.api.nvim_set_keymap("", "L", "$", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<C-p>", "<C-i>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<Home>", "<CMD>keepj norm! gg<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<End>", "<CMD>keepj norm! G<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<PageUp>", "<PageUp>:keepj norm! H<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<PageDown>", "<PageDown>:keepj norm! L<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "`", "g`", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "'", "g'", {noremap = true})
end
do
  vim.api.nvim_set_keymap("", "(", "H", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", ")", "L", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "M", "<CMD>keepj norm! M<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "{", "<CMD>keepj norm! {<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "}", "<CMD>keepj norm! }<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "gg", "<CMD>keepj norm! gg<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "G", "<CMD>keepj norm! G<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "n", "<CMD>keepj norm! nzzzv<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "N", "<CMD>keepj norm! Nzzzv<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "*", "<CMD>keepj norm! *<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "#", "<CMD>keepj norm! #<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "g*", "<CMD>keepj norm! g*<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "g#", "<CMD>keepj norm! g#<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "*", "\"vyms:let @/='<c-r>v'<bar>keepj norm! n<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "#", "\"vyms:let @/='<c-r>v'<bar>keepj norm! N<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "g*", "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! n<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "g#", "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! N<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "g/", "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<RightMouse>", "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "S", "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:%s///g<left><left>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>s", ":<C-u>%s///g<left><left>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "=v", "mvg'[=g']g`v", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "gs", "gv", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "gv", "g`[vg`]", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "gV", "g'[Vg']", {noremap = true})
end
do
  vim.api.nvim_set_keymap("!", "<A-h>", "<Left>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("!", "<A-l>", "<Right>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("!", "<A-j>", "<C-Left>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("!", "<A-k>", "<C-Right>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<A-l>", "<C-w>L", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<A-h>", "<C-w>H", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<A-j>", "<C-w>J", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<A-k>", "<C-w>K", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "]b", "<CMD>bnext<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[b", "<CMD>bprev<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[t", "<CMD>tabprev<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]t", "<CMD>tabnext<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]T", "<CMD>+tabmove<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[T", "<CMD>-tabmove<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]n", "/\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[n", "?\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "]n", "/\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "[n", "[n ?\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]q", "<CMD><C-r>=v:count1<CR>cnext<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[q", "<CMD><C-r>=v:count1<CR>cprev<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]Q", "<CMD>cnfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[Q", "<CMD>cpfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]l", "<CMD><c-r>=v:count1<CR>lnext<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[l", "<CMD><c-r>=v:count1<CR>lprev<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]L", "<CMD>lnfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[L", "<CMD>lpfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "<Space>d", "<CMD>call Kwbd(1)<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "<Space>q", "<CMD>b#<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>ev", "<CMD>e ~/.config/nvim/init.lua<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>el", "<CMD>e ~/.config/nvim/fnl/<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>ep", "<CMD>e ~/.local/share/nvim/site/pack/packer/start/<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>ez", "<CMD>e ~/.zshrc<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>en", "<CMD>e ~/notes/notes.md<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>et", "<CMD>e ~/.config/tmux/tmux.conf<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>ea", "<CMD>e ~/.config/alacritty/alacritty.yml<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("c", "<C-j>", "<C-g>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("c", "<C-k>", "<C-t>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("i", "<C-o>", "<c-r>=expand(\"%:t:r:r:r\")<CR>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("c", "<C-o>", "<c-r>=expand(\"%:t:r:r:r\")<CR>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "yo", ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<CR>'<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "yO", ":<c-u>let @\"='<c-r>=expand(\"%:p\")<CR>'<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>t", "<CMD>tabedit<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "cn", "cgn", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>l", "<CMD>vsplit<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>j", "<CMD>split<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>h", "<CMD>vsplit<Bar>wincmd p<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>k", "<CMD>split<Bar>wincmd p<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "<C-q>", "<CMD>q<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<C-s>", "<C-a>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<CR>", "<CMD>w<CR>", {noremap = true, silent = true})
end
vim.cmd("xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')")
vim.cmd("xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')")
do
  vim.api.nvim_set_keymap("n", "con", "<CMD>set number!<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "coc", "<CMD>set cursorline<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "cow", "<CMD>set wrap!<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "cow", "<CMD>set wrap!<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "col", "<CMD>set hlsearch!<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "coi", "<CMD>set ignorecase!<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "g.", ":set nomore<bar>echo repeat(\"\\n\",&cmdheight)<bar>40messages<bar>set more<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", ".", ":norm! .<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("i", "<C-p>", "<C-o>p", {noremap = true})
end
local function move_line(dir)
  vim.cmd("keepj norm! mv")
  local _1_
  if (dir == "up") then
    _1_ = "--"
  else
    _1_ = "+"
  end
  vim.cmd(("move " .. _1_ .. vim.v.count1))
  return vim.cmd("keepj norm! =`v")
end
local function move_line_up()
  return move_line("up")
end
local function move_line_down()
  return move_line("down")
end
do
  _G["my__map__move_line_up"] = move_line_up
  vim.api.nvim_set_keymap("n", "[e", "<Cmd>lua my__map__move_line_up()<CR>", {noremap = true})
end
do
  _G["my__map__move_line_down"] = move_line_down
  vim.api.nvim_set_keymap("n", "]e", "<Cmd>lua my__map__move_line_down()<CR>", {noremap = true})
end
local function zoom_toggle()
  if (vim.fn.winnr("$") ~= 1) then
    if vim.t.zoom_restore then
      vim.cmd("exe t:zoom_restore")
      return vim.cmd("unlet t:zoom_restore")
    else
      vim.t.zoom_restore = vim.fn.winrestcmd()
      vim.cmd("wincmd |")
      return vim.cmd("wincmd _")
    end
  end
end
do
  _G["my__map__zoom_toggle"] = zoom_toggle
  vim.api.nvim_set_keymap("n", "<space>z", "<Cmd>lua my__map__zoom_toggle()<CR>", {noremap = true, silent = true})
end
local function visual_slash()
  return vim.api.nvim_input("/\\%V")
end
_G["my__map__visual_slash"] = visual_slash
return vim.api.nvim_set_keymap("x", "/", "<Cmd>lua my__map__visual_slash()<CR>", {noremap = true})
