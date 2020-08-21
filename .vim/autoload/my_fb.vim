fu my_fb#copy_diffusion_url() range abort
    let f = expand( "%:p" )[len(system("hg root")):]
    let range = line('.')
    if a:lastline - a:firstline > 0
        let range = a:firstline . "-" . a:lastline
    endif
    let url = trim(system("diffusion", f . ":" . range))
    let url = url .. '&blame=1'
    call my_fb#yank(url)
    echomsg "Copied: ".url
endfu

fu my_fb#yank(text) abort
    let escape = system('yank', a:text)
    if v:shell_error
        echoerr escape
        return 0
    else
        call writefile([escape], '/dev/tty', 'b')
        return 1
    endif
endfu
