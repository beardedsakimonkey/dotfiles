vim.opt["shada"] = "!,'4096,<50,s10,h"
vim.opt["display"] = "msgsep"
vim.opt["inccommand"] = "nosplit"
vim.opt["lazyredraw"] = true
vim.opt["ttimeout"] = true
vim.opt["ttimeoutlen"] = 0
vim.opt["timeoutlen"] = 3000
vim.opt["mouse"] = "a"
vim.opt["synmaxcol"] = 500
vim.cmd("let &t_8f = \"\\<Esc>[38;2;%lu;%lu;%lum\"")
vim.cmd("let &t_8b = \"\\<Esc>[48;2;%lu;%lu;%lum\"")
do end (vim.opt)["termguicolors"] = true
vim.cmd("let &t_ti.=\"\\<Esc>[2 q\"")
vim.cmd("let &t_SI.=\"\\<Esc>[6 q\"")
vim.cmd("let &t_SR.=\"\\<Esc>[4 q\"")
vim.cmd("let &t_EI.=\"\\<Esc>[2 q\"")
vim.cmd("let &t_te.=\"\\<Esc>[0 q\"")
do end (vim.opt)["hidden"] = true
vim.opt["confirm"] = true
vim.opt["swapfile"] = false
vim.opt["backup"] = false
vim.opt["undofile"] = true
if not vim.fn.isdirectory(vim.go.undodir) then
  vim.fn.mkdir(vim.go.undodir)
end
vim.opt["splitright"] = true
vim.opt["splitbelow"] = true
vim.opt["winminheight"] = 0
vim.opt["winminwidth"] = 0
vim.opt["joinspaces"] = false
vim.opt["autoindent"] = true
vim.opt["shiftround"] = true
vim.opt["smarttab"] = true
vim.opt["expandtab"] = true
vim.opt["shiftwidth"] = 4
vim.opt["tabstop"] = 4
vim.opt["softtabstop"] = -1
vim.opt["hlsearch"] = true
vim.opt["incsearch"] = true
vim.opt["ignorecase"] = true
vim.opt["infercase"] = true
vim.opt["smartcase"] = true
vim.opt["keywordprg"] = ":help"
vim.opt["completeopt"] = {"menuone", "noselect"}
vim.opt["complete"] = {".", "i", "w", "b"}
vim.opt["wildmenu"] = true
vim.opt["wildignorecase"] = true
vim.opt["wildignore"] = {"build/*", "*/node_modules/*"}
vim.opt["foldtext"] = "v:folddashes.getline(v:foldstart)"
vim.opt["foldmethod"] = "indent"
vim.opt["foldlevelstart"] = 99
do end (vim.opt.foldopen):remove("block")
do end (vim.opt)["modeline"] = false
vim.opt["modelines"] = 0
vim.opt["shortmess"] = "filnxtToOfaTWIcFS"
vim.opt["fillchars"] = {eob = " "}
vim.opt["scrolloff"] = 2
vim.opt["sidescrolloff"] = 2
vim.opt["virtualedit"] = "block"
vim.opt["wrap"] = false
vim.opt["number"] = true
vim.opt["signcolumn"] = "auto"
vim.opt["showcmd"] = false
vim.opt["sessionoptions"] = {"help", "tabpages", "winsize", "curdir", "folds"}
vim.opt["laststatus"] = 2
vim.opt["showmode"] = false
vim.opt["showtabline"] = 1
return (vim.opt.formatoptions):remove("t")
