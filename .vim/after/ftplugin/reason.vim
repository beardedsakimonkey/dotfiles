augroup my_reason
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> :ReasonPrettyPrint
augroup END

nnoremap <nowait><buffer><silent> <cr>  :MerlinLocate<cr>
nnoremap <nowait><buffer>           gh  :MerlinTypeOf<cr>
nnoremap <nowait><buffer><silent>   ,d  :MerlinDestruct<cr>
nnoremap <nowait><buffer>           ,n  :MerlinGrowEnclosing<cr>
nnoremap <nowait><buffer>           ,m  :MerlinShrinkEnclosing<cr>
nnoremap <nowait><buffer>            R  <plug>(MerlinRename)
nnoremap <nowait><buffer>           ,R  <plug>(MerlinRenameAppend)
