" Taken from lacygoill's vimrc
fu! my#diff_orig() abort
    let cole_save = &l:conceallevel
    setl conceallevel=0

    let tempfile = tempname()..'/Original File'
    exe 'vnew '..tempfile
    setl buftype=nofile nobuflisted noswapfile nowrap

    sil 0r ++edit #
    keepj $d_
    setl nomodifiable readonly

    diffthis
    nno <buffer><expr><nowait><silent> q reg_recording() isnot# '' ? 'q' : ':<c-u>q<cr>'
    let &filetype = getbufvar('#', '&ft')

    let s:tmp_partial = function('s:diff_orig_restore_settings', [cole_save])
    aug diff_orig_restore_settings
        au! * <buffer>
        au BufWipeOut <buffer>  call timer_start(0, s:tmp_partial)
    aug END

    exe winnr('#')..'windo diffthis'
    return ''
endfu

fu! s:diff_orig_restore_settings(conceallevel,_) abort
    exe 'setl conceallevel='..a:conceallevel
    diffoff!
    norm! zvzz
    aug! diff_orig_restore_settings
    unlet s:tmp_partial
endfu


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
