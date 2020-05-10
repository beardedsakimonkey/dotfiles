silent! nunmap <buffer> <c-p>
silent! nunmap <buffer> <c-n>

nnoremap <nowait> <silent> <buffer> t :<c-u>call dirvish#open('tabedit', 0)<cr>
xnoremap <nowait> <silent> <buffer> t :<c-u>call dirvish#open('tabedit', 0)<cr>

nnoremap <nowait> <silent> <buffer> s :<c-u>call dirvish#open('split', 0)<cr>
xnoremap <nowait> <silent> <buffer> s :<c-u>call dirvish#open('split', 0)<cr>

nnoremap <nowait> <silent> <buffer> v :<c-u>call dirvish#open('vsplit', 0)<cr>
xnoremap <nowait> <silent> <buffer> v :<c-u>call dirvish#open('vsplit', 0)<cr>

nmap     <nowait> <silent> <buffer> h <plug>(dirvish_up)
nnoremap <nowait> <silent> <buffer> l :<c-u>call dirvish#open('edit', 0)<cr>

nmap     <nowait> <silent> <buffer> q gq
nnoremap <nowait> <expr>   <buffer> + ":<c-u>edit ".expand("%:.")
nnoremap <nowait> <expr>   <buffer> m ":<c-u>!mkdir -p ".shellescape(expand("%:."))."<left>"

nnoremap <nowait> <expr>   <buffer> r ":<c-u>!mv ".shellescape(fnamemodify(getline("."),":.")).' '.shellescape(fnamemodify(getline("."),":.:h"))."<left>/"

setlocal statusline=%f
