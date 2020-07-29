"
" adapted from https://github.com/lacygoill/vim-session
"

if exists('g:loaded_session')
    finish
endif
let g:loaded_session = 1

augroup my_session | au!
    au StdInReadPost * let s:read_stdin = 1

    au VimEnter * ++nested call s:load_session_on_vimenter()

    au BufWinEnter * exe s:track(0)

    au TabClosed * call timer_start(0, { -> execute('exe ' .. string(function('s:track', [0])) .. '()') })

    au VimLeavePre * exe s:track(1)
        \ | if get(g:, 'MY_LAST_SESSION', '') isnot# ''
        \ |     call writefile([g:MY_LAST_SESSION], $HOME..'/.vim/session/last')
        \ | endif
augroup END

com -bar          -complete=custom,s:suggest_sessions SClose  exe s:close()
com -bar -nargs=? -complete=custom,s:suggest_sessions SDelete exe s:delete(<q-args>)
com -bar -nargs=1 -complete=custom,s:suggest_sessions SRename exe s:rename(<q-args>)

com -bar       -nargs=? -complete=custom,s:suggest_sessions SLoad  exe s:load(<q-args>)
com -bar -bang -nargs=? -complete=file                      STrack exe s:handle_session(<bang>0, <q-args>)

fu s:close() abort
    if !exists('g:my_session') | return '' | endif
    sil STrack
    sil tabonly | sil only | enew
    call s:rename_tmux_window('vim')
    return ''
endfu

fu s:delete(session) abort
    if a:session is# '#'
        if exists('g:MY_PENULTIMATE_SESSION')
            let session_to_delete = g:MY_PENULTIMATE_SESSION
        else
            return 'echoerr "No alternate session to delete"'
        endif
    else
        let session_to_delete = a:session is# ''
            \ ? get(g:, 'my_session', 'MY_LAST_SESSION')
            \ : fnamemodify(s:SESSION_DIR..'/'..a:session..'.vim', ':p')
    endif

    if session_to_delete is# get(g:, 'MY_PENULTIMATE_SESSION', '')
        unlet! g:MY_PENULTIMATE_SESSION
    elseif session_to_delete is# get(g:, 'my_session', '')
        if exists('g:MY_PENULTIMATE_SESSION')
            SLoad#
            unlet! g:MY_PENULTIMATE_SESSION
        else
            SClose
        endif
    endif

    if delete(session_to_delete)
        return 'echoerr '..string('Failed to delete '..session_to_delete)
    endif
    return 'echo '..string(session_to_delete..' has been deleted')
endfu

fu s:handle_session(bang, file) abort
    let s:bang = a:bang
    let s:file = a:file
    let s:last_used_session = get(g:, 'my_session', v:this_session)

    try
        if s:should_pause_session()
            return s:session_pause()
        elseif s:should_delete_session()
            return s:session_delete()
        endif

        let s:file = s:where_do_we_save()
        if s:file is# '' | return '' | endif

        if !s:bang && a:file isnot# '' && filereadable(s:file)
            return 'mksession '..fnameescape(s:file)
        endif

        let g:my_session = s:file

        let error = s:track(0)
        if error is# ''
            echo 'Tracking session in '..fnamemodify(s:file, ':~:.')
            call s:rename_tmux_window(s:file)
            return ''
        else
            return error
        endif

    finally
        redrawt
        redraws!
        unlet! s:bang s:file s:last_used_session
    endtry
endfu

