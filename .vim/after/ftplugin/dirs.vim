setlocal statusline=%f

silent! nunmap <buffer> <c-p>
silent! nunmap <buffer> <c-n>

nnoremap <nowait> <silent> <buffer> t :<c-u>call dirs#open('tabedit', 0)<cr>
xnoremap <nowait> <silent> <buffer> t :<c-u>call dirs#open('tabedit', 0)<cr>

nnoremap <nowait> <silent> <buffer> v :<c-u>call dirs#open('vsplit', 0)<cr>
xnoremap <nowait> <silent> <buffer> v :<c-u>call dirs#open('vsplit', 0)<cr>

nmap     <nowait> <silent> <buffer> h <plug>(dirs_up)
nnoremap <nowait> <silent> <buffer> l :<c-u>call dirs#open('edit', 0)<cr>

nmap     <nowait> <silent> <buffer> q <plug>(dirs_quit)
