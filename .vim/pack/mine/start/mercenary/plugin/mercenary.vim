if exists('g:loaded_mercenary')
  finish
endif
let g:loaded_mercenary = 1

" Section: Vim Utilities
fun! s:clsinit(properties, cls) abort
  let proto_ref = {}
  for name in keys(a:cls)
    let proto_ref[name] = a:cls[name]
  endfor
  return extend(a:properties, proto_ref, "keep")
endf

fun! s:shellslash(path)
  if exists('+shellslash') && !&shellslash
    return s:gsub(a:path,'\\','/')
  else
    return a:path
  endif
endf

fun! s:sub(str,pat,rep) abort
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endf

fun! s:gsub(str,pat,rep) abort
  return substitute(a:str,'\v\C'.a:pat,a:rep,'g')
endf

fun! s:shellesc(arg) abort
  if a:arg =~ '^[A-Za-z0-9_/.-]\+$'
    return a:arg
  elseif &shell =~# 'cmd'
    return '"'.s:gsub(s:gsub(a:arg, '"', '""'), '\%', '"%"').'"'
  else
    return shellescape(a:arg)
  endif
endf

fun! s:warn(str)
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endf

" Section: Mercenary Utilities
let s:mercenary_commands = []
fun! s:add_command(definition) abort
  let s:mercenary_commands += [a:definition]
endf

fun! s:extract_hg_root_dir(path) abort
  if s:shellslash(a:path) =~# '^mercenary://.*//'
    return matchstr(s:shellslash(a:path), '\C^mercenary://\zs.\{-\}\ze//')
  endif
  let root = s:shellslash(simplify(fnamemodify(a:path, ':p:s?[\/]$??')))
  let prev = ''
  while root !=# prev
    let dirpath = s:sub(root, '[\/]$', '') . '/.hg'
    let type = getftype(dirpath)
    if type != ''
      return root
    endif
    let prev = root
    let root = fnamemodify(root, ':h')
  endwhile
  return ''
endf

fun! s:gen_mercenary_path(method, ...) abort
  return 'mercenary://' . s:repo().root_dir . '//' . a:method . ':' . join(a:000, '//')
endf

" Section: Repo
let s:repo_cache = {}
fun! s:repo(...)
  if !a:0
    return s:buffer().repo()
  endif
  let root_dir = a:1
  if !has_key(s:repo_cache, root_dir)
    let s:repo_cache[root_dir] = s:Repo.new(root_dir)
  endif
  return s:repo_cache[root_dir]
endf

let s:Repo = {}
fun! s:Repo.new(root_dir) dict abort
  let repo = {
        \"root_dir" : a:root_dir
        \}
  return s:clsinit(repo, self)
endf

fun! s:Repo.hg_command(...) dict abort
  return 'cd ' . self.root_dir . ' && hg ' . join(map(copy(a:000), 's:shellesc(v:val)'), ' ')
endf

" Section: Buffer
let s:buffer_cache = {}
fun! s:buffer(...)
  let bufnr = a:0 ? a:1 : bufnr('%')
  if !has_key(s:buffer_cache, bufnr)
    let s:buffer_cache[bufnr] = s:Buffer.new(bufnr)
  endif
  return s:buffer_cache[bufnr]
endf

let s:Buffer = {}
fun! s:Buffer.new(number) dict abort
  let buffer = {
        \"_number" : a:number
        \}
  return s:clsinit(buffer, self)
endf

fun! s:Buffer.path() dict abort
  return fnamemodify(bufname(self.bufnr()), ":p")
endf

fun! s:Buffer.relpath() dict abort
  return fnamemodify(self.path(), ':.')
endf

fun! s:Buffer.bufnr() dict abort
  return self["_number"]
endf

fun! s:Buffer.enable_mercenary_commands() dict abort
  for command in s:mercenary_commands
    exe 'command! -buffer '.command
  endfor
