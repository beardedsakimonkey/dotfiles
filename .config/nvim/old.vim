let s:stl_info = "%1*%{!&modifiable?'  X ':&ro?'  RO ':''}%2*%{&modified?'  + ':''}%* "
let s:stl_sess = "%6*%{session#status()}%*"

lua << END
_G.lsp_statusline_no_errors = function ()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return ''
    end
    local errors = vim.lsp.diagnostic.get_count('Error') or 0
    if errors == 0 then
        return '✔'
    end
    return ''
end
_G.lsp_statusline_has_errors = function ()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return ''
    end
    local errors = vim.lsp.diagnostic.get_count('Error') or 0
    if errors > 0 then
        return '✘'
    end
    return ''
end
END

fu! MyStatusLine() abort
    let stl_lsp = "%3*%{v:lua.lsp_statusline_no_errors()}"..
                \"%4*%{v:lua.lsp_statusline_has_errors()}%*"
    let post = g:statusline_winid is# win_getid() ? s:stl_sess : ''
    return s:stl_info.."%7*%f%* "..stl_lsp.."%="..post..' '
endfu

set statusline=%!MyStatusLine()

" Tab line
set tabline=%!MyTabLine()

fu! MyTabLine()
    let s = ''
    for i in range(1, tabpagenr('$'))
        let s .= i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        let s .= '%'.i.'T %{MyTabLabel('.i.')}'
    endfor
    return s.'%#TabLineFill#%T'
endfu

fu! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let modified = ''
    for b in buflist
        if getbufvar(b, '&modified')
            let modified = '+ '
            break
        endif
    endfor
    let name = fnamemodify(bufname(buflist[tabpagewinnr(a:n) - 1]), ':t:s/^$/[No Name]/')
    return modified.name.' '
endfu

" Autocmds
aug vimrc | au!
    au BufWritePre,FileWritePre * call s:maybe_create_directories()

    fu! s:maybe_create_directories() abort
        if @% !~# '\(://\)'
            call mkdir(expand('<afile>:p:h'), 'p')
        endif
    endfu

    au FileType * call s:setup_formatting()

    " t  - auto-wrap text using textwidth
    set formatoptions-=t

    fu! s:setup_formatting()
        " r  - insert comment leader after hitting <enter>
        " o  - insert comment leader after hitting 'o' or 'O'
        " j  - remove comment leader when joining lines
        " c  - auto-wrap comments using textwidth
        " n  - indent numbered lists specially
        setl formatoptions-=ro
        setl formatoptions+=jcn
        if &textwidth is 0
            setl textwidth=80
        endif
    endfu

    if exists('##TerminalWinOpen')
        au TerminalWinOpen * setl statusline=%f
    elseif exists('##TerminalOpen')
        au TerminalOpen * setl statusline=%f
    elseif exists('##TermOpen')
        au TermOpen * setl statusline=%f
    endif

    au CursorMoved * call HlSearch()
    au InsertEnter * call StopHL()

    fu! HlSearch()
        " bail out if cursor is at top/bottom of window
        let wininfo = getwininfo(win_getid())[0]
        let lnum = getcurpos()[1]
        if lnum == wininfo.botline - &scrolloff || lnum == wininfo.topline + &scrolloff
            return
        endif

        try
            let pos = match(getline('.'), @/, col('.') - 1) + 1
            if pos != col('.')
                call StopHL()
            endif
        catch
            call StopHL()
        endtry
    endfu

    fu! StopHL()
        if !v:hlsearch || mode() isnot# 'n'
            return
        endif
        sil call feedkeys("\<Plug>(StopHL)", 'm')
    endfu

    no <silent> <Plug>(StopHL) :<C-U>nohlsearch<cr>
    no! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]

    au vimrc VimEnter * call s:setup_global_marks()

    fu! s:setup_global_marks()
    endfu

    fu! s:setup_global_mark(mark, file)
        let file = fnamemodify(a:file, ':p')
        if glob(file, 1) is# '' | return | endif
        let buf = bufnr(file, 1)
        " weirdly, setting the mark at column 2 saves as column 1 in shada
        call setpos(a:mark, [buf, 1, 2, 0])
    endfu

    " jump to last cursor position for capital letter marks
    for c in map(range(65, 90), 'nr2char(v:val)')
        exe "nno '"..c.." '"..c..'g`"zvzz'
    endfor
aug END

