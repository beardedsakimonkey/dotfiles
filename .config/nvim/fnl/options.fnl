(module options)

; !     - Save and restore all-caps global variables
; '1000 - Marks will be remembered for the last 200 files edited (also the number of `v:oldfiles` stored)
; <50   - Contents of registers (up to 50 lines each) will be remembered
; s10   - Items with contents occupying more then 10 KiB are skipped
; h     - Disable the effect of 'hlsearch' when loading the shada file
(set vim.go.shada "!,'1000,<50,s10,h")

(set vim.go.display :msgsep)
(set vim.go.inccommand :nosplit)

(set vim.go.lazyredraw true)
(set vim.go.ttimeout true)
(set vim.go.ttimeoutlen 0)

; avoid confusing <esc>-key with <a-…>
(set vim.go.timeoutlen 3000)
(set vim.go.mouse :a)
(set vim.go.synmaxcol 500)

(vim.cmd "let &t_8f = \"\\<Esc>[38;2;%lu;%lu;%lum\"")
(vim.cmd "let &t_8b = \"\\<Esc>[48;2;%lu;%lu;%lum\"")
(set vim.go.termguicolors true)

; Show block cursor in Normal mode and line cursor in Insert mode
(vim.cmd "let &t_ti.=\"\\<Esc>[2 q\"")
(vim.cmd "let &t_SI.=\"\\<Esc>[6 q\"")
(vim.cmd "let &t_SR.=\"\\<Esc>[4 q\"")
(vim.cmd "let &t_EI.=\"\\<Esc>[2 q\"")
(vim.cmd "let &t_te.=\"\\<Esc>[0 q\"")

(set vim.go.hidden true)
(set vim.go.confirm true)
(set vim.go.swapfile false)
(set vim.go.backup false)
(set vim.go.undofile true)
(when (not (vim.fn.isdirectory vim.go.undodir))
  (vim.cmd "call mkdir(&undodir, 'p', 0700)"))

(set vim.go.splitright true)
(set vim.go.splitbelow true)

(set vim.go.winminheight 0)
(set vim.go.winminwidth 0)

(set vim.go.joinspaces false)

(set vim.bo.autoindent true)
(set vim.go.shiftround true)
(set vim.go.smarttab true)
(set vim.bo.expandtab true)
(set vim.bo.shiftwidth 4)
(set vim.bo.tabstop 4)
(set vim.bo.softtabstop -1)

(set vim.go.hlsearch true)
(set vim.go.incsearch true)
(set vim.go.ignorecase true)
(set vim.bo.infercase true)
(set vim.go.smartcase true)

; set keywordprg=:help
; set completeopt=menuone,noselect
; set complete=.,i,w,b
; 
; set wildmenu
; set wildignorecase
; set wildignore&vim
; set wildignore+=build/*,*/node_modules/*
; 
; " set foldtext=v:folddashes.getline(v:foldstart)
; set foldtext=MyFoldtext()
; set foldmethod=indent
; set foldlevelstart=99
; set foldopen-=block
; 
; fu! MyFoldtext()
;     return v:folddashes .. ' ' .. (v:foldend - v:foldstart + 1) .. 'ℓ'
; endfu
; 
; set nomodeline
; set modelines=0
; 
; set shortmess&vim
; set shortmess+=aTWIcFS
; set shortmess-=s
; 
; set scrolloff=2
; set sidescrolloff=2
; set virtualedit=block
; set nowrap
; 
; set listchars=tab:›\ ,trail:-,nbsp:∅
; set fillchars=fold:\
; 
; set number
; set signcolumn=auto
; set noshowcmd
; 
; set sessionoptions=help,tabpages,winsize,curdir,folds
; 
; if executable('rg')
;     set grepprg=rg\ -i\ --vimgrep
; else
;     set grepprg=grep\ --line-number\ --with-filename\ --recursive\ -I\ $*\ /dev/null
; endif
; set grepformat=%f:%l:%c:%m
; 
; " Status Line
; set laststatus=2
; set noshowmode

