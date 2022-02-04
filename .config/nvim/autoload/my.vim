" Taken from junegunn's vimrc
fu! my#inner_comment(vis)
    if synIDattr(synID(line('.'), col('.'), 0), 'name') !~? 'comment'
        return
    endif

    let origin = line('.')
    let lines = []
    for dir in [-1, 1]
        let line = origin
        let line += dir
        while line >= 1 && line <= line('$')
            execute 'normal!' line.'G^'
            if synIDattr(synID(line('.'), col('.'), 0), 'name') !~? 'comment'
                break
            endif
            let line += dir
        endwhile
        let line -= dir
        call add(lines, line)
    endfor

    execute 'normal!' lines[0].'GV'.lines[1].'G'
endfu
