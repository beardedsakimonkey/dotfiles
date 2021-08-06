" adapted from $VIMRUNTIME/syntax/diff.vim
syn match DiffDelete    "^-.*"
syn match DiffDelete    "^<.*"
syn match DiffAdd       "^+.*"
syn match DiffAdded     "^>.*"
syn match DiffChange    "^! .*"

syn match diffSubname   " @@..*"ms=s+3 contained
syn match diffLine      "^@.*" contains=diffSubname
syn match diffLine      "^\<\d\+\>.*"
syn match diffLine      "^\*\*\*\*.*"
syn match diffLine      "^---$"

" Some versions of diff have lines like "#c#" and "#d#" (where # is a number)
syn match diffLine      "^\d\+\(,\d\+\)\=[cda]\d\+\>.*"

syn match diffFile      "^diff\>.*"
syn match diffFile      "^+++ .*"
syn match diffFile      "^Index: .*"
syn match diffFile      "^==== .*"
syn match diffOldFile   "^\*\*\* .*"
syn match diffNewFile   "^--- .*"

" Used by git
syn match diffIndexLine "^index \x\x\x\x.*"

syn match diffComment   "^#.*"

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link diffOldFile     diffFile
hi def link diffNewFile     diffFile
hi def link diffIndexLine   PreProc
hi def link diffFile        Type
hi def link diffOnly        Constant
hi def link diffIdentical   Constant
hi def link diffDiffer      Constant
hi def link diffBDiffer     Constant
hi def link diffIsA         Constant
hi def link diffNoEOL       Constant
hi def link diffCommon      Constant
hi def link diffLine        Statement
hi def link diffSubname     PreProc
hi def link diffComment     Comment
