"
" Commit
"
fu my_find#hg_commit()
    let l:source = "hg log "
                \ ."--limit 20 "
                \ ."--color always "
                \ ."--template \"{label('custom.rev',phabdiff)} {desc|strip|firstline}\n\" "
                \ .expand('%')
    let l:cmd = "( ".l:source." ) | " . printf('LINES=%d COLUMNS=%d fzf-tmux -- --ansi ', &lines, &columns)
    let l:output = systemlist(l:cmd)
    redraw!
    if empty(l:output)
        return
    endif
    echom l:output
endfu

" 
" Files
" 
fu s:open_file(outfile, ...)
    let results = filereadable(a:outfile) ? readfile(a:outfile) : []
    silent! call delete(a:outfile)
    wincmd p
    if empty(results) | return | endif
    let [key, file] = results
    if key ==# 'ctrl-s'
        split
    elseif key ==# 'ctrl-l'
        vsplit
    elseif key ==# 'ctrl-t'
        tabnew
    endif
    execute 'edit' fnameescape(file)
endfu

fu s:myc() abort
    let outfile = tempname()
    let cmd = "CLICOLOR_FORCE=1 myc --confirmkey --height 20 2>/dev/tty >" . fnameescape(outfile)
    botright 20new
    if has('nvim')
        call termopen([&shell, &shellcmdflag, cmd], {
                    \ "on_exit": function('s:open_file', [outfile])
                    \ })
    else
        call term_start([&shell, &shellcmdflag, cmd], {
                    \ "term_name": 'myc',
                    \ "curwin": 1,
                    \ "term_finish": "close",
                    \ "exit_cb": function('s:open_file', [outfile])
                    \ })
    endif
endfu

fu my_find#files() abort
    if getcwd() =~# '^/data/users/'.$USER
        call s:myc()
        return
    endif
    if has('nvim')
        lua require'my.isearch'.search_files()
    endif
endfu
