setl stl=%f

sil! nun <buffer> <c-p>
sil! nun <buffer> <c-n>

nno <buffer> <nowait> <silent> t :<c-u>.call dirvish#open('tabedit', 0)<cr>
xno <buffer> <nowait> <silent> t :call dirvish#open('tabedit', 0)<cr>

nno <buffer> <nowait> <silent> v :<c-u>.call dirvish#open('vsplit', 1)<bar>call feedkeys("\<Plug>(dirvish_quit)")<cr>
xno <buffer> <nowait> <silent> v :call dirvish#open('vsplit', 0)<cr>

nno <buffer> <nowait> <silent> s :<c-u>.call dirvish#open("split", 1)<bar>call feedkeys("\<Plug>(dirvish_quit)")<cr>
xno <buffer> <nowait> <silent> s :call dirvish#open("split", 1)<cr>

nmap <buffer> <nowait> <silent> h <Plug>(dirvish_up)
nno <buffer> <nowait> <silent> l :<c-u>call dirvish#open('edit', 0)<cr>

nmap     <buffer> <nowait> <silent> q <Plug>(dirvish_quit)
nno <buffer> <nowait> <silent> ~ :<c-u>.call dirvish#open(expand("~"))<cr>

nno <buffer> <nowait> <silent> + :<c-u>call my_dirvish#create()<cr>
nno <buffer> <nowait> <silent> d :<c-u>call my_dirvish#delete()<cr>
nno <buffer> <nowait> <silent> c :<c-u>call my_dirvish#copy()<cr>
nno <buffer> <nowait> <silent> r :<c-u>call my_dirvish#rename()<cr>

nno <buffer> <nowait> <silent> C :<c-u>lcd %<cr>
