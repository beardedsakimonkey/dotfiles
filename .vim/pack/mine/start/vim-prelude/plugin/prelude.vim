if exists('g:loaded_prelude')
    finish
endif
let g:loaded_prelude = 1

aug prelude | au!
    au StdinReadPost * let s:has_stdin = 1
    au VimEnter *
                \ if !argc() && !has_key(s:, 'has_stdin') && !empty(glob('*', 1, 1)) |
                \   call s:init() |
                \ endif
aug END

fu s:init() abort
    set bufhidden=wipe
    set buftype=nofile
    call setline(1, "welcome!")
    set nomodified
endfu
