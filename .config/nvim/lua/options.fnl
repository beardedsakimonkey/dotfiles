(import-macros {: opt} :macros)

;; !     - Save and restore all-caps global variables
;; '4096 - Marks will be remembered for the last 4096 files edited (also the number of `v:oldfiles` stored)
;; <50   - Contents of registers (up to 50 lines each) will be remembered
;; s10   - Items with contents occupying more then 10 KiB are skipped
;; h     - Disable the effect of 'hlsearch' when loading the shada file
(opt shada "!,'8192,<50,s10,h")

(opt lazyredraw)
;; Avoid confusing <esc>-key with <a-…>
(opt ttimeoutlen 0)
(opt timeoutlen 3000)

(opt mouse :a)
(opt synmaxcol 500)
(opt termguicolors)

(opt confirm)
(opt swapfile false)
(opt backup false)
(opt undofile)
(when (not (vim.fn.isdirectory vim.go.undodir))
  (vim.fn.mkdir vim.go.undodir))

(opt splitright)
(opt splitbelow)
(opt winminheight 0)
(opt winminwidth 0)

(opt autoindent)
(opt shiftround)
(opt smarttab)
(opt shiftwidth 4)
(opt tabstop 4)
(opt softtabstop -1)

(opt hlsearch)
(opt incsearch)
(opt ignorecase)
(opt infercase)
(opt smartcase)

(opt completeopt [:menu :menuone :noselect])
(opt complete ["." :i :w :b])
(opt wildmenu)
(opt wildignorecase)
(opt wildignore [:*.o :*/node_modules/*])
(opt fileignorecase false)

(opt foldtext "v:folddashes.getline(v:foldstart)")
(opt foldmethod :indent)
(opt foldlevelstart 99)
(vim.opt.foldopen:remove :block)

(opt modeline false)
(opt shortmess :filnxtToOfaTWIcFS)
(opt fillchars {:eob " "})

(opt scrolloff 2)
(opt sidescrolloff 2)
(opt virtualedit :block)
(opt wrap false)
;; (opt wrapscan false)

(opt number)
(opt sessionoptions [:help :tabpages :winsize :curdir :folds])
(opt showmode false)
(opt showcmd false)
(opt textwidth 80)
(opt cursorline)

