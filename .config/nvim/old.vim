syntax enable
filetype plugin indent on

" if exists('+termguicolors')
"     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"     set termguicolors
" endif

" Show block cursor in Normal mode and line cursor in Insert mode
let &t_ti.="\<Esc>[2 q"
let &t_SI.="\<Esc>[6 q"
let &t_SR.="\<Esc>[4 q"
let &t_EI.="\<Esc>[2 q"
let &t_te.="\<Esc>[0 q"

set keywordprg=:help
set completeopt=menuone,noselect
set complete=.,i,w,b

set wildmenu
set wildignorecase
set wildignore&vim
set wildignore+=build/*,*/node_modules/*

" set foldtext=v:folddashes.getline(v:foldstart)
set foldtext=MyFoldtext()
set foldmethod=indent
set foldlevelstart=99
set foldopen-=block

fu! MyFoldtext()
    return v:folddashes .. ' ' .. (v:foldend - v:foldstart + 1) .. 'ℓ' 
endfu

set nomodeline
set modelines=0

set shortmess&vim
set shortmess+=aTWIcFS
set shortmess-=s

set scrolloff=2
set sidescrolloff=2
set virtualedit=block
set nowrap

set listchars=tab:›\ ,trail:-,nbsp:∅
set fillchars=fold:\ 

set number
set signcolumn=auto
set noshowcmd

set sessionoptions=help,tabpages,winsize,curdir,folds

if executable('rg')
    set grepprg=rg\ -i\ --vimgrep
else
    set grepprg=grep\ --line-number\ --with-filename\ --recursive\ -I\ $*\ /dev/null
endif
set grepformat=%f:%l:%c:%m

" Status Line
set laststatus=2
set noshowmode
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

fu! MyStatusLineNeovim() abort
    let stl_lsp = "%3*%{v:lua.lsp_statusline_no_errors()}"..
                \"%4*%{v:lua.lsp_statusline_has_errors()}%*"
    let post = g:statusline_winid is# win_getid() ? s:stl_sess : ''
    return s:stl_info.."%f "..stl_lsp.."%="..post..' '
endfu

set statusline=%!MyStatusLineNeovim()

" Tab line
set showtabline=1
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
    au BufReadPre * call s:handle_large_buffer()

    fu! s:handle_large_buffer() abort
        let s = getfsize(expand('<afile>'))
        if s > g:LargeFile || s == -2
            call s:large_buf(expand('<afile>:p'))
        endif
    endfu

    let g:LargeFile = 1024*1024 " 1MB

    fu! s:large_buf(name)
        let b:my_large_file = 1
        syntax clear
        set ei=all
        let &backupskip .= ',' . a:name
        setl foldmethod=manual nofoldenable noswapfile noundofile
        aug large_buffer | au!
            au BufWinEnter <buffer> 
                        \ set ei&vim |
                        \ au! large_buffer |
                        \ aug! large_buffer
        aug END
    endfu

    au BufNewFile * call s:maybe_read_template()
                \ | call s:maybe_make_executable()

    fu! s:maybe_make_executable() abort
        au BufWritePost <buffer> ++once call s:make_executable()
    endfu

    fu! s:make_executable() abort
        let shebang = matchstr(getline(1), '^#!\S\+')
        if !empty(shebang)
            sil call system('chmod +x ' .. expand('<afile>:p:S'))
            if v:shell_error
                echohl ErrorMsg
                echom 'Cannot make file executable: ' .. v:shell_error
                echohl None
            endif
        endif
    endfu

    fu! s:maybe_read_template() abort
        for file in glob('~/.vim/templates/*', 0, 1)
            let filetype = fnamemodify(file, ':t:r')
            if filetype is# &ft && filereadable(file)
                exe 'keepalt read' fnameescape(file)
                keepj 1d_
                return
            endif
        endfor
    endfu

    au BufWritePre,FileWritePre * call s:maybe_create_directories()

    fu! s:maybe_create_directories() abort
        if @% !~# '\(://\)'
            call mkdir(expand('<afile>:p:h'), 'p')
        endif
    endfu

    au BufReadPost * call s:maybe_restore_cursor_position()

    fu! s:maybe_restore_cursor_position() abort
        if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            exe 'norm! g`"zvzz'
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

    " Warning: any BufWritePost autocmd after this will not get run when
    " writing vimrc, because sourcing the vimrc will clear the augroup
    au BufWritePost ~/.vim/vimrc exe 'source' expand('<afile>:p')
    au BufWritePost ~/.vim/lua/* exe 'luafile' expand('<afile>:p')
    au BufWritePost */colors/*.vim exe 'so' expand('<afile>:p') | exe (has_key(g:, 'colors_name') ? 'colo ' .. g:colors_name : '')
    au BufWritePost *tmux.conf         
                \ call system('tmux source-file '.expand('<afile>:p')) |
                \ if v:shell_error |
                \     echohl ErrorMsg |
                \     echo 'tmux source-file failed' |
                \     echohl None |
                \ endif
    " au BufWritePost ~/.zsh/overlay.ini call system('fast-theme '.expand('<afile>:p'))

    au TextYankPost * lua vim.highlight.on_yank {higroup="Search", timeout=300, on_visual=false}

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

    au BufWinLeave * if !s:is_special() | call s:save_view() | endif
    au BufWinEnter * if !s:is_special() | call s:restore_view() | endif

    fu s:is_special() abort
        return &ft is# 'gitcommit' || &bt =~# '^\%(quickfix\|terminal\)$'
    endfu

    fu s:save_view() abort
        if !exists('w:saved_views')
            let w:saved_views = {}
        endif
        let w:saved_views[bufnr('%')] = winsaveview()
    endfu 

    fu s:restore_view() abort
        let n = bufnr('%')
        if exists('w:saved_views') && has_key(w:saved_views, n)
            if !&l:diff
                call winrestview(w:saved_views[n])
            endif
            unlet! w:saved_views[n]
        else
            if line("'\"") >= 1 && line("'\"") <= line('$') && &ft !~# 'commit'
                norm! g`"
            endif
        endif
    endfu
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

" no <silent> <space>o <cmd>lua require'my.isearch'.search_oldfiles()<cr>
" no <silent> <space>b <cmd>lua require'my.isearch'.search_buffers()<cr>
" no <silent> <space>f <cmd>lua require'my.isearch'.search_files()<cr>

com! -bar -range CopyDiffusion <line1>,<line2> call my_fb#copy_diffusion_url()

nno <silent> <space>ev :<c-u>edit ~/.config/nvim/init.lua<cr>
" nno <silent> <space>el :<c-u>edit ~/.vim/lua/my<cr>
nno <silent> <space>ep :<c-u>edit ~/.local/share/nvim/site/pack/packer/start<cr>
nno <silent> <space>ez :<c-u>edit ~/.zshrc<cr>
nno <silent> <space>en :<c-u>edit ~/notes/notes.md<cr>
nno <silent> <space>et :<c-u>edit ~/.config/tmux/tmux.conf<cr>
nno <silent> <space>ea :<c-u>edit ~/.config/alacritty/alacritty.yml<cr>

" nno <space>a :<c-u>Grep<space>
" xno <space>a "vy:Grep <c-r>v

ino <expr> <c-y> pumvisible() ? "\<c-y>" : matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

nno <silent> cd :<c-u>cd %:h \| pwd<cr>
nno <space>W :<c-u>w !sudo tee % >/dev/null<cr>
nno <silent> <space>t :<c-u>tabedit<cr>
no  <silent> <space>y y:<c-u>call my_fb#yank(@0)<cr>
nno <silent> \ za
nno <silent> cn cgn

ca ~? ~/

fu! s:map_change_option(...)
    let [key, opt] = a:000[0:1]
    let op = get(a:, 3, 'set '.opt.'!')
    exe 'nno <silent> co'.key.' :'.op.'<cr>'
endfu

call s:map_change_option('n', 'number')
call s:map_change_option('c', 'cursorline')
call s:map_change_option('b', 'background', 'let &background = &background is# "dark" ? "light" : "dark"<bar>redraw')
call s:map_change_option('w', 'wrap')
call s:map_change_option('l', 'hlsearch')
call s:map_change_option('i', 'ignorecase')

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

xno <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xno <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')

nno gqax :%!tidy -q -i -xml -utf8<cr>
nno gqah :%!tidy -q -i -ashtml -utf8<cr>
nno gqaj :%!python -m json.tool<cr>
nno gwaj :call append('$', json_encode(eval(join(getline(1,'$')))))<cr>'[k"_dVgg:%!python -m json.tool<cr>

nno <silent> g> :set nomore<bar>echo repeat("\n",&cmdheight)<bar>40messages<bar>set more<CR>

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

" repeat last edit on all the visually selected lines with dot
xno <silent> . :norm! .<cr>

" text-object comment
" omap <silent> a/ :<C-U>call <SID>inner_comment(0)<CR>

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

" text-object line
ono <silent> iL :<c-u>norm! _vg_<cr>
ono <silent> aL _

let g:loaded_getscriptPlugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_vimball = 1
let g:loaded_zipPlugin = 1
let g:loaded_netrwPlugin = 1
let g:loaded_matchit = 1

let g:did_install_default_menus = 1 " $VIMRUNTIME/menu.vim

let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0

" " nvim-filetree
" pa nvim-filetree
" lua require'filetree'.init()
" nno - :<c-u>Dirvish<cr>
" au vimrc StdinReadPost * let s:has_stdin = 1
" au vimrc VimEnter *
"             \ if !argc() && !has_key(s:, 'has_stdin') && !empty(glob('*', 1, 1)) |
"             \   silent! Filetree |
"             \ endif
" 
" vim-linediff
let g:linediff_buffer_type = 'scratch'
xno <expr> D mode() is# 'V' ? ':Linediff<cr>' : 'D'

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

" vim-exchange
nmap t <Plug>(Exchange)
xmap t <Plug>(Exchange)
nmap tu <Plug>(ExchangeClear)
nmap T <Plug>(ExchangeLine)

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
" 
" com! -bar CheckLsp lua print(vim.inspect(vim.lsp.buf_get_clients()))
" com! -bar RestartLsp call <sid>restartLsp()
" 
" fu! s:restartLsp()
"     lua vim.lsp.stop_client(vim.lsp.get_active_clients())
"     edit
" endfu
" 
" pa completion-nvim
" " set completeopt=menuone,noinsert
" set completeopt=menuone,noselect
" luafile ~/.vim/lua/my/compe.lua
" 

" 
" pa nvim-lspconfig
" luafile ~/.vim/lua/my/lsp.lua
" 
" pa snippets.nvim
" luafile ~/.vim/lua/my/snippets.lua
" 
" " pa nvim-treesitter
" " pa nvim-treesitter-refactor
" " pa nvim-treesitter-textobjects
" " luafile ~/.vim/lua/my/treesitter.lua
" 
" pa snap
" luafile ~/.vim/lua/my/snap.lua

" sil! colo dune

no <silent> <space>d :<C-u>call Kwbd(1)<CR>
