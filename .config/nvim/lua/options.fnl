(import-macros {: set!} :macros)

;; !     - Save and restore all-caps global variables
;; '4096 - Marks will be remembered for the last 4096 files edited (also the number of `v:oldfiles` stored)
;; <50   - Contents of registers (up to 50 lines each) will be remembered
;; s10   - Items with contents occupying more then 10 KiB are skipped
;; h     - Disable the effect of 'hlsearch' when loading the shada file
(set! shada "!,'4096,<50,s10,h")

(set! display :msgsep)
(set! inccommand :nosplit)

(set! lazyredraw)
(set! ttimeout)
(set! ttimeoutlen 0)

;; Avoid confusing <esc>-key with <a-…>
(set! timeoutlen 3000)
(set! mouse :a)
(set! synmaxcol 500)

(vim.cmd "let &t_8f = \"\\<Esc>[38;2;%lu;%lu;%lum\"")
(vim.cmd "let &t_8b = \"\\<Esc>[48;2;%lu;%lu;%lum\"")
(set! termguicolors)

;; Show block cursor in Normal mode and line cursor in Insert mode
(vim.cmd "let &t_ti.=\"\\<Esc>[2 q\"")
(vim.cmd "let &t_SI.=\"\\<Esc>[6 q\"")
(vim.cmd "let &t_SR.=\"\\<Esc>[4 q\"")
(vim.cmd "let &t_EI.=\"\\<Esc>[2 q\"")
(vim.cmd "let &t_te.=\"\\<Esc>[0 q\"")

(set! hidden)
(set! confirm)
(set! swapfile false)
(set! backup false)
(set! undofile)
(when (not (vim.fn.isdirectory vim.go.undodir))
  (vim.fn.mkdir vim.go.undodir))

(set! splitright)
(set! splitbelow)

(set! winminheight 0)
(set! winminwidth 0)

(set! joinspaces false)

(set! autoindent)
(set! shiftround)
(set! smarttab)
(set! expandtab)
(set! shiftwidth 4)
(set! tabstop 4)
(set! softtabstop -1)

(set! hlsearch)
(set! incsearch)
(set! ignorecase)
(set! infercase)
(set! smartcase)

(set! keywordprg ":help")
(set! completeopt [:menuone :noselect])
(set! complete ["." :i :w :b])

(set! wildmenu)
(set! wildignorecase)
(set! wildignore [:build/* :*/node_modules/*])
(set! fileignorecase false)

(set! foldtext "v:folddashes.getline(v:foldstart)")
(set! foldmethod :indent)
(set! foldlevelstart 99)
(vim.opt.foldopen:remove :block)

(set! modeline false)
(set! modelines 0)

(set! shortmess :filnxtToOfaTWIcFS)
(set! fillchars {:eob " "})

(set! scrolloff 2)
(set! sidescrolloff 2)
(set! virtualedit :block)
(set! wrap false)

(set! number)
(set! signcolumn :auto)
(set! showcmd false)

(set! sessionoptions [:help :tabpages :winsize :curdir :folds])

(set! laststatus 2)
(set! showmode false)
(set! showtabline 1)

(set! textwidth 80)

