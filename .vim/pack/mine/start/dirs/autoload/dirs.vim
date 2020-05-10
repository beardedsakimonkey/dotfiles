let s:srcdir = expand('<sfile>:h:h:p')
let s:noswapfile = (2 == exists(':noswapfile')) ? 'noswapfile' : ''
let s:noau       = 'silent noautocmd keepjumps'
let s:cb_map = {}   " callback map

function! s:msg_error(msg) abort
  redraw | echohl ErrorMsg | echomsg 'dirs:' a:msg | echohl None
endfunction

function! s:suf() abort
  let m = get(g:, 'dirs_mode', 1)
  return type(m) == type(0) && m <= 1 ? 1 : 0
endfunction

" Normalize slashes for safe use of fnameescape(), isdirectory(). Vim bug #541.
function! s:sl(path) abort
  return tr(a:path, '\', '/')
endfunction

function! s:normalize_dir(dir, silent) abort
  let dir = s:sl(a:dir)
  if !isdirectory(dir)
    if !a:silent
      call s:msg_error("invalid directory: '".a:dir."'")
    endif
    return ''
  endif
  " Collapse slashes (except UNC-style \\foo\bar).
  let dir = dir[0] . substitute(dir[1:], '/\+', '/', 'g')
  " Always end with separator.
  return (dir[-1:] ==# '/') ? dir : dir.'/'
endfunction

function! s:parent_dir(dir) abort
  let mod = isdirectory(s:sl(a:dir)) ? ':p:h:h' : ':p:h'
  return s:normalize_dir(fnamemodify(a:dir, mod), 0)
endfunction

if v:version > 703
function! s:globlist(pat) abort
  return glob(a:pat, !s:suf(), 1)
endfunction
else "Vim 7.3 glob() cannot handle filenames containing newlines.
function! s:globlist(pat) abort
  return split(glob(a:pat, !s:suf()), "\n")
endfunction
endif

fun! s:list_dir(dir) abort
  let dir_esc = escape(a:dir, '{}')
  let paths = glob(dir_esc.'*', 0, 1)
        \ + glob(dir_esc.'.[^.]*', 0, 1)
  return map(paths, "fnamemodify(v:val, ':p')")
endf

function! s:set_args(args) abort
  if exists('*arglistid') && arglistid() == 0
    arglocal
  endif
  let normalized_argv = map(argv(), 'fnamemodify(v:val, ":p")')
  for f in a:args
    let i = index(normalized_argv, f)
    if -1 == i
      exe '$argadd '.fnameescape(fnamemodify(f, ':p'))
    elseif 1 == len(a:args)
      exe (i+1).'argdelete'
      syntax clear DirsArg
    endif
  endfor
  echo 'arglist: '.argc().' files'

  " Define (again) DirsArg syntax group.
  exe 'source '.fnameescape(s:srcdir.'/syntax/dirs.vim')
endfunction

function! s:buf_init() abort
  augroup dirs_buflocal
    autocmd! * <buffer>
    autocmd BufEnter,WinEnter <buffer> call <SID>on_bufenter()

    " BufUnload is fired for :bwipeout/:bdelete/:bunload, _even_ if
    " 'nobuflisted'. BufDelete is _not_ fired if 'nobuflisted'.
    " NOTE: For 'nohidden' we cannot reliably handle :bdelete like this.
    if &hidden
      autocmd BufUnload <buffer> call s:on_bufunload()
    endif
  augroup END

  setlocal buftype=nofile noswapfile
endfunction

function! s:on_bufenter() abort
  if bufname('%') is ''  " Something is very wrong. #136
    return
  elseif !exists('b:dirs') || (empty(getline(1)) && 1 == line('$'))
    Dirs %
  elseif 3 != &l:conceallevel
    call s:win_init()
  else
    " Ensure w:dirs for window splits, `:b <nr>`, etc.
    let w:dirs = extend(get(w:, 'dirs', {}), b:dirs, 'keep')
  endif
endfunction

function! s:save_state(d) abort
  " Remember previous ('original') buffer.
  let a:d.prevbuf = s:buf_isvalid(bufnr('%')) || !exists('w:dirs')
        \ ? 0+bufnr('%') : w:dirs.prevbuf
  if !s:buf_isvalid(a:d.prevbuf)
    "If reached via :edit/:buffer/etc. we cannot get the (former) altbuf.
    let a:d.prevbuf = exists('b:dirs') && s:buf_isvalid(b:dirs.prevbuf)
        \ ? b:dirs.prevbuf : bufnr('#')
  endif

  " Remember alternate buffer.
  let a:d.altbuf = s:buf_isvalid(bufnr('#')) || !exists('w:dirs')
        \ ? 0+bufnr('#') : w:dirs.altbuf
  if exists('b:dirs') && (a:d.altbuf == a:d.prevbuf || !s:buf_isvalid(a:d.altbuf))
    let a:d.altbuf = b:dirs.altbuf
  endif

  " Save window-local settings.
  let w:dirs = extend(get(w:, 'dirs', {}), a:d, 'force')
  let [w:dirs._w_wrap, w:dirs._w_cul] = [&l:wrap, &l:cul]
  if has('conceal') && !exists('b:dirs')
    let [w:dirs._w_cocu, w:dirs._w_cole] = [&l:concealcursor, &l:conceallevel]
  endif
endfunction

function! s:win_init() abort
  let w:dirs = extend(get(w:, 'dirs', {}), b:dirs, 'keep')
  setlocal nowrap cursorline

  if has('conceal')
    setlocal concealcursor=nvc conceallevel=2
  endif
endfunction

function! s:on_bufunload() abort
  call s:restore_winlocal_settings()
endfunction

function! s:buf_close() abort
  let d = get(w:, 'dirs', {})
  if empty(d)
    return
  endif

  let [altbuf, prevbuf] = [get(d, 'altbuf', 0), get(d, 'prevbuf', 0)]
  let found_alt = s:try_visit(altbuf, 1)
  if !s:try_visit(prevbuf, 0) && !found_alt
      \ && (1 == bufnr('%') || (prevbuf != bufnr('%') && altbuf != bufnr('%')))
    bdelete
  endif
endfunction

function! s:restore_winlocal_settings() abort
  if !exists('w:dirs') " can happen during VimLeave, etc.
    return
  endif
  if has('conceal') && has_key(w:dirs, '_w_cocu')
    let [&l:cocu, &l:cole] = [w:dirs._w_cocu, w:dirs._w_cole]
  endif
endfunction

function! s:open_selected(splitcmd, bg, line1, line2) abort
  let curbuf = bufnr('%')
  let [curtab, curwin, wincount] = [tabpagenr(), winnr(), winnr('$')]
  let p = (a:splitcmd ==# 'p')  " Preview-mode

  let paths = getline(a:line1, a:line2)
  for path in paths
    let path = s:sl(path)
    if !isdirectory(path) && !filereadable(path)
      call s:msg_error("invalid (access denied?): ".path)
      continue
    endif

    if p  " Go to previous window.
      exe (winnr('$') > 1 ? 'wincmd p|if winnr()=='.winnr().'|wincmd w|endif' : 'vsplit')
    endif

    if isdirectory(path)
      exe (p || a:splitcmd ==# 'edit' ? '' : a:splitcmd.'|') 'Dirs' fnameescape(path)
    else
      exe (p ? 'edit' : a:splitcmd) fnameescape(path)
    endif

    " Return to previous window after _each_ split, else we get lost.
    if a:bg && (p || (a:splitcmd =~# 'sp' && winnr('$') > wincount))
      wincmd p
    endif
  endfor

  if a:bg "return to dirs buffer
    if a:splitcmd ==# 'tabedit'
      exe 'tabnext' curtab '|' curwin.'wincmd w'
    elseif a:splitcmd ==# 'edit'
      execute 'silent keepalt keepjumps buffer' curbuf
    endif
  elseif !exists('b:dirs') && exists('w:dirs')
    call s:set_altbuf(w:dirs.prevbuf)
  endif
endfunction

function! s:is_valid_altbuf(bnr) abort
  return a:bnr != bufnr('%') && bufexists(a:bnr) && empty(getbufvar(a:bnr, 'dirs'))
endfunction

function! s:set_altbuf(bnr) abort
  if !s:is_valid_altbuf(a:bnr) | return | endif

  if has('patch-7.4.605') | let @# = a:bnr | return | endif

  let curbuf = bufnr('%')
  if s:try_visit(a:bnr, 1)
    let noau = bufloaded(curbuf) ? 'noau' : ''
    " Return to the current buffer.
    execute 'silent keepjumps' noau s:noswapfile 'buffer' curbuf
  endif
endfunction

function! s:try_visit(bnr, noau) abort
  if s:is_valid_altbuf(a:bnr)
    " If _previous_ buffer is _not_ loaded (because of 'nohidden'), we must
    " allow autocmds (else no syntax highlighting; #13).
    let noau = a:noau && bufloaded(a:bnr) ? 'noau' : ''
    execute 'silent keepjumps' noau s:noswapfile 'buffer' a:bnr
    return 1
  endif
  return 0
endfunction

if exists('*win_execute')
  " Performs `cmd` in all windows showing `bname`.
  function! s:bufwin_do(cmd, bname) abort
    call map(filter(getwininfo(), {_,v -> a:bname ==# bufname(v.bufnr)}), {_,v -> win_execute(v.winid, s:noau.' '.a:cmd)})
  endfunction
else
  function! s:tab_win_do(tnr, cmd, bname) abort
    exe s:noau 'tabnext' a:tnr
    for wnr in range(1, tabpagewinnr(a:tnr, '$'))
      if a:bname ==# bufname(winbufnr(wnr))
        exe s:noau wnr.'wincmd w'
        exe a:cmd
      endif
    endfor
  endfunction

  function! s:bufwin_do(cmd, bname) abort
    let [curtab, curwin, curwinalt, curheight, curwidth, squashcmds] = [tabpagenr(), winnr(), winnr('#'), winheight(0), winwidth(0), filter(split(winrestcmd(), '|'), 'v:val =~# " 0$"')]
    for tnr in range(1, tabpagenr('$'))
      let [origwin, origwinalt] = [tabpagewinnr(tnr), tabpagewinnr(tnr, '#')]
      for bnr in tabpagebuflist(tnr)
        if a:bname ==# bufname(bnr)
          call s:tab_win_do(tnr, a:cmd, a:bname)
          exe s:noau origwinalt.'wincmd w|' s:noau origwin.'wincmd w'
          break
        endif
      endfor
    endfor
    exe s:noau 'tabnext '.curtab
    exe s:noau curwinalt.'wincmd w|' s:noau curwin.'wincmd w'
    if (&winminheight == 0 && curheight != winheight(0)) || (&winminwidth == 0 && curwidth != winwidth(0))
      for squashcmd in squashcmds
        if squashcmd =~# '^\Cvert ' && winwidth(matchstr('\d\+', squashcmd)) != 0
          \ || squashcmd =~# '^\d' && winheight(matchstr('\d\+', squashcmd)) != 0
          exe s:noau squashcmd
        endif
      endfor
    endif
  endfunction
endif

function! s:buf_render(dir, lastpath) abort
  let bname = bufname('%')
  let isnew = empty(getline(1))

  if !isdirectory(s:sl(bname))
    echoerr 'dirs: fatal: buffer name is not a directory:' bufname('%')
    return
  endif

  if !isnew
    call s:bufwin_do('let w:dirs["_view"] = winsaveview()', bname)
  endif

  setlocal undolevels=-1
  silent keepmarks keepjumps %delete _
  silent keepmarks keepjumps call setline(1, s:list_dir(a:dir))
  if type("") == type(get(g:, 'dirs_mode'))  " Apply user's filter.
    execute get(g:, 'dirs_mode')
  endif
  setlocal undolevels<

  if !isnew
    call s:bufwin_do('call winrestview(w:dirs["_view"])', bname)
  endif

  if !empty(a:lastpath)
    let pat = get(g:, 'dirs_relative_paths', 0) ? fnamemodify(a:lastpath, ':p:.') : a:lastpath
    let pat = empty(pat) ? a:lastpath : pat  " no longer in CWD
    call search('\V\^'.escape(pat, '\').'\$', 'cw')
  endif
  " Place cursor on the tail (last path segment).
  call search('\/\zs[^\/]\+\/\?$', 'c', line('.'))
endfunction

function! s:open_dir(d, reload) abort
  let d = a:d
  let dirname_without_sep = substitute(d._dir, '[\\/]\+$', '', 'g')

  " Vim tends to 'simplify' buffer names. Examples (gvim 7.4.618):
  "     ~\foo\, ~\foo, foo\, foo
  " Try to find an existing buffer before creating a new one.
  let bnr = -1
  for pat in ['', ':~:.', ':~']
    let dir = fnamemodify(d._dir, pat)
    if dir == '' | continue | endif
    let bnr = bufnr('^'.dir.'$')
    if -1 != bnr
      break
    endif
  endfor

  if -1 == bnr
    execute 'silent' s:noswapfile 'edit' fnameescape(d._dir)
  else
    execute 'silent' s:noswapfile 'buffer' bnr
  endif

  " Use :file to force a normalized path.
  " - Avoids ".././..", ".", "./", etc. (breaks %:p, not updated on :cd).
  " - Avoids [Scratch] in some cases (":e ~/" on Windows).
  if s:sl(bufname('%')) !=# d._dir
    execute 'silent '.s:noswapfile.' file ' . fnameescape(d._dir)
  endif

  if !isdirectory(bufname('%'))  " sanity check
    throw 'invalid directory: '.bufname('%')
  endif

  if &buflisted && bufnr('$') > 1
    setlocal nobuflisted
  endif

  call s:set_altbuf(d.prevbuf) "in case of :bd, :read#, etc.

  let b:dirs = exists('b:dirs') ? extend(b:dirs, d, 'force') : d

  call s:buf_init()
  call s:win_init()
  if a:reload || s:should_reload()
    call s:buf_render(b:dirs._dir, get(b:dirs, 'lastpath', ''))
    " Set up Dirs before any other `FileType dirs` handler.
    exe 'source '.fnameescape(s:srcdir.'/ftplugin/dirs.vim')
    setlocal filetype=dirs
    let b:dirs._c = b:changedtick
  endif
endfunction

function! s:should_reload() abort
  if line('$') < 1000 || '' ==# glob(getline('$'),1)
    return empty(getline(1)) && 1 == line('$')
  endif
  redraw | echo 'dirs: showing cached listing ("R" to reload)'
  return 0
endfunction

function! s:buf_isvalid(bnr) abort
  return bufexists(a:bnr) && !isdirectory(s:sl(bufname(a:bnr)))
endfunction

function! dirs#open(...) range abort
  if a:0 > 1
    call s:open_selected(a:1, a:2, a:firstline, a:lastline)
    return
  endif

  let d = {}
  let is_uri    = -1 != match(a:1, '^\w\+:[\/][\/]')
  let from_path = fnamemodify(bufname('%'), ':p')
  let to_path   = fnamemodify(s:sl(a:1), ':p')
  "                                       ^resolves to CWD if a:1 is empty

  let d._dir = filereadable(to_path) ? fnamemodify(to_path, ':p:h') : to_path
  let d._dir = s:normalize_dir(d._dir, is_uri)
  " Fallback to CWD for URIs. #127
  let d._dir = empty(d._dir) && is_uri ? s:normalize_dir(getcwd(), is_uri) : d._dir
  if empty(d._dir)  " s:normalize_dir() already showed error.
    return
  endif

  let reloading = exists('b:dirs') && d._dir ==# b:dirs._dir

  if reloading
    let d.lastpath = ''         " Do not place cursor when reloading.
  elseif !is_uri && d._dir ==# s:parent_dir(from_path)
    let d.lastpath = from_path  " Save lastpath when navigating _up_.
  endif

  call s:save_state(d)
  call s:open_dir(d, reloading)
endfunction

nnoremap <silent> <Plug>(dirs_quit) :<C-U>call <SID>buf_close()<CR>
nnoremap <silent> <Plug>(dirs_arg) :<C-U>call <SID>set_args([getline('.')])<CR>
xnoremap <silent> <Plug>(dirs_arg) :<C-U>call <SID>set_args(getline("'<", "'>"))<CR>

fun! s:interactive(prefix) abort
  let head = expand('%')
  let tail = ''
  let undoseq = []
  let winrestsize = winrestcmd()
  botright 10new
  setlocal buftype=nofile bufhidden=wipe nobuflisted nonumber norelativenumber noswapfile noundofile
        \  nowrap winfixheight foldmethod=manual nofoldenable modifiable noreadonly nospell
        \ conceallevel=2 concealcursor=nvc
  setlocal statusline=%l\ of\ %L
  syntax match DirsPathHead =.*\/\ze[^\/]\+\/\?$= conceal
  syntax match DirsPathTail =[^\/]\+\/$=
  exe 'syntax match DirsSuffix   =[^\/]*\%('
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
endf

fun! s:close_interactive(bufnr, winrestsize)
  wincmd p
  execute "bwipe!" a:bufnr
  exe a:winrestsize
  redraw
  echo "\r"
endf

fun! s:make_needed_dirs(path) abort
  if a:path[-1:] ==# '/' && !isdirectory(a:path)
    call mkdir(a:path, 'p', 0700)
  else
    let head = fnamemodify(a:path, ':p:h')
    if !isdirectory(head)
      call mkdir(head, 'p', 0700)
    endif
  endif
endf

fun! dirs#create() abort
  let path = s:interactive('Create file: ')
  if empty(path) | return | endif
  call s:make_needed_dirs(path)
  " TODO: use :write
  call system('touch '.shellescape(path))
  call dirs#open(expand('%'))
  call search('\V\^'.escape(path, '\').'\$', 'cw')
endf

fun! dirs#copy() abort
  let from = fnamemodify(getline('.'), ':p')
  if empty(from) | return | endif
  let to = s:interactive('Copy file: ')
  if empty(to) | return | endif
  call s:make_needed_dirs(to)
  call system('cp '.shellescape(from).' '.shellescape(to))
  call dirs#open(expand('%'))
endf

fun! dirs#rename() abort
  let from = fnamemodify(getline('.'), ':p')
  if empty(from) | return | endif
  let to = s:interactive('Rename file: ')
  if !to | return | endif
  call s:make_needed_dirs(to)
  call system('mv '.shellescape(from).' '.shellescape(to))
  call dirs#open(expand('%'))
endf

fun! dirs#delete() abort
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
      call dirs#open(expand('%'))
      echo "\r"
    endif
  else
    redraw
    echo "\r"
  endif
endf
