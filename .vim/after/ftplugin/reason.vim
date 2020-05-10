augroup my_reason
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> :ReasonPrettyPrint
augroup END

nnoremap <nowait><buffer><silent>           <cr>  :MerlinLocate<cr>
nnoremap <nowait><buffer>                      T  :MerlinTypeOf<cr>
nnoremap <nowait><buffer>                      U  :MerlinErrorCheck<cr>
nnoremap <nowait><buffer><silent> <localleader>d  :MerlinDestruct<cr>
nnoremap <nowait><buffer>         <localleader>n  :MerlinGrowEnclosing<cr>
nnoremap <nowait><buffer>         <localleader>m  :MerlinShrinkEnclosing<cr>
nnoremap <nowait><buffer>         <localleader>r  <plug>(MerlinRename)
nnoremap <nowait><buffer>         <localleader>R  <plug>(MerlinRenameAppend)
