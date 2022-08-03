vim.g.mapleader = "<s-f5>"
vim.g.maplocalleader = ","
local function nav_change_list(cmd)
  local _local_1_ = vim.api.nvim_win_get_cursor(0)
  local line = _local_1_[1]
  vim.cmd(("sil! normal! " .. cmd))
  local _local_2_ = vim.api.nvim_win_get_cursor(0)
  local line2 = _local_2_[1]
  if (line == line2) then
    return vim.cmd(("sil! normal! " .. cmd))
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
vim.keymap.set("n", "<Down>", "gj", {})
vim.keymap.set("n", "<Up>", "gk", {})
vim.keymap.set("n", "<c-e>", "<c-e><c-e>", {})
vim.keymap.set("n", "<c-y>", "<c-y><c-y>", {})
vim.keymap.set("", "<C-g>", "g<C-g>", {})
vim.keymap.set("n", "<", "<<", {})
vim.keymap.set("n", ">", ">>", {})
vim.keymap.set("x", "<", "<gv", {})
vim.keymap.set("x", ">", ">gv", {})
vim.keymap.set({"n", "x"}, "s", "\"_s", {})
vim.keymap.set("n", "p", "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'", {expr = true})
vim.keymap.set("n", "P", "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'", {expr = true})
vim.keymap.set("x", "p", "'\"_c<C-r>'.v:register.'<Esc>'", {expr = true})
vim.keymap.set("n", "`", "g`", {})
vim.keymap.set("n", "'", "g'", {})
vim.keymap.set("n", "n", "<Cmd>keepj norm! nzzzv<CR>", {silent = true})
vim.keymap.set("n", "N", "<Cmd>keepj norm! Nzzzv<CR>", {silent = true})
vim.keymap.set("n", "*", "*zzzv", {silent = true})
vim.keymap.set("n", "#", "#zzzv", {silent = true})
vim.keymap.set("n", "g*", "g*zzzv", {silent = true})
vim.keymap.set("n", "g#", "g#zzzv", {silent = true})
local function _12_()
  return nav_change_list("g;")
end
vim.keymap.set("n", "g;", _12_, {})
local function _13_()
  return nav_change_list("g,")
end
vim.keymap.set("n", "g'", _13_, {})
vim.keymap.set("n", "<PageUp>", "<PageUp>:keepj norm! H<CR>", {silent = true})
vim.keymap.set("n", "<PageDown>", "<PageDown>:keepj norm! L<CR>", {silent = true})
vim.keymap.set({"n", "x"}, ";", ":", {})
vim.keymap.set({"n", "x"}, ":", ";", {})
vim.keymap.set("n", "`", "'", {})
vim.keymap.set("n", "'", "`", {})
vim.keymap.set("", "H", "^", {})
vim.keymap.set("", "L", "$", {})
vim.keymap.set("", "(", "H", {silent = true})
vim.keymap.set("", ")", "L", {silent = true})
vim.keymap.set("n", "<Home>", "<Cmd>keepj norm! gg<CR>", {silent = true})
vim.keymap.set("n", "<End>", "<Cmd>keepj norm! G<CR>", {silent = true})
vim.keymap.set("n", "<C-s>", "<C-a>", {silent = true})
vim.keymap.set("", "<tab>", "<Cmd>keepj norm! %<CR>", {silent = true})
vim.keymap.set("n", "<C-p>", "<Tab>", {})
local function _14_()
  return navigate("l")
end
vim.keymap.set("n", "<C-l>", _14_, {silent = true})
local function _15_()
  return navigate("h")
end
vim.keymap.set("n", "<C-h>", _15_, {silent = true})
local function _16_()
  return navigate("j")
end
vim.keymap.set("n", "<C-j>", _16_, {silent = true})
local function _17_()
  return navigate("k")