endf

fun! s:Buffer.repo() dict abort
  return s:repo(s:extract_hg_root_dir(self.path()))
endf

fun! s:Buffer.onwinleave(cmd) dict abort
  call setwinvar(bufwinnr(self.bufnr()), 'mercenary_bufwinleave', a:cmd)
endf

fun! s:Buffer_winleave(bufnr) abort
  execute getwinvar(bufwinnr(a:bufnr), 'mercenary_bufwinleave')
endf

augroup mercenary_buffer
  autocmd!
  autocmd BufWinLeave * call s:Buffer_winleave(str2nr(expand('<abuf>')))
augroup END

" Section: HGblame
fun! s:Blame() abort
  let hg_args = ['blame', '--user', '--changeset', '--phabdiff', '--date', '-q']
  let hg_args += ['--', s:buffer().path()]
  let hg_blame_command = call(s:repo().hg_command, hg_args, s:repo())
  let temppath = resolve(tempname())
  let outfile = temppath . '.mercenaryblame'
  let errfile = temppath . '.err'
  silent! execute '!' . hg_blame_command . ' > ' . outfile . ' 2> ' . errfile
  let source_bufnr = s:buffer().bufnr()
  let restore = 'call setwinvar(bufwinnr(' . source_bufnr . '), "&scrollbind", 0)'
  if &l:wrap
    let restore .= '|call setwinvar(bufwinnr(' . source_bufnr . '), "&wrap", 1)'
  endif
  if &l:foldenable
    let restore .= '|call setwinvar(bufwinnr(' . source_bufnr . '), "&foldenable", 1)'
  endif
  let top = line('w0') + &scrolloff
  let current = line('.')
  setlocal scrollbind nowrap nofoldenable
  exe 'keepalt leftabove vsplit ' . outfile
  setlocal nomodified nomodifiable nonumber scrollbind nowrap foldcolumn=0 nofoldenable filetype=mercenaryblame
  call s:buffer().onwinleave(restore)
  execute top
  normal! zt
  execute current
  syncbind
  let blame_column_count = strlen(matchstr(getline('.'), '[^:]*:')) - 1
  execute "vertical resize " . blame_column_count
  redraw!
endf
call s:add_command("HGblame call s:Blame()")

augroup mercenary_blame
  autocmd!
  autocmd BufReadPost *.mercenaryblame setfiletype mercenaryblame
  autocmd FileType mercenaryblame      call s:BlameFileType()
augroup END

fun! s:BlameFileType()
  setlocal nomodeline
  setlocal foldmethod=manual
  nnoremap <buffer> <silent> q    :<c-u>bdelete<cr>
  nnoremap <buffer> <silent> gq   :<c-u>bdelete<cr>
  nnoremap <buffer> <silent> <cr> :<c-u>exe <sid>BlameCommit("bdelete<bar>edit")<cr>
  nnoremap <buffer> <silent> i    :<c-u>exe <sid>BlameCommit("bdelete<bar>edit")<cr>
  nnoremap <buffer> <silent> o    :<c-u>exe <sid>BlameCommit("split")<cr>
  nnoremap <buffer> <silent> O    :<c-u>exe <sid>BlameCommit("tabedit")<cr>
  nnoremap <buffer> <silent> p    :<c-u>exe <sid>BlameCommit("pedit")<cr>
endf

fun! s:BlameCommit(cmd) abort
  let line = getline('.')
  let rev = matchstr(line, '^\s*\w\+\s\zs\x\+')
  " HACK: grab the hg root from the previous window
  wincmd p
  let root_dir = s:repo().root_dir
  if a:cmd !~# "split"
    wincmd p
  endif
  let path = 'mercenary://' . root_dir . '//show:' . rev
  execute a:cmd.' '.path
endf

" Section: Routing
let s:method_handlers = {}

