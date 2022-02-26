vim.g.mapleader = "<s-f5>"
vim.g.maplocalleader = ","
local function prev_change_list()
  local _local_1_ = vim.api.nvim_win_get_cursor(0)
  local row = _local_1_[1]
  local _ = _local_1_[2]
  vim.cmd("normal! g;")
  local _local_2_ = vim.api.nvim_win_get_cursor(0)
  local row2 = _local_2_[1]
  local _0 = _local_2_[2]
  local delta = math.abs((row - row2))
  if (delta <= 1) then
    return vim.cmd("normal! g;")
  else
    return nil
  end
end
local function move_line(dir)
  vim.cmd("keepj norm! mv")
  local function _4_()
    if (dir == "up") then
      return "--"
    else
      return "+"
    end
  end
  vim.cmd(("move " .. _4_() .. vim.v.count1))
  return vim.cmd("keepj norm! =`v")
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
  else
    return nil
  end
end
local function search_in_visual_selection()
  return vim.api.nvim_input("/\\%V")
end
local function repeat_last_edit()
  local changed = vim.fn.getreg("\"", 1, 1)
  if changed then
    local changed0
    local function _7_(_241)
      return vim.fn.escape(_241, "\\")
    end
    changed0 = vim.tbl_map(_7_, changed)
    local pat = table.concat(changed0, "\\n")
    vim.fn.setreg("/", ("\\V" .. pat), "c")
    return vim.cmd("exe \"norm! cgn\\<c-@>\"")
  else
    return nil
  end
end
local function previous_window_in_same_direction(dir)
  local cnr = vim.fn.winnr()
  local pnr = vim.fn.winnr("#")
  local _9_ = dir
  if (_9_ == "h") then
    local leftedge_current_window = vim.fn.win_screenpos(cnr)[2]
    local rightedge_previous_window = ((vim.fn.win_screenpos(pnr)[2] + vim.fn.winwidth(pnr)) - 1)
    return ((leftedge_current_window - 1) == (rightedge_previous_window + 1))
  elseif (_9_ == "l") then
    local leftedge_previous_window = vim.fn.win_screenpos(pnr)[2]
    local rightedge_current_window = ((vim.fn.win_screenpos(cnr)[2] + vim.fn.winwidth(cnr)) - 1)
    return ((leftedge_previous_window - 1) == (rightedge_current_window + 1))
  elseif (_9_ == "j") then
    local topedge_previous_window = vim.fn.win_screenpos(pnr)[1]
    local bottomedge_current_window = ((vim.fn.win_screenpos(cnr)[1] + vim.fn.winheight(cnr)) - 1)
    return ((topedge_previous_window - 1) == (bottomedge_current_window + 1))
  elseif (_9_ == "k") then
    local topedge_current_window = vim.fn.win_screenpos(cnr)[1]
    local bottomedge_previous_window = ((vim.fn.win_screenpos(pnr)[1] + vim.fn.winheight(pnr)) - 1)
    return ((topedge_current_window - 1) == (bottomedge_previous_window + 1))
  else
    return nil
  end
end
local function navigate(dir)
  if previous_window_in_same_direction(dir) then
    return vim.cmd("try | wincmd p | catch | entry")
  else
    return vim.cmd(("try | wincmd " .. dir .. " | catch | endtry"))
  end