fu s:load(session_file) abort
    let session_file = a:session_file is# ''
           \ ?     get(g:, 'MY_LAST_SESSION', '')
           \ : a:session_file is# '#'
           \ ?     get(g:, 'MY_PENULTIMATE_SESSION', '')
           \ : a:session_file =~# '/'
           \ ?     fnamemodify(a:session_file, ':p')
           \ :     s:SESSION_DIR..'/'..a:session_file..'.vim'

    let session_file = resolve(session_file)

    if session_file is# ''
        return 'echoerr "No session to load"'
    elseif !filereadable(session_file)
        return 'echoerr '..string(printf("%s doesn't exist, or it's not readable", fnamemodify(session_file, ':t')))
    elseif exists('g:my_session') && session_file is# g:my_session
        return 'echoerr '..string(printf('%s is already the current session', fnamemodify(session_file, ':t')))
    else
        let [loaded_elsewhere, file] = s:session_loaded_in_other_instance(session_file)
        if loaded_elsewhere
            return 'echoerr '..string(printf('%s is already loaded in another Vim instance', file))
        endif
    endif

    call s:prepare_restoration(session_file)
    let options_save = s:save_options()

    if exists('g:my_session')
        let g:MY_PENULTIMATE_SESSION = g:my_session
    endif

    call s:tweak_session_file(session_file)
    sil! exe 'so '..fnameescape(session_file)

    if exists('g:my_session')
        let g:MY_LAST_SESSION = g:my_session
    endif

    call s:restore_options(options_save)
    call s:rename_tmux_window(session_file)

    do <nomodeline> WinEnter

    return ''
endfu

fu s:load_session_on_vimenter() abort
    if v:servername isnot# 'VIM' | return | endif

    let file = $HOME..'/.vim/session/last'
    if filereadable(file)
        let g:MY_LAST_SESSION = get(readfile(file), 0, '')
    endif

    if get(g:, 'MY_LAST_SESSION', '') =~# '/default.vim$\|^$'
        return
    endif

    if s:safe_to_load_session()
        exe 'SLoad '..g:MY_LAST_SESSION
    endif
endfu

fu s:prepare_restoration(file) abort
    exe s:track(0)

    sil tabonly | sil only
endfu

fu s:rename(new_name) abort
    let src = g:my_session
    let dst = expand(s:SESSION_DIR..'/'..a:new_name..'.vim')

    if rename(src, dst)
        return 'echoerr '..string('Failed to rename '..src..' to '..dst)
    else
        let g:my_session = dst
        call s:rename_tmux_window(dst)
    endif
    return ''
endfu

fu s:rename_tmux_window(file) abort
    if !exists('$TMUX') | return | endif

    let window_title = fnamemodify(a:file, ':t:r')
    sil call system('tmux rename-window -t '..$TMUX_PANE..' '..shellescape(window_title))

    augroup my_tmux_window_title | au!
        au VimLeavePre * sil call system('tmux set-option -w -t '..$TMUX_PANE..' automatic-rename on')
    augroup END
endfu

fu s:restore_these() abort
    let &l:isk = '!-~,^*,^|,^",192-255,-'
    setl bt=help nobl nofen noma
endfu

fu s:restore_options(dict) abort
    for [op, val] in items(a:dict)
        exe 'let &'..op..' = '..(type(val) == v:t_string ? string(val) : val)
    endfor
endfu

fu s:safe_to_load_session() abort
    return !argc()
      \ && !get(s:, 'read_stdin', 0)
      \ && &errorfile is# 'errors.err'
      \ && filereadable(get(g:, 'MY_LAST_SESSION', s:SESSION_DIR..'/default.vim'))
      \ && !s:session_loaded_in_other_instance(get(g:, 'MY_LAST_SESSION', s:SESSION_DIR..'/default.vim'))[0]

endfu

fu s:save_options() abort
    return {
        \ 'shortmess': &shortmess,
        \ 'splitbelow':  &splitbelow,
        \ 'splitright': &splitright,
        \ 'showtabline': &showtabline,
        \ 'winheight': &winheight,
        \ 'winminheight': &winminheight,
        \ 'winminwidth': &winminwidth,
        \ 'winwidth': &winwidth,
        \ }
endfu

