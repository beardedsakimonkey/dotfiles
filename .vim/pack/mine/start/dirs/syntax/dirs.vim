if 'dirs' !=# get(b:, 'current_syntax', 'dirs')
  finish
endif

let s:sep = exists('+shellslash') && !&shellslash ? '\' : '/'
let s:escape = 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'

" Define once (per buffer).
if !exists('b:current_syntax')
  exe 'syntax match DirsPathHead =.*\'.s:sep.'\ze[^\'.s:sep.']\+\'.s:sep.'\?$= conceal'
  exe 'syntax match DirsPathTail =[^\'.s:sep.']\+\'.s:sep.'$='
  exe 'syntax match DirsSuffix   =[^\'.s:sep.']*\%('.join(map(split(&suffixes, ','), s:escape), '\|') . '\)$='
endif

" Define (again). Other windows (different arglists) need the old definitions.
" Do these last, else they may be overridden (see :h syn-priority).
for s:p in argv()
  exe 'syntax match DirsArg ,'.escape(fnamemodify(s:p,':p'),'[,*.^$~\').'$, contains=DirsPathHead'
endfor

let b:current_syntax = 'dirs'
