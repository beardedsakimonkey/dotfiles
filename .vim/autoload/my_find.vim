" Interactively filter a list of items as you type, and execute an action on
" the selected item. Sort of a poor man's CtrlP.
"
" input:    either a shell command that sends its output, one item per line,
"           to stdout, or a List of items to be filtered.
fun! my_find#interactively(input, callback, prompt) abort
  let l:filter = ''  " Text used to filter the list
  let l:undoseq = [] " Stack to tell whether to undo when pressing backspace (1 = undo, 0 = do not undo)
  let l:winrestsize = winrestcmd() " Save current window layout
  " botright 10new does not set the right height, e.g., if the quickfix window is open
  botright 1new | 15wincmd +
  setlocal buftype=nofile bufhidden=wipe nobuflisted nonumber norelativenumber noswapfile noundofile
        \  nowrap winfixheight foldmethod=manual nofoldenable modifiable noreadonly nospell
  setlocal statusline=%#CommandMode#%*\ %l\ of\ %L
  syntax match Comment =.*\/\ze[^\/]\+\/\?$=
  let l:cur_buf = bufnr('%') " Store current buffer number
  if type(a:input) ==# 1 " v:t_string
    let l:input = systemlist(a:input)
    call setline(1, l:input)
  else " Assume List
    let l:input = a:input
    call setline(1, l:input)
  endif
  setlocal cursorline
  redraw
  echo '> '
  while 1
    let &ro=&ro " Force status line update
    let l:error = 0 " Set to 1 when pattern is invalid
    try
      let ch = getchar()
    catch /^Vim:Interrupt$/  " CTRL-C
      return s:filter_close(l:cur_buf, '', l:winrestsize)
    endtry
    if ch ==# "\<bs>" " Backspace
      let l:filter = l:filter[:-2]
      let l:undo = empty(l:undoseq) ? 0 : remove(l:undoseq, -1)
      if l:undo
        silent norm u
      endif
      norm gg
    elseif ch >=# 0x20 " Printable character
      let l:filter .= nr2char(ch)
      let l:seq_old = get(undotree(), 'seq_cur', 0)
      try
        execute 'silent keeppatterns g!:\m' . escape(l:filter, '~\[:') . ':norm "_dd'
      catch /^Vim\%((\a\+)\)\=:E/
        let l:error = 1
      endtry
      let l:seq_new = get(undotree(), 'seq_cur', 0)
      call add(l:undoseq, l:seq_new != l:seq_old) " seq_new != seq_old iff buffer has changed
      norm gg
    elseif ch ==# 0x1B " Escape (cancel)
      return s:filter_close(l:cur_buf, '', l:winrestsize)
    elseif ch ==# 0x0D || ch ==# 0x13 || ch ==# 0x0C || ch ==# 0x14 " Enter/CTRL-S/CTRL-L/CTRL-T (accept)
      let l:result = [getline('.')]
      if !empty(l:result[0])
        call s:filter_close(l:cur_buf, nr2char(ch + 64), l:winrestsize)
        call function(a:callback)(l:result)
        return
      endif
    elseif ch ==# 0x15 " CTRL-U (clear)
      call setline(1, l:input)
      let l:undoseq = []
      let l:filter = ''
      redraw
    elseif ch ==# 0x0B || ch ==# "\<up>" " 0x0B == CTRL-K
      norm k
    elseif ch ==# 0x0A || ch ==# "\<down>" " 0x0A == CTRL-J
      norm j
    elseif ch ==# 0x04 " CTRL-D (delete buffer)
      if a:prompt ==# 'Switch buffer'
        let bufnr = split(getline('.'), '\s\+')[0]
        let l:input = filter(l:input, 'v:val !~# "'.bufnr.'\\s"')
        execute 'keeppatterns g/\m^\s*' . bufnr . '\s\+/norm "_dd'
        execute "bdelete" bufnr
      endif
    endif
    redraw
    echo (l:error ? '[Invalid pattern] ' : '').'> ' l:filter
  endwhile
endf

fun! s:filter_close(bufnr, action, winrestsize)
  " Move to previous window, wipe search buffer, and restore window layout
  wincmd p
  execute "bwipe!" a:bufnr
  exe a:winrestsize
  if a:action ==# 'S'
    split
  elseif a:action ==# 'L'
    vsplit
  elseif a:action ==# 'T'
    tabnew
  endif
  redraw
  echo "\r"
endf


"
" Buffer
"
fun! s:switch_to_buffer(buffers)
  execute "buffer" split(a:buffers[0], '\s\+')[0]
endf

fun! my_find#buffer()
  let l:buffers = reverse(map(split(execute('ls'), "\n"), { i,v -> substitute(v, '"\(.*\)"\s*line\s*\d\+$', '\1', '') }))
  call my_find#interactively(l:buffers, 's:switch_to_buffer', 'Switch buffer')
endf


"
" Old files
"
fun! s:edit_file(files)
  execute "edit" a:files[0]
endf

fun! my_find#oldfiles()
  call my_find#interactively(v:oldfiles[:99], 's:edit_file', 'Oldfiles')
endf

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
  if has('nvim')
    call my_find#interactively('fd --max-depth 10 --type f', 's:edit_file', 'File')
    return
  endif
  if getcwd() =~# '^/data/users/sinap/'
    call s:myc()
    return
  endif
  let source = "fd --max-depth 10 --type f"
  let outfile = tempname()
  let cmd = "( ".source." 2>/dev/tty ) | " . printf('LINES=%d COLUMNS=%d fzf --height 20 --expect=ctrl-s,ctrl-l,ctrl-t --ansi > %s', &lines, &columns, outfile)
  botright 20split
  call term_start([&shell, &shellcmdflag, cmd], {
        \ "term_name": 'find',
        \ "curwin": 1,
        \ "term_finish": "close",
        \ "exit_cb": function('s:open_file', [outfile])
        \ })
endf
