if exists('g:loaded_dirs') || &cp || v:version < 700 || &cpo =~# 'C'
  finish
endif
let g:loaded_dirs = 1

command! -bar -nargs=? -complete=dir Dirs call dirs#open(<q-args>)

function! s:isdir(dir)
  return !empty(a:dir) && (isdirectory(a:dir) ||
    \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
endfunction

augroup dirs
  autocmd!
  " Remove netrw and NERDTree directory handlers.
  autocmd VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif
  autocmd VimEnter * if exists('#NERDTreeHijackNetrw') | exe 'au! NERDTreeHijackNetrw *' | endif
  autocmd BufEnter * if !exists('b:dirs') && <SID>isdir(expand('%'))
    \ | exe 'Dirs %'
    \ | elseif exists('b:dirs') && &buflisted && bufnr('$') > 1 | setlocal nobuflisted | endif
  autocmd FileType dirs if exists('#fugitive') | call FugitiveDetect(@%) | endif
  autocmd ShellCmdPost * if exists('b:dirs') | exe 'Dirs %' | endif
augroup END

nnoremap <silent> <Plug>(dirs_up) :<C-U>exe 'Dirs %:p'.repeat(':h',v:count1)<CR>

highlight default link DirsSuffix   SpecialKey
highlight default link DirsPathTail Directory
highlight default link DirsArg      Todo

if mapcheck('-', 'n') ==# '' && !hasmapto('<Plug>(dirs_up)', 'n')
  nmap - <Plug>(dirs_up)
endif
