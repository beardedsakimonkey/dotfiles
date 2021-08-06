local _2afile_2a = ".config/nvim/fnl/mappings.fnl"
local _0_
do
  local name_0_ = "mappings"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "mappings"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function no(mode, lhs, rhs, opt)
  local opts = vim.tbl_extend("force", {noremap = true}, (opt or {}))
  return vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
vim.g.mapleader = "<s-f5>"
vim.g.maplocalleader = ","
no("n", "<Down>", "gj")
no("n", "<Up>", "gk")
no("n", "<c-e>", "<c-e><c-e>")
no("n", "<c-y>", "<c-y><c-y>")
no("x", "<", "<gv")
no("x", ">", ">gv")
no("n", "s", "\"_s")
no("n", "Z", "zzzH")
no("x", "Z", "zzzH")
no("n", "p", "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'", {expr = true})
no("n", "P", "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'", {expr = true})
no("x", "p", "'\"_c<C-r>'.v:register.'<Esc>'", {expr = true})
no("x", "K", "k")
no("x", "J", "j")
no("n", ";", ":")
no("x", ";", ":")
no("n", ":", ";")
no("x", ":", ";")
no("n", "Q", "@q")
no("", "Y", "y$")
no("", "H", "^")
no("", "L", "$")
no("n", "<C-p>", "<C-i>")
no("n", "<Home>", "<Cmd>keepj norm! gg<CR>", {silent = true})
no("n", "<End>", "<Cmd>keepj norm! G<CR>", {silent = true})
no("n", "<PageUp>", "<PageUp>:keepj norm! H<CR>", {silent = true})
no("n", "<PageDown>", "<PageDown>:keepj norm! L<CR>", {silent = true})
no("n", "<CR>", "<Cmd>w<CR>", {silent = true})
no("n", "`", "g`")
no("n", "'", "g'")
no("", "(", "H", {silent = true})
no("", ")", "L", {silent = true})
no("n", "M", "<Cmd>keepj norm! M<CR>", {silent = true})
no("n", "{", "<Cmd>keepj norm! {<CR>", {silent = true})
no("n", "}", "<Cmd>keepj norm! }<CR>", {silent = true})
no("n", "gg", "<Cmd>keepj norm! gg<CR>", {silent = true})
no("n", "G", "<Cmd>keepj norm! G<CR>", {silent = true})
no("n", "n", "<Cmd>keepj norm! nzzzv<CR>", {silent = true})
no("n", "N", "<Cmd>keepj norm! Nzzzv<CR>", {silent = true})
no("n", "*", "<Cmd>keepj norm! *<CR>zzzv", {silent = true})
no("n", "#", "<Cmd>keepj norm! #<CR>zzzv", {silent = true})
no("n", "g*", "<Cmd>keepj norm! g*<CR>zzzv", {silent = true})
no("n", "g#", "<Cmd>keepj norm! g#<CR>zzzv", {silent = true})
no("x", "*", "\"vyms:let @/='<c-r>v'<bar>keepj norm! n<CR>zzzv", {silent = true})
no("x", "#", "\"vyms:let @/='<c-r>v'<bar>keepj norm! N<CR>zzzv", {silent = true})
no("x", "g*", "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! n<CR>zzzv", {silent = true})
no("x", "g#", "\"vyms:let @/='\\<<c-r>v\\>'<bar>keepj norm! N<cr>zzzv", {silent = true})
no("n", "g/", "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<cr>\\>'<cr>:set hls<cr>", {silent = true})
no("n", "<RightMouse>", "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<cr>\\>'<cr>:set hls<cr>", {silent = true})
no("n", "S", "ms:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<cr>:%s///g<left><left>", {silent = true})
no("n", "<Space>s", "<Cmd>%s///g<left><left>")
no("n", "=v", "mvg'[=g']g`v")
no("n", "gs", "gv")
no("n", "gv", "g`[vg`]")
no("n", "gV", "g'[Vg']")
no("!", "<A-h>", "<Left>")
no("!", "<A-l>", "<Right>")
no("!", "<A-j>", "<C-Left>")
no("!", "<A-k>", "<C-Right>")
no("n", "<A-l>", "<C-w>L")
no("n", "<A-h>", "<C-w>H")
no("n", "<A-j>", "<C-w>J")
no("n", "<A-k>", "<C-w>K")
no("n", "]b", "<Cmd>bnext<CR>", {silent = true})
no("n", "[b", "<Cmd>bprev<CR>", {silent = true})
no("n", "[t", "<Cmd>tabprev<CR>", {silent = true})
no("n", "]t", "<Cmd>tabnext<CR>", {silent = true})
no("n", "]T", "<Cmd>+tabmove<CR>", {silent = true})
no("n", "[T", "<Cmd>-tabmove<CR>", {silent = true})
no("n", "]n", "/\\v^[<\\|=>]{7}<cr>zvzz", {silent = true})
no("n", "[n", "?\\v^[<\\|=>]{7}<cr>zvzz", {silent = true})
no("x", "]n", "/\\v^[<\\|=>]{7}<cr>zvzz", {silent = true})
no("x", "[n", "[n ?\\v^[<\\|=>]{7}<cr>zvzz", {silent = true})
no("n", "]q", "<Cmd><C-r>=v:count1<CR>cnext<CR>zz", {silent = true})
no("n", "[q", "<Cmd><C-r>=v:count1<CR>cprev<CR>zz", {silent = true})
no("n", "]Q", "<Cmd>cnfile<CR>zz", {silent = true})
no("n", "[Q", "<Cmd>cpfile<CR>zz", {silent = true})
no("n", "]l", "<Cmd><c-r>=v:count1<cr>lnext<cr>zz", {silent = true})
no("n", "[l", "<Cmd><c-r>=v:count1<cr>lprev<cr>zz", {silent = true})
no("n", "]L", "<Cmd>lnfile<cr>zz", {silent = true})
no("n", "[L", "<Cmd>lpfile<cr>zz", {silent = true})
no("", "<Space>q", "<Cmd>b#<CR>", {silent = true})
no("c", "<C-p>", "<Up>")
no("c", "<C-n>", "<Down>")
no("c", "<C-j>", "<C-g>")
no("c", "<C-k>", "<C-t>")
no("c", "<C-a>", "<Home>")
no("i", "<C-o>", "<c-r>=expand(\"%:t:r:r:r\")<cr>")
no("c", "<C-o>", "<c-r>=expand(\"%:t:r:r:r\")<cr>")
no("n", "yo", ":<c-u>let @\"='<c-r>=expand(\"%:t:r:r:r\")<cr>'<cr>", {silent = true})
no("n", "yO", ":<c-u>let @\"='<c-r>=expand(\"%:p\")<cr>'<cr>", {silent = true})
no("n", "<space>t", "<Cmd>tabedit<cr>", {silent = true})
no("n", "\\", "za", {silent = true})
no("n", "cn", "cgn", {silent = true})
no("n", "<space>l", "<Cmd>vsplit<cr>", {silent = true})
no("n", "<space>j", "<Cmd>split<cr>", {silent = true})
no("n", "<space>h", "<Cmd>vsplit<Bar>wincmd", __fnl_global__p_3ccr_3e, {silent = true})
no("n", "<space>k", "<Cmd>split<Bar>wincmd", __fnl_global__p_3ccr_3e, {silent = true})
no("n", "<c-q>", "<Cmd>q<cr>", {silent = true})
return no("n", "g;", "g;zvzz")