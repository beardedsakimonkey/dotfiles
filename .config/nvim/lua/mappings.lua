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
  vim.api.nvim_set_keymap("n", "s", "\"_s", {noremap = true})
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
  vim.api.nvim_set_keymap("", "<tab>", "<CMD>keepj norm! %<CR>", {silent = true})
end
do
  vim.api.nvim_set_keymap("n", "`", "g`", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "'", "g'", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "g.", "g`.", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "gi", "g`^", {noremap = true})
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
  vim.api.nvim_set_keymap("n", "*", "<CMD>norm! *<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "#", "<CMD>norm! #<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "g*", "<CMD>norm! g*<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "g#", "<CMD>norm! g#<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "*", "\"vyms:let @/='<c-r>v'<bar>norm! n<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "#", "\"vyms:let @/='<c-r>v'<bar>norm! N<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "g*", "\"vyms:let @/='\\<<c-r>v\\>'<bar>norm! n<CR>zzzv", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("x", "g#", "\"vyms:let @/='\\<<c-r>v\\>'<bar>norm! N<CR>zzzv", {noremap = true, silent = true})
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
  vim.api.nvim_set_keymap("n", "<Space>s", "ms:<C-u>%s///g<left><left>", {noremap = true})
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
  vim.api.nvim_set_keymap("n", "]q", ":<C-u><C-r>=v:count1<CR>cnext<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[q", ":<C-u><C-r>=v:count1<CR>cprev<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]Q", "<Cmd>cnfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[Q", "<Cmd>cpfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]l", ":<C-u><c-r>=v:count1<CR>lnext<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[l", ":<C-u><c-r>=v:count1<CR>lprev<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "]L", "<Cmd>lnfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "[L", "<Cmd>lpfile<CR>zz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "]n", "/\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "[n", "?\\v^[<\\|=>]{7}<CR>zvzz", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "<Space>d", "<CMD>call Kwbd(1)<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "<Space>q", "<CMD>b#<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<Space>ev", "<CMD>e ~/.config/nvim/lua<CR>", {noremap = true, silent = true})
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
  vim.api.nvim_set_keymap("x", ".", ":norm! .<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("", "<C-g>", "g<C-g>", {noremap = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>l", "<CMD>vsplit<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "<space>j", "<CMD>split<CR>", {noremap = true, silent = true})
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
  vim.api.nvim_set_keymap("n", "g>", "<CMD>40messages<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "con", "<CMD>set number!<CR>", {noremap = true, silent = true})
end
do
  vim.api.nvim_set_keymap("n", "coc", "<CMD>set cursorline!<CR>", {noremap = true, silent = true})
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
local function move_line(dir)
  vim.cmd("keepj norm! mv")
  local function _1_()
    if (dir == "up") then
      return "--"
    else
      return "+"
    end
  end
  vim.cmd(("move " .. _1_() .. vim.v.count1))
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
  else
    return nil
  end
end
do
  _G["my__map__zoom_toggle"] = zoom_toggle
  vim.api.nvim_set_keymap("n", "<space>z", "<Cmd>lua my__map__zoom_toggle()<CR>", {noremap = true, silent = true})
end
local function visual_slash()
  return vim.api.nvim_input("/\\%V")
end
do
  _G["my__map__visual_slash"] = visual_slash
  vim.api.nvim_set_keymap("x", "/", "<Cmd>lua my__map__visual_slash()<CR>", {noremap = true})
end
local function repeat_last_edit()
  local changed = vim.fn.getreg("\"", 1, 1)
  if changed then
    local changed0
    local function _4_(_241)
      return vim.fn.escape(_241, "\\")
    end
    changed0 = vim.tbl_map(_4_, changed)
    local pat = table.concat(changed0, "\\n")
    vim.fn.setreg("/", ("\\V" .. pat), "c")
    return vim.cmd("exe \"norm! cgn\\<c-@>\"")
  else
    return nil
  end
end
do
  _G["my__map__repeat_last_edit"] = repeat_last_edit
  vim.api.nvim_set_keymap("n", "<space>.", "<Cmd>lua my__map__repeat_last_edit()<CR>", {noremap = true})
end
local function previous_window_in_same_direction(dir)
  local cnr = vim.fn.winnr()
  local pnr = vim.fn.winnr("#")
  local _6_ = dir
  if (_6_ == "h") then
    local leftedge_current_window = vim.fn.win_screenpos(cnr)[2]
    local rightedge_previous_window = ((vim.fn.win_screenpos(pnr)[2] + vim.fn.winwidth(pnr)) - 1)
    return ((leftedge_current_window - 1) == (rightedge_previous_window + 1))
  elseif (_6_ == "l") then
    local leftedge_previous_window = vim.fn.win_screenpos(pnr)[2]
    local rightedge_current_window = ((vim.fn.win_screenpos(cnr)[2] + vim.fn.winwidth(cnr)) - 1)
    return ((leftedge_previous_window - 1) == (rightedge_current_window + 1))
  elseif (_6_ == "j") then
    local topedge_previous_window = vim.fn.win_screenpos(pnr)[1]
    local bottomedge_current_window = ((vim.fn.win_screenpos(cnr)[1] + vim.fn.winheight(cnr)) - 1)
    return ((topedge_previous_window - 1) == (bottomedge_current_window + 1))
  elseif (_6_ == "k") then
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
local function navigate_l()
  return navigate("l")
end
local function navigate_h()
  return navigate("h")
end
local function navigate_j()
  return navigate("j")
end
local function navigate_k()
  return navigate("k")
end
do
  _G["my__map__navigate_l"] = navigate_l
  vim.api.nvim_set_keymap("n", "<C-l>", "<Cmd>lua my__map__navigate_l()<CR>", {noremap = true, silent = true})
end
do
  _G["my__map__navigate_h"] = navigate_h
  vim.api.nvim_set_keymap("n", "<C-h>", "<Cmd>lua my__map__navigate_h()<CR>", {noremap = true, silent = true})
end
do
  _G["my__map__navigate_j"] = navigate_j
  vim.api.nvim_set_keymap("n", "<C-j>", "<Cmd>lua my__map__navigate_j()<CR>", {noremap = true, silent = true})
end
do
  _G["my__map__navigate_k"] = navigate_k
  vim.api.nvim_set_keymap("n", "<C-k>", "<Cmd>lua my__map__navigate_k()<CR>", {noremap = true, silent = true})
end
local function jump(forward_3f)
  local bufnr = vim.api.nvim_get_current_buf()
  local _let_9_ = vim.fn.getjumplist()
  local jumplist = _let_9_[1]
  local index = _let_9_[2]
  local start, stop, step = nil, nil, nil
  if forward_3f then
    start, stop, step = (index + 2), #jumplist, 1
  else
    start, stop, step = index, 1, -1
  end
  local target = nil
  local count = vim.v.count1
  for i = start, stop, step do
    if (count == 0) then break end
    local _11_ = jumplist[i]
    if ((_G.type(_11_) == "table") and ((_11_).bufnr == bufnr)) then
      count = (count - 1)
      target = i
    else
    end
  end
  if target then
    local cmd
    local function _13_()
      if forward_3f then
        return ((1 + (target - start)) .. vim.api.nvim_replace_termcodes("<C-I>", true, true, true))
      else
        return ((1 + (start - target)) .. vim.api.nvim_replace_termcodes("<C-O>", true, true, true))
      end
    end
    cmd = ("normal! " .. _13_())
    return vim.cmd(cmd)
  else
    return nil
  end
end
local function jump_backward()
  return jump(false)
end
local function jump_forward()
  return jump(true)
end
do
  _G["my__map__jump_backward"] = jump_backward
  vim.api.nvim_set_keymap("n", "[j", "<Cmd>lua my__map__jump_backward()<CR>", {noremap = true})
end
_G["my__map__jump_forward"] = jump_forward
return vim.api.nvim_set_keymap("n", "]j", "<Cmd>lua my__map__jump_forward()<CR>", {noremap = true})
