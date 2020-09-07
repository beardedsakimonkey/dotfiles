fu s:list_dir(dir) abort
    let dir_esc = escape(a:dir, '{}')
    let paths = glob(dir_esc.'*', 1, 1)
                \ + glob(dir_esc.'.[^.]*', 1, 1)
    return map(paths, "fnamemodify(v:val, ':p')")
endfu

fu s:interactive(prefix) abort
    let head = expand('%')
    let tail = ''
    let undoseq = []
    let winrestsize = winrestcmd()
    botright 10new
    setlocal buftype=nofile bufhidden=wipe nobuflisted nonumber norelativenumber noswapfile noundofile
                \  nowrap winfixheight foldmethod=manual nofoldenable modifiable noreadonly nospell
                \ conceallevel=2 concealcursor=nvc
    setlocal statusline=%l\ of\ %L
    syntax match DirvishPathHead =.*\/\ze[^\/]\+\/\?$= conceal
    syntax match DirvishPathTail =[^\/]\+\/$=
    exe 'syntax match DirvishSuffix   =[^\/]*\%('
                \ . join(map(split(&suffixes, ','), 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'), '\|')
                \ . '\)$='
    let cur_buf = bufnr('%')
    let results = s:list_dir(head)
    call setline(1, results)
    setlocal cursorline
    redraw
    echohl QuickFixLine | echo a:prefix.head | echohl None
    while 1
        let &ro=&ro " Force status line update
        let invalid_pattern = 0
        try
            let ch = getchar()
        catch /^Vim:Interrupt$/  " CTRL-C
            call s:close_interactive(cur_buf, winrestsize)
            return head . tail
        endtry
        if ch ==# "\<bs>" " Backspace
            if tail == ''
                let head = substitute(head, '/[^/]*/$', '/', '')
                let undoseq = []
                silent %delete _
                silent call setline(1, s:list_dir(head))
            else
                let tail = tail[:-2]
                let l:undo = empty(l:undoseq) ? 0 : remove(l:undoseq, -1)
                if l:undo
                    silent undo
                endif
            endif
            norm gg
        elseif ch ==# 0x09 " Tab
            let line = getline('.')
            if empty(line)
                continue
            endif
            let undoseq = [] " FIXME
            if isdirectory(line)
                let head = line
                let tail = ''
                silent %delete _
                silent call setline(1, s:list_dir(head))
            else
                let tail = fnamemodify(line, ':p:t')
            endif
        elseif ch >=# 0x20 " Printable character
            let tail .= nr2char(ch)
            let seq_old = get(undotree(), 'seq_cur', 0)
            try
                execute 'silent keeppatterns g!:\m' . escape(tail, '~\[:') . '\ze[^/]*/\=$:norm "_dd'
            catch /^Vim\%((\a\+)\)\=:E/
                let invalid_pattern = 1
            endtry
            let seq_new = get(undotree(), 'seq_cur', 0)
            call add(undoseq, seq_new != seq_old)
            norm gg
        elseif ch ==# 0x1B " Escape
            call s:close_interactive(cur_buf, winrestsize)
            return 0
        elseif ch ==# 0x0D " Enter
            call s:close_interactive(cur_buf, winrestsize)
            return head . tail
        elseif ch ==# 0x17 " CTRL-W
            let tail = ''
            silent %delete _
            silent call setline(1, s:list_dir(head))
        elseif ch ==# 0x15 " CTRL-U
            let undoseq = []
            let head = '/'
            let tail = ''
            silent %delete _
            silent call setline(1, s:list_dir(head))
        elseif ch ==# "\<up>" || ch ==# 0x0B " CTRL-K
            norm k
        elseif ch ==# "\<down>" || ch ==# 0x0A " CTRL-J
            norm j
        endif
        redraw
        echohl QuickFixLine
        if invalid_pattern
            echon '[Invalid pattern] '
        endif
        echon a:prefix.head
        echohl None
        echon tail
    endwhile
endfu

fu s:close_interactive(bufnr, winrestsize)
    wincmd p
    execute "bwipe!" a:bufnr
    exe a:winrestsize
    redraw
    echo "\r"
endfu

fu s:make_needed_dirs(path) abort
    if a:path[-1:] ==# '/' && !isdirectory(a:path)
        call mkdir(a:path, 'p', 0700)
    else
        let head = fnamemodify(a:path, ':p:h')
        if !isdirectory(head)
            call mkdir(head, 'p', 0700)
        endif
    endif
endfu

fu my_dirvish#create() abort
    let path = s:interactive('Create file: ')
    if empty(path) | return | endif
    call s:make_needed_dirs(path)
    " use :edit instead of `touch` so we trigger BufNewFile
    exe 'e' path
endfu

fu my_dirvish#copy() abort
    let from = fnamemodify(getline('.'), ':p')
    if empty(from) | return | endif
    let to = s:interactive('Copy file: ')
    if empty(to) | return | endif
    call s:make_needed_dirs(to)
    call system('cp '.shellescape(from).' '.shellescape(to))
    call dirvish#open(expand('%'))
endfu

fu my_dirvish#rename() abort
    let from = fnamemodify(getline('.'), ':p')
    if empty(from) | return | endif
    let to = s:interactive('Rename file: ')
    if empty(to) | return | endif
    call s:make_needed_dirs(to)
    call system('mv '.shellescape(from).' '.shellescape(to))
    call dirvish#open(expand('%'))
endfu

fu my_dirvish#delete() abort
    let file = fnamemodify(getline('.'), ':p')
    if empty(file)
        return
    endif
    echohl WarningMsg
    echo 'remove '.shellescape(file).'? (y/n)'
    echohl NONE
    let ch = getchar()
    if nr2char(ch) ==? 'y'
        call system('rm -rf '.shellescape(file))
        redraw
        if v:shell_error
            call s:msg_error('Could not remove' )
        else
            call dirvish#open(expand('%'))
            echo "\r"
        endif
    else
        redraw
        echo "\r"
    endif
endfu