fu s:session_loaded_in_other_instance(session_file) abort
    let buffers = filter(readfile(a:session_file), {_,v -> v =~# '^badd '})

    if buffers ==# [] | return [0, 0] | endif

    call map(buffers, {_,v -> matchstr(v, '^badd +\d\+ \zs.*')})
    call map(buffers, {_,v -> fnamemodify(v, ':p')})

    let swapfiles = map(copy(buffers),
        \    {_,v ->  expand('~/.vim/tmp/swap/')
        \           ..substitute(v, '/', '%', 'g')
        \           ..'.swp'})
    call filter(map(swapfiles, {_,v -> glob(v, 1)}), {_,v -> v isnot# ''})

    let a_file_is_currently_loaded = swapfiles !=# []
    let it_is_not_in_this_session = index(map(buffers, {_,v -> buflisted(v)}), 1) == -1
    let file = get(swapfiles, 0, '')
    let file = fnamemodify(file, ':t:r')
    let file = substitute(file, '%', '/', 'g')
    return [a_file_is_currently_loaded && it_is_not_in_this_session, file]
endfu

fu s:session_delete() abort
    call delete(s:last_used_session)

    unlet! g:my_session

    echo 'Deleted session in '..fnamemodify(s:last_used_session, ':~:.')

    let v:this_session = ''
    return ''
endfu

fu s:session_pause() abort
    echo 'Pausing session in '..fnamemodify(s:last_used_session, ':~:.')
    let g:MY_LAST_SESSION = g:my_session
    unlet g:my_session
    return ''
endfu

fu s:should_delete_session() abort
    return s:bang && s:file is# '' && filereadable(s:last_used_session)
endfu

fu s:should_pause_session() abort
    return !s:bang && s:file is# '' && exists('g:my_session')
endfu

fu session#status() abort
    let state = (v:this_session isnot# '') + exists('g:my_session')
    return ['', '[paused]', '[recording]'][state]
endfu

fu s:suggest_sessions(arglead, _l, _p) abort
    let files = glob(s:SESSION_DIR..'/*'..a:arglead..'*.vim')
    return substitute(files, '[^\n]*\.vim/session/\([^\n]*\)\.vim', '\1', 'g')
endfu

fu s:track(on_vimleavepre) abort

    if exists('g:SessionLoad')
        return ''
    endif

    if exists('g:my_session')
        try
            exe 'mksession! '..fnameescape(g:my_session)

            let g:MY_LAST_SESSION = g:my_session

        catch /^Vim\%((\a\+)\)\=:E\%(788\|11\):/
        catch
            unlet! g:my_session
            redrawt
            redraws!
            return 'echoerr '..string(v:exception)
        endtry
    endif
    return ''
endfu

fu s:tweak_session_file(file) abort
    let body = readfile(a:file)

    call insert(body, 'let g:my_session = v:this_session', -3)
    call insert(body, 'let g:my_session = v:this_session', -3)
    call writefile(body, a:file)
endfu

fu s:vim_quit_and_restart() abort
    if has('gui_running') | echo 'not available in GUI' | return | endif
    sil! update

    let shell_parent_pid = '$(ps -p '..getpid()..' -o ppid=)'
    sil call system('kill -USR1 '..shell_parent_pid)

    qa!
endfu

fu s:where_do_we_save() abort
    if s:file is# ''
        if s:last_used_session is# ''
            if !isdirectory(s:SESSION_DIR)
                call mkdir(s:SESSION_DIR, 'p', 0700)
            endif
            return s:SESSION_DIR..'/default.vim'
        else
            return s:last_used_session
        endif

    elseif isdirectory(s:file)
        echohl ErrorMsg
        echo 'provide the name of a session file; not a directory'
        echohl NONE
        return ''

    else
        return s:file =~# '/'
           \ ?     fnamemodify(s:file, ':p')
           \ :     s:SESSION_DIR..'/'..s:file..'.vim'
    endif
endfu

nno <silent><unique> <space>R :<c-u>call <sid>vim_quit_and_restart()<cr>


set ssop=help,tabpages,winsize

const s:SESSION_DIR = $HOME..'/.vim/session'