end
vim.api.nvim_set_keymap("n", "<Down>", "gj", {noremap = true})
vim.api.nvim_set_keymap("n", "<Up>", "gk", {noremap = true})
vim.api.nvim_set_keymap("n", "<c-e>", "<c-e><c-e>", {noremap = true})
vim.api.nvim_set_keymap("n", "<c-y>", "<c-y><c-y>", {noremap = true})
vim.api.nvim_set_keymap("", "<C-g>", "g<C-g>", {noremap = true})
do
  vim.api.nvim_set_keymap("n", "<", "<<", {noremap = true})
  vim.api.nvim_set_keymap("x", "<", "<<", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", ">", ">>", {noremap = true})
  vim.api.nvim_set_keymap("x", ">", ">>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "s", "\"_s", {noremap = true})
  vim.api.nvim_set_keymap("x", "s", "\"_s", {noremap = true})
end
vim.api.nvim_set_keymap("n", "p", "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'", {expr = true, noremap = true})
vim.api.nvim_set_keymap("n", "P", "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'", {expr = true, noremap = true})
vim.api.nvim_set_keymap("x", "p", "'\"_c<C-r>'.v:register.'<Esc>'", {expr = true, noremap = true})
vim.api.nvim_set_keymap("n", "`", "g`", {noremap = true})
vim.api.nvim_set_keymap("n", "'", "g'", {noremap = true})
local function _12_()
  return navigate("l")
end
vim.api.nvim_set_keymap("n", "<C-l>", "", {callback = _12_, noremap = true, silent = true})
local function _13_()
  return navigate("h")
end
vim.api.nvim_set_keymap("n", "<C-h>", "", {callback = _13_, noremap = true, silent = true})
local function _14_()
  return navigate("j")
end
vim.api.nvim_set_keymap("n", "<C-j>", "", {callback = _14_, noremap = true, silent = true})
local function _15_()
  return navigate("k")
end
vim.api.nvim_set_keymap("n", "<C-k>", "", {callback = _15_, noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "n", "<CMD>keepj norm! nzzzv<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "N", "<CMD>keepj norm! Nzzzv<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "*", "*zzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "#", "#zzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "g*", "g*zzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "g#", "g#zzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "g;", "", {callback = prev_change_list, noremap = true})
vim.api.nvim_set_keymap("n", "<PageUp>", "<PageUp>:keepj norm! H<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<PageDown>", "<PageDown>:keepj norm! L<CR>", {noremap = true, silent = true})
do
  vim.api.nvim_set_keymap("n", ";", ":", {noremap = true})
  vim.api.nvim_set_keymap("x", ";", ":", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", ":", ";", {noremap = true})
  vim.api.nvim_set_keymap("x", ":", ";", {noremap = true})
end
vim.api.nvim_set_keymap("", "H", "^", {noremap = true})
vim.api.nvim_set_keymap("", "L", "$", {noremap = true})
vim.api.nvim_set_keymap("", "(", "H", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", ")", "L", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<Home>", "<CMD>keepj norm! gg<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<End>", "<CMD>keepj norm! G<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-s>", "<C-a>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "<tab>", "<CMD>keepj norm! %<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-p>", "<Tab>", {noremap = true})
vim.api.nvim_set_keymap("n", "gv", "g`[vg`]", {noremap = true})
vim.api.nvim_set_keymap("n", "gV", "g'[Vg']", {noremap = true})
vim.api.nvim_set_keymap("n", "gs", "gv", {noremap = true})
vim.api.nvim_set_keymap("n", "cn", "cgn", {noremap = true, silent = true})
do
  vim.api.nvim_set_keymap("n", "Z", "zzzH", {noremap = true})
  vim.api.nvim_set_keymap("x", "Z", "zzzH", {noremap = true})
end
vim.api.nvim_set_keymap("n", "Q", "@q", {noremap = true})
vim.api.nvim_set_keymap("n", "<CR>", "<CMD>w<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "<C-q>", "<CMD>q<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<space>l", "<CMD>vsplit<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<space>j", "<CMD>split<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<space>t", "<CMD>tabedit<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "<Space>d", "<CMD>call Kwbd(1)<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "<Space>q", "<CMD>b#<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "g>", "<CMD>40messages<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gi", "g`^", {noremap = true})
vim.api.nvim_set_keymap("n", "<space>z", "", {callback = zoom_toggle, noremap = true, silent = true})
vim.api.nvim_set_keymap("x", ".", ":norm! .<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "g.", "", {callback = repeat_last_edit, noremap = true})
vim.cmd("xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')")
vim.cmd("xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')")
vim.api.nvim_set_keymap("x", "/", "", {callback = search_in_visual_selection, noremap = true})
vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", {noremap = true})
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", {noremap = true})
vim.api.nvim_set_keymap("c", "<C-j>", "<C-g>", {noremap = true})
vim.api.nvim_set_keymap("c", "<C-k>", "<C-t>", {noremap = true})
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", {noremap = true})
vim.api.nvim_set_keymap("n", "M", "<CMD>keepj norm! M<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "{", "<CMD>keepj norm! {<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "}", "<CMD>keepj norm! }<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gg", "<CMD>keepj norm! gg<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "G", "<CMD>keepj norm! G<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "*", "\"vy:let @/='\\<<c-r>v\\>'<CR>nzzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "#", "\"vy:let @/='\\<<c-r>v\\>'<CR>Nzzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "g*", "\"vy:let @/='<c-r>v'<CR>nzzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "g#", "\"vy:let @/='<c-r>v'<CR>Nzzzv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "g/", "*N", {noremap = true})
vim.api.nvim_set_keymap("x", "g/", "\"vy:let @/='<c-r>v'<Bar>set hls<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<RightMouse>", "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<Space>s", "ms:<C-u>%s///g<left><left>", {noremap = true})
vim.api.nvim_set_keymap("n", "S", "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:%s///g<left><left>", {noremap = true})
vim.api.nvim_set_keymap("!", "<A-h>", "<Left>", {noremap = true})
vim.api.nvim_set_keymap("!", "<A-l>", "<Right>", {noremap = true})
vim.api.nvim_set_keymap("!", "<A-j>", "<C-Left>", {noremap = true})
vim.api.nvim_set_keymap("!", "<A-k>", "<C-Right>", {noremap = true})
vim.api.nvim_set_keymap("n", "<A-l>", "<C-w>L", {noremap = true})
vim.api.nvim_set_keymap("n", "<A-h>", "<C-w>H", {noremap = true})
vim.api.nvim_set_keymap("n", "<A-j>", "<C-w>J", {noremap = true})
vim.api.nvim_set_keymap("n", "<A-k>", "<C-w>K", {noremap = true})
vim.api.nvim_set_keymap("n", "]b", "<CMD>bnext<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[b", "<CMD>bprev<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[t", "<CMD>tabprev<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]t", "<CMD>tabnext<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]T", "<CMD>+tabmove<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[T", "<CMD>-tabmove<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]q", ":<C-u><C-r>=v:count1<CR>cnext<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[q", ":<C-u><C-r>=v:count1<CR>cprev<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]Q", "<Cmd>cnfile<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[Q", "<Cmd>cpfile<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]l", ":<C-u><c-r>=v:count1<CR>lnext<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[l", ":<C-u><c-r>=v:count1<CR>lprev<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]L", "<Cmd>lnfile<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[L", "<Cmd>lpfile<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "]n", "/\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "[n", "?\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
local function _16_()
  return move_line("up")
end
vim.api.nvim_set_keymap("n", "[e", "", {callback = _16_, noremap = true})
local function _17_()
  return move_line("down")
end
vim.api.nvim_set_keymap("n", "]e", "", {callback = _17_, noremap = true})
vim.api.nvim_set_keymap("n", "'V", "<CMD>e ~/.config/nvim/lua<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "'P", "<CMD>e ~/.local/share/nvim/site/pack/packer/start/<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "'Z", "<CMD>e ~/.zshrc<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "'N", "<CMD>e ~/notes/notes.md<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "'T", "<CMD>e ~/notes/todo.md<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "'A", "<CMD>e ~/.config/alacritty/alacritty.yml<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "'U", "<CMD>e ~/Library/Application\\ Support/Firefox/Profiles/2a6723nr.default-release/user.js<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-o>", "<c-r>=expand(\"%:t:r:r:r\")<CR>", {noremap = true})
vim.api.nvim_set_keymap("c", "<C-o>", "<c-r>=expand(\"%:t:r:r:r\")<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "yo", ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<CR>'<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "yO", ":<c-u>let @\"='<c-r>=expand(\"%:p\")<CR>'<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "con", "<CMD>set number!<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "coc", "<CMD>set cursorline!<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "cow", "<CMD>set wrap!<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "col", "<CMD>set hlsearch!<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "coi", "<CMD>set ignorecase!<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "K", "k", {noremap = true})
vim.api.nvim_set_keymap("x", "J", "j", {noremap = true})
vim.cmd("cnoreabbrev ~? ~/")
return vim.cmd("cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'vert Man' : 'man'")
