if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:nowait = (v:version > 703 ? '<nowait>' : '')

if !hasmapto('<Plug>(dirs_quit)', 'n')
  execute 'nmap '.s:nowait.'<buffer> q <Plug>(dirs_quit)'
endif
if !hasmapto('<Plug>(dirs_arg)', 'n')
  execute 'nmap '.s:nowait.'<buffer> x <Plug>(dirs_arg)'
  execute 'xmap '.s:nowait.'<buffer> x <Plug>(dirs_arg)'
endif

nnoremap <buffer><silent> <Plug>(dirs_up) :<C-U>exe "Dirs %:h".repeat(":h",v:count1)<CR>
if !hasmapto('<Plug>(dirs_up)', 'n')
  execute 'nmap '.s:nowait.'<buffer> - <Plug>(dirs_up)'
endif

execute 'nnoremap '.s:nowait.'<buffer><silent> l    :<C-U>.call dirs#open("edit", 0)<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> <CR> :<C-U>.call dirs#open("edit", 0)<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> v    :<C-U>.call dirs#open("vsplit", 1)<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> s    :<C-U>.call dirs#open("split", 1)<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> p    :<C-U>.call dirs#open("p", 1)<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> dax  :<C-U>arglocal<Bar>silent! argdelete *<Bar>echo "arglist: cleared"<Bar>Dirs %<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> ~    :<C-U>.call dirs#open(expand("~"))<CR>'

execute 'xnoremap '.s:nowait.'<buffer><silent> <CR> :call dirs#open("edit", 0)<CR>'
execute 'xnoremap '.s:nowait.'<buffer><silent> v    :call dirs#open("vsplit", 1)<CR>'
execute 'xnoremap '.s:nowait.'<buffer><silent> s    :call dirs#open("split", 1)<CR>'
execute 'xnoremap '.s:nowait.'<buffer><silent> p    :call dirs#open("p", 1)<CR>'

execute 'nnoremap '.s:nowait.'<buffer><silent> +    :<C-U>.call dirs#create()<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> d    :<C-U>.call dirs#delete()<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> c    :<C-U>.call dirs#copy()<CR>'
execute 'nnoremap '.s:nowait.'<buffer><silent> r    :<C-U>.call dirs#rename()<CR>'

nnoremap <buffer><silent> R :<C-U><C-R>=v:count ? ':let g:dirs_mode='.v:count.'<Bar>' : ''<CR>Dirs %<CR>
nnoremap <buffer><silent>   g?    :help dirs-mappings<CR>

" Buffer-local / and ? mappings to skip the concealed path fragment.
nnoremap <buffer> / /\ze[^\/]*[\/]\=$<Home>
nnoremap <buffer> ? ?\ze[^\/]*[\/]\=$<Home>

" Force autoload if `ft=dirs`
if !exists('*dirs#open')|try|call dirs#open()|catch|endtry|endif
