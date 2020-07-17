"
" Commit
"
fun! my_find#hg_commit()
    let l:source = "hg log "
                \ ."--limit 20 "
                \ ."--color always "
                \ ."--template \"{label('custom.rev',phabdiff)} {desc|strip|firstline}\n\" "
                \ .expand('%')
    let l:cmd = "( ".l:source." 2>/dev/tty ) | " . printf('LINES=%d COLUMNS=%d fzf-tmux -- --ansi ', &lines, &columns)
    let l:output = systemlist(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; '.l:cmd, &lines))
    redraw!
    if empty(l:output)
        return
    endif
    echom l:output
endf

" 
" Files
" 
fun! s:open_file(outfile, channel, status)
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
endf

fun! s:myc() abort
    let outfile = tempname()
    let cmd = "CLICOLOR_FORCE=1 myc --confirmkey --height 20 2>/dev/tty >" . fnameescape(outfile)
    botright 20split
    call term_start([&shell, &shellcmdflag, l:cmd], {
                \ "term_name": 'myc',
                \ "curwin": 1,
                \ "term_finish": "close",
                \ "exit_cb": function('s:open_file', [outfile])
                \ })
endf

fun! my_find#files() abort
    if getcwd() =~# '^/data/users/'.$USER
        call s:myc()
        return
    endif
endf
