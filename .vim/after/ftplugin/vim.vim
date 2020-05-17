setlocal grepprg&
set iskeyword-=#

nnoremap <buffer> T K

nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <buffer> <silent> <cr>  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <buffer> <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <buffer> <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
