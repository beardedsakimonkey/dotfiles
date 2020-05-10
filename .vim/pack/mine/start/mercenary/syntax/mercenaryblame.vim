syn match MercenaryblameBoundary  "^\^"
syn match MercenaryblameBlank     "^\s\+\s\@=" nextgroup=MercenaryblameAuthor skipwhite
syn match MercenaryblameAuthor    "\w\+" nextgroup=MercenaryblameDiff skipwhite
syn match MercenaryblameDiff      "[D0-9]\+" nextgroup=MercenaryblameDate skipwhite
syn match MercenaryblameDate      "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}"
hi def link MercenaryblameAuthor    Keyword
hi def link MercenaryblameDiff      Number
hi def link MercenaryblameChangeset Identifier
hi def link MercenaryblameDate      PreProc