fun! s:route(path) abort
  let hg_root_dir = s:extract_hg_root_dir(a:path)
  if hg_root_dir == ''
    return
  endif
  let mercenary_spec = matchstr(s:shellslash(a:path), '\C^mercenary://.\{-\}//\zs.*')
  if mercenary_spec != ''
    let method = matchstr(mercenary_spec, '\C.\{-\}\ze:')
    let args = split(matchstr(mercenary_spec, '\C:\zs.*'), '//')
    try
      if has_key(s:method_handlers, method)
        call call(s:method_handlers[method], args, s:method_handlers)
      else
        call s:warn('mercenary: unknown mercenary:// method ' . method)
      endif
    catch /^Vim\%((\a\+)\)\=:E118/
      call s:warn("mercenary: Too many arguments to mercenary://" . method)
    catch /^Vim\%((\a\+)\)\=:E119/
      call s:warn("mercenary: Not enough argument to mercenary://" . method)
    endtry
  end
  call s:buffer().enable_mercenary_commands()
endf

augroup mercenary
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:route(expand('<amatch>:p'))
augroup END

" Section: HGcat
fun! s:Cat(rev, path) abort
  execute 'edit ' . s:gen_mercenary_path('cat', a:rev, a:path)
endf
call s:add_command("-nargs=+ -complete=file HGcat call s:Cat(<f-args>)")

" mercenary://root_dir//cat:rev//filepath
fun! s:method_handlers.cat(rev, filepath) dict abort
  let args = ['cat', '--rev', a:rev, a:filepath]
  let hg_cat_command = call(s:repo().hg_command, args, s:repo())
  let temppath = resolve(tempname())
  let outfile = temppath . '.out'
  let errfile = temppath . '.err'
  silent! execute '!' . hg_cat_command . ' > ' . outfile . ' 2> ' . errfile
  silent! execute '0read ' . outfile
  setlocal nomodified nomodifiable readonly
  if &bufhidden ==# ''
    setlocal bufhidden=delete
  endif
endf

" :HGshow
fun! s:Show(rev) abort
  execute 'edit ' . s:gen_mercenary_path('show', a:rev)
endf
call s:add_command("-nargs=1 HGshow call s:Show(<f-args>)")


" mercenary://root_dir//show:rev
fun! s:method_handlers.show(rev) dict abort
  let args = ['log', '--stat', '-vpr', a:rev]
  let hg_log_command = call(s:repo().hg_command, args, s:repo())
  let temppath = resolve(tempname())
  let outfile = temppath . '.out'
  let errfile = temppath . '.err'
  silent! execute '!' . hg_log_command . ' > ' . outfile . ' 2> ' . errfile
  silent! execute '0read ' . outfile
  setlocal nomodified nomodifiable readonly
  setlocal filetype=diff
  if &bufhidden ==# ''
    setlocal bufhidden=delete
  endif
endf

" Section: HGdiff
fun! s:Diff(...) abort
  if a:0 == 0
    let merc_p1_path = s:gen_mercenary_path('cat', 'p1()', s:buffer().relpath())
    silent! execute 'keepalt leftabove vsplit ' . merc_p1_path
    diffthis
    wincmd p
    let hg_parent_check_log_cmd = s:repo().hg_command('log', '--rev', 'p2()')
    if system(hg_parent_check_log_cmd) != ''
      let merc_p2_path = s:gen_mercenary_path('cat', 'p2()', s:buffer().relpath())
      silent! execute 'keepalt rightbelow vsplit ' . merc_p2_path
      diffthis
      wincmd p
    endif
    diffthis
  elseif a:0 == 1
    let rev = a:1
    let merc_path = s:gen_mercenary_path('cat', rev, s:buffer().relpath())
    silent! execute 'keepalt leftabove vsplit ' . merc_path
    diffthis
    wincmd p
    diffthis
  endif
endf
call s:add_command("-nargs=? HGdiff call s:Diff(<f-args>)")
