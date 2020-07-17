fun! my_fb#copy_diffusion_url() range
    let f = expand( "%:p" )[len(system("hg root")):]
    let range = line('.')
    if a:lastline - a:firstline > 0
        let range = a:firstline . "-" . a:lastline
    endif
    let url = system("diffusion", f . ":" . range)
    call my_fb#yank(url)
    echomsg "Copied: ".url
endf

fun! my_fb#grep(...) abort
    let cwd = getcwd()
    if cwd =~# '^/data/users/'.$USER.'/www'
        setlocal grepprg=tbgsw\ --color=off\ --limit=100\ --stripdir\ --ignore-case
    elseif cwd =~# '^/data/users/'.$USER.'/fbsource'
        setlocal grepprg=fbgs\ --color=off\ --limit=100\ --stripdir\ --ignore-case
    endif
    let cmd = &grepprg . ' ' . shellescape(a:1)
    if a:0 > 1
        let cmd .=  ' ' . shellescape(expandcmd(a:2))
    endif
    " echom cmd
    let res = system(cmd)
    if empty(res)
        echo 'no results'
    endif
    return res
endf

fun! my_fb#yank(text)
    let escape = system('yank', a:text)
    if v:shell_error
        echoerr escape
    else
        call writefile([escape], '/dev/tty', 'b')
    endif
endf
