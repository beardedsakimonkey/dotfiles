augroup my_reason
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> :ReasonPrettyPrint
augroup END

nnoremap <nowait><buffer><silent> <cr>  :MerlinLocate<cr>
nnoremap <nowait><buffer>            T  :MerlinTypeOf<cr>
nnoremap <nowait><buffer>            U  :MerlinErrorCheck<cr>
nnoremap <nowait><buffer><silent>   ,d  :MerlinDestruct<cr>
nnoremap <nowait><buffer>           ,n  :MerlinGrowEnclosing<cr>
nnoremap <nowait><buffer>           ,m  :MerlinShrinkEnclosing<cr>
nnoremap <nowait><buffer>           ,r  <plug>(MerlinRename)
nnoremap <nowait><buffer>           ,R  <plug>(MerlinRenameAppend)
