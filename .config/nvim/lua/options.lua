vim["opt"]["shada"] = "!,'20000,<0,s10,:100,/10,@10,f0,h"
vim["opt"]["sessionoptions"] = {"help", "tabpages", "winsize", "curdir", "folds"}
vim["opt"]["lazyredraw"] = true
vim["opt"]["ttimeoutlen"] = 0
vim["opt"]["timeoutlen"] = 3000
vim["opt"]["synmaxcol"] = 500
vim["opt"]["termguicolors"] = true
vim["opt"]["confirm"] = true
vim["opt"]["swapfile"] = false
vim["opt"]["backup"] = false
vim["opt"]["undofile"] = true
if not vim.fn.isdirectory(vim.go.undodir) then
  vim.fn.mkdir(vim.go.undodir)
else
end
vim["opt"]["splitright"] = true
vim["opt"]["splitbelow"] = true
vim["opt"]["winminheight"] = 0
vim["opt"]["winminwidth"] = 0
vim["opt"]["expandtab"] = true
vim["opt"]["autoindent"] = true
vim["opt"]["shiftround"] = true
vim["opt"]["smarttab"] = true
vim["opt"]["shiftwidth"] = 4
vim["opt"]["tabstop"] = 4
vim["opt"]["softtabstop"] = -1
vim["opt"]["hlsearch"] = true
vim["opt"]["incsearch"] = true
vim["opt"]["ignorecase"] = true
vim["opt"]["infercase"] = true
vim["opt"]["smartcase"] = true
vim["opt"]["completeopt"] = {"menu", "menuone", "noselect"}
vim["opt"]["complete"] = {".", "i", "w", "b"}
vim["opt"]["wildmenu"] = true
vim["opt"]["wildignorecase"] = true
vim["opt"]["wildignore"] = {"*.o", "*/node_modules/*"}
vim["opt"]["fileignorecase"] = false
vim["opt"]["foldmethod"] = "expr"
vim["opt"]["foldlevelstart"] = 99
do end (vim.opt.foldopen):remove("block")
do end (vim)["opt"]["foldexpr"] = "nvim_treesitter#foldexpr()"
vim["opt"]["modeline"] = false
vim["opt"]["shortmess"] = "filnxtToOfaTWIcFS"
vim["opt"]["fillchars"] = {eob = " "}
vim["opt"]["list"] = true
vim["opt"]["colorcolumn"] = "+0"
vim["opt"]["scrolloff"] = 2
vim["opt"]["sidescrolloff"] = 2
vim["opt"]["virtualedit"] = "block"
vim["opt"]["wrap"] = false
vim["opt"]["number"] = true
vim["opt"]["showmode"] = false
vim["opt"]["showcmd"] = false
vim["opt"]["textwidth"] = 80
vim["opt"]["cursorline"] = true
vim["opt"]["ruler"] = false
vim["opt"]["jumpoptions"] = "view"
return nil
