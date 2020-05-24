setlocal statusline=%f

silent! nunmap <buffer> <c-p>
silent! nunmap <buffer> <c-n>

nnoremap <buffer> <nowait> <silent> t :<c-u>.call dirvish#open('tabedit', 0)<cr>
xnoremap <buffer> <nowait> <silent> t :<c-u>.call dirvish#open('tabedit', 0)<cr>

nnoremap <buffer> <nowait> <silent> v :<c-u>.call dirvish#open('vsplit', 0)<cr>
xnoremap <buffer> <nowait> <silent> v :call dirvish#open('vsplit', 0)<cr>

nnoremap <buffer> <nowait> <silent> s :<c-u>.call dirvish#open("split", 1)<cr>
xnoremap <buffer> <nowait> <silent> s :call dirvish#open("split", 1)<cr>

nmap     <buffer> <nowait> <silent> h <Plug>(dirvish_up)
nnoremap <buffer> <nowait> <silent> l :<c-u>call dirvish#open('edit', 0)<cr>

nmap     <buffer> <nowait> <silent> q <Plug>(dirvish_quit)
nnoremap <buffer> <nowait> <silent> ~ :<c-u>.call dirvish#open(expand("~"))<cr>

nnoremap <buffer> <nowait> <silent> + :<c-u>.call my_dirvish#create()<cr>
nnoremap <buffer> <nowait> <silent> d :<c-u>.call my_dirvish#delete()<cr>
nnoremap <buffer> <nowait> <silent> c :<c-u>.call my_dirvish#copy()<cr>
nnoremap <buffer> <nowait> <silent> r :<c-u>.call my_dirvish#rename()<cr>
