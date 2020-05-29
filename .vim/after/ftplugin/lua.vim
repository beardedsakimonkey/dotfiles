set omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <buffer> <silent> <cr>  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>