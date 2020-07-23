aug my_reason | au! * <buffer>
  au BufWritePre <buffer> :ReasonPrettyPrint
aug END

nno <nowait> <buffer> <silent> <cr>  :MerlinLocate<cr>
nno <nowait> <buffer>            gh  :MerlinTypeOf<cr>
nno <nowait> <buffer> <silent>   ,d  :MerlinDestruct<cr>
nno <nowait> <buffer>            ,n  :MerlinGrowEnclosing<cr>
nno <nowait> <buffer>            ,m  :MerlinShrinkEnclosing<cr>
nno <nowait> <buffer>             R  <plug>(MerlinRename)
nno <nowait> <buffer>            ,R  <plug>(MerlinRenameAppend)