if !exists('s:SID')
    fu! s:SID() abort
        return str2nr(matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$'))
    endfu
    let s:SID = printf('<SNR>%d_', s:SID())
    delfu s:SID
endif

com! -bar DiffOrig echo s:diff_orig()

fu! s:diff_orig() abort
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

" Mappings

nno <silent> <c-l> :<c-u>call <sid>navigate('l')<cr>
nno <silent> <c-h> :<c-u>call <sid>navigate('h')<cr>
nno <silent> <c-j> :<c-u>call <sid>navigate('j')<cr>
nno <silent> <c-k> :<c-u>call <sid>navigate('k')<cr>

fu s:navigate(dir) abort
    if s:previous_window_is_in_same_direction(a:dir)
        try | wincmd p | catch | endtry
    else
        try | exe 'wincmd ' .. a:dir | catch | endtry
    endif
endfu

fu s:previous_window_is_in_same_direction(dir) abort
    let [cnr, pnr] = [winnr(), winnr('#')]
    if a:dir is# 'h'
        let leftedge_current_window = win_screenpos(cnr)[1]
        let rightedge_previous_window = win_screenpos(pnr)[1] + winwidth(pnr) - 1
        return leftedge_current_window - 1 == rightedge_previous_window + 1
    elseif a:dir is# 'l'
        let rightedge_current_window = win_screenpos(cnr)[1] + winwidth(cnr) - 1
        let leftedge_previous_window = win_screenpos(pnr)[1]
        return rightedge_current_window + 1 == leftedge_previous_window - 1
    elseif a:dir is# 'j'
        let bottomedge_current_window = win_screenpos(cnr)[0] + winheight(cnr) - 1
        let topedge_previous_window = win_screenpos(pnr)[0]
        return bottomedge_current_window + 1 == topedge_previous_window - 1
    elseif a:dir is# 'k'
        let topedge_current_window = win_screenpos(cnr)[0]
        let bottomedge_previous_window = win_screenpos(pnr)[0] + winheight(pnr) - 1
        return topedge_current_window - 1 == bottomedge_previous_window + 1
    endif
endfu

nno <expr> [e <sid>move_line_setup('up')
nno <expr> ]e <sid>move_line_setup('down')

fu! s:move_line_setup(dir) abort
    let s:move_line = {'dir': a:dir, 'count': v:count1}
    let &opfunc = s:SID .. 'move_line'
    return 'g@l'
endfu

fu! s:move_line(_) abort
    let dir = s:move_line.dir
    let count = s:move_line.count
    keepj norm! mv
    exe 'move' (dir is# 'up' ? '--' : '+') .. count
    keepj norm! =`v
endfu

nno <silent> <space>z :<c-u>call <sid>zoom_toggle()<cr>

fu! s:zoom_toggle() abort
    if winnr('$') == 1 | return | endif
    if exists('t:zoom_restore')
        exe t:zoom_restore
        unlet t:zoom_restore
    else
        let t:zoom_restore = winrestcmd()
        wincmd |
        wincmd _
    endif
endfu

nno <expr> <space>. <sid>repeat_last_edit_on_last_changed_text()

fu! s:repeat_last_edit_on_last_changed_text() abort
    " put the last changed text inside the search register, so that we can refer
    " to it with the text-object `gn`
    let changed = getreg('"', 1, 1)
    if empty(changed) | return | endif
    call map(changed, {_,v -> escape(v, '\')})
    if len(changed) == 1
        let pat = changed[0]
    else
        " can't join with real newlines: they would be translated as NULs in the search register
        " we need to join with the *atom* `\n`
        let pat = changed->join('\n')
    endif
    call setreg('/', '\V'..pat, 'c')
    set hlsearch
    return "cgn\<c-@>"
    "          ├────┘
    "          └ insert the previously inserted text and stop insert
endfu

" search only in visual selection
xno <silent> / :<c-u>call <sid>visual_slash()<cr>

fu! s:visual_slash() abort
    if line("'<") == line("'>")
        call feedkeys('gv/', 'in')
    else
        " Do not reselect the visual selection with `gv`.
        "
        " It could make move the end of the selection when you type some pattern
        " which matches inside.  That's not what we want.
        " We want to search  in the last visual selection as  it was defined; we
        " don't want to redefine it in the process.
        call feedkeys('/\%V', 'in')
    endif
endfu

" text-object comment
omap <silent> ac :<C-U>call <SID>inner_comment(0)<CR>

function! s:inner_comment(vis)
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
endfunction

" vim-matchup
let g:matchup_surround_enabled = 1
let g:matchup_transmute_enabled = 1
let g:matchup_matchparen_offscreen = {}
let g:matchup_motion_keepjumps = 1
let g:matchup_matchpref = { 'html': { 'nolists': 1 } }
" Note: matchparen must be enabled for transmutation to work (useful for html)
au vimrc FileType vim,lua,zsh,c,cpp let b:matchup_matchparen_enabled = 0
map <tab> <plug>(matchup-%)

for v in ['g', ']', '[', 'a', 'i']
    exe 'omap '.v.'m <plug>(matchup-'.v.'%)'
endfor
for v in ['g', ']', '[']
    exe 'nmap '.v.'m <plug>(matchup-'.v.'%)'
    exe 'vmap '.v.'m <plug>(matchup-'.v.'%)'
endfor
for v in ['ds', 'cs']
    exe 'nmap '.v.'m <plug>(matchup-'.v.'%)'
endfor

fu! IsCommentaryOpFunc()
    return &operatorfunc ==? matchstr(maparg('<Plug>Commentary', 'n'),
                \ '\c<SNR>\w\+\ze()\|set op\%(erator\)\?func=\zs.\{-\}\ze<cr>')
endfu
let g:matchup_text_obj_linewise_operators = ['d', 'y', 'c', 'v', 'g@,IsCommentaryOpFunc()']

" targets.vim
if has('vim_starting')
    let g:targets_jumpRanges = ''
    let g:targets_aiAI = 'aIAi'
    let g:targets_nl = 'nN'
    au vimrc User targets#mappings#user call targets#mappings#extend({
            \ 's': { '': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
            \             {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
            \             {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}] },
            \ "'": {'quote': [{'d':"'"}, {'d':'"'}]},
            \ 'b': {'pair': [{'o':'(', 'c':')'}]},
            \ })
endif