end
vim.keymap.set("n", "<C-k>", _17_, {silent = true})
vim.keymap.set("n", "gv", "g`[vg`]", {})
vim.keymap.set("n", "gV", "g'[Vg']", {})
vim.keymap.set("n", "gs", "gv", {})
vim.keymap.set("n", "cn", "cgn", {silent = true})
vim.keymap.set({"n", "x"}, "Z", "zzzH", {})
vim.keymap.set("n", "Q", "@q", {})
vim.keymap.set("n", "<CR>", "<Cmd>w<CR>", {silent = true})
vim.keymap.set("", "<C-q>", "<Cmd>q<CR>", {silent = true})
vim.keymap.set("n", "<space>l", "<Cmd>vsplit<CR>", {silent = true})
vim.keymap.set("n", "<space>j", "<Cmd>split<CR>", {silent = true})
vim.keymap.set("n", "<space>t", "<Cmd>tabedit<CR>", {silent = true})
vim.keymap.set("", "<Space>d", "<Cmd>call Kwbd(1)<CR>", {silent = true})
vim.keymap.set("", "<Space>q", "<Cmd>b#<CR>", {silent = true})
vim.keymap.set("n", "g>", "<Cmd>40messages<CR>", {silent = true})
vim.keymap.set("n", "gi", "g`^", {})
vim.keymap.set("n", "<space>z", zoom_toggle, {silent = true})
vim.keymap.set("x", ".", ":norm! .<CR>", {silent = true})
vim.keymap.set("n", "<space>.", repeat_last_edit, {})
vim.keymap.set("x", "/", search_in_visual_selection, {})
vim.keymap.set("x", "<space>y", "\"*y", {})
vim.keymap.set("x", "I", "mode() =~# '[vV]' ? '<C-v>^o^I' : 'I'", {expr = true})
vim.keymap.set("x", "A", "mode() =~# '[vV]' ? '<C-v>0o$A' : 'A'", {expr = true})
vim.keymap.set("c", "<C-p>", "<Up>", {})
vim.keymap.set("c", "<C-n>", "<Down>", {})
vim.keymap.set("c", "<C-j>", "<C-g>", {})
vim.keymap.set("c", "<C-k>", "<C-t>", {})
vim.keymap.set("c", "<C-a>", "<Home>", {})
vim.keymap.set("n", "M", "<Cmd>keepj norm! M<CR>", {silent = true})
vim.keymap.set("n", "{", "<Cmd>keepj norm! {<CR>", {silent = true})
vim.keymap.set("n", "}", "<Cmd>keepj norm! }<CR>", {silent = true})
vim.keymap.set("n", "gg", "<Cmd>keepj norm! gg<CR>", {silent = true})
vim.keymap.set("n", "G", "<Cmd>keepj norm! G<CR>", {silent = true})
vim.keymap.set("x", "*", "\"vy:let @/='\\<<c-r>v\\>'<CR>nzzzv", {silent = true})
vim.keymap.set("x", "#", "\"vy:let @/='\\<<c-r>v\\>'<CR>Nzzzv", {silent = true})
vim.keymap.set("x", "g*", "\"vy:let @/='<c-r>v'<CR>nzzzv", {silent = true})
vim.keymap.set("x", "g#", "\"vy:let @/='<c-r>v'<CR>Nzzzv", {silent = true})
vim.keymap.set("n", "g/", ":<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {silent = true})
vim.keymap.set("x", "g/", "\"vy:let @/='<c-r>v'<Bar>set hls<CR>", {})
vim.keymap.set("n", "<RightMouse>", "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {silent = true})
vim.keymap.set("n", "<Space>s", "ms:<C-u>%s///g<left><left>", {})
vim.keymap.set("x", "<space>s", "\"vy:let @/='<c-r>v'<CR>:<C-u>%s///g<left><left>", {})
vim.keymap.set("n", "S", "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:%s///g<left><left>", {})
vim.keymap.set("!", "<A-h>", "<Left>", {})
vim.keymap.set("!", "<A-l>", "<Right>", {})
vim.keymap.set("!", "<A-j>", "<C-Left>", {})
vim.keymap.set("!", "<A-k>", "<C-Right>", {})
vim.keymap.set("n", "<A-l>", "<C-w>L", {})
vim.keymap.set("n", "<A-h>", "<C-w>H", {})
vim.keymap.set("n", "<A-j>", "<C-w>J", {})
vim.keymap.set("n", "<A-k>", "<C-w>K", {})
vim.keymap.set("n", "]b", "<Cmd>bnext<CR>", {silent = true})
vim.keymap.set("n", "[b", "<Cmd>bprev<CR>", {silent = true})
vim.keymap.set("n", "[t", "<Cmd>tabprev<CR>", {silent = true})
vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", {silent = true})
vim.keymap.set("n", "]T", "<Cmd>+tabmove<CR>", {silent = true})
vim.keymap.set("n", "[T", "<Cmd>-tabmove<CR>", {silent = true})
vim.keymap.set("n", "]q", ":<C-u><C-r>=v:count1<CR>cnext<CR>zz", {silent = true})
vim.keymap.set("n", "[q", ":<C-u><C-r>=v:count1<CR>cprev<CR>zz", {silent = true})
vim.keymap.set("n", "]Q", "<Cmd>cnfile<CR>zz", {silent = true})
vim.keymap.set("n", "[Q", "<Cmd>cpfile<CR>zz", {silent = true})
vim.keymap.set("n", "]l", ":<C-u><c-r>=v:count1<CR>lnext<CR>zz", {silent = true})
vim.keymap.set("n", "[l", ":<C-u><c-r>=v:count1<CR>lprev<CR>zz", {silent = true})
vim.keymap.set("n", "]L", "<Cmd>lnfile<CR>zz", {silent = true})
vim.keymap.set("n", "[L", "<Cmd>lpfile<CR>zz", {silent = true})
vim.keymap.set("", "]n", "/\\v^[<\\|=>]{7}<CR>zvzz", {silent = true})
vim.keymap.set("", "[n", "?\\v^[<\\|=>]{7}<CR>zvzz", {silent = true})
local function _18_()
  return move_line("up")
end
vim.keymap.set("n", "[e", _18_, {})
local function _19_()
  return move_line("down")
end
vim.keymap.set("n", "]e", _19_, {})
vim.keymap.set("n", ":V", "<Cmd>e ~/.config/nvim/lua/<CR>", {silent = true})
vim.keymap.set("n", ":C", "<Cmd>e ~/.config/nvim/lua/config/<CR>", {silent = true})
vim.keymap.set("n", ":P", "<Cmd>e ~/.local/share/nvim/site/pack/packer/start/<CR>", {silent = true})
vim.keymap.set("n", ":Z", "<Cmd>e ~/.zshrc<CR>", {silent = true})
vim.keymap.set("n", ":N", "<Cmd>e ~/notes/notes.md<CR>", {silent = true})
vim.keymap.set("n", ":T", "<Cmd>e ~/notes/todo.md<CR>", {silent = true})
vim.keymap.set("n", ":A", "<Cmd>e ~/.config/alacritty/alacritty.yml<CR>", {silent = true})
vim.keymap.set("n", ":U", "<Cmd>e ~/Library/Application\\ Support/Firefox/Profiles/2a6723nr.default-release/user.js<CR>", {silent = true})
vim.keymap.set("i", "<C-d>", "<c-r>=expand(\"%:t:r:r:r\")<CR>", {})
vim.keymap.set("c", "<C-d>", "<c-r>=expand(\"%:t:r:r:r\")<CR>", {})
vim.keymap.set("n", "yd", ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<CR>'<CR>", {silent = true})
vim.keymap.set("n", "yD", ":<c-u>let @\"='<c-r>=expand(\"%:p\")<CR>'<CR>", {silent = true})
vim.keymap.set("n", "gon", "<Cmd>set number!<CR>", {silent = true})
vim.keymap.set("n", "goc", "<Cmd>set cursorline!<CR>", {silent = true})
vim.keymap.set("n", "gow", "<Cmd>set wrap!<CR>", {silent = true})
vim.keymap.set("n", "gol", "<Cmd>set hlsearch!<CR>", {silent = true})
vim.keymap.set("n", "goi", "<Cmd>set ignorecase!<CR>", {silent = true})
vim.keymap.set("x", "K", "k", {})
vim.keymap.set("x", "J", "j", {})
vim.cmd("cnoreabbrev ~? ~/")
return vim.cmd("cnoreabbrev <expr> man getcmdtype() is# \":\" && getcmdpos() == 4 ? 'vert Man' : 'man'")
