let s:stl_info = "%1*%{!&modifiable?'  X ':&ro?'  RO ':''}%2*%{&modified?'  + ':''}%* "
let s:stl_sess = "%6*%{session#status()}%*"

lua << END
_G.lsp_statusline_no_errors = function ()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return ''
    end
    local errors = vim.lsp.diagnostic.get_count('Error') or 0
    if errors == 0 then
        return '✔'
    end
    return ''
end
_G.lsp_statusline_has_errors = function ()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return ''
    end
    local errors = vim.lsp.diagnostic.get_count('Error') or 0
    if errors > 0 then
        return '✘'
    end
    return ''
end
END

fu! MyStatusLine() abort
    let stl_lsp = "%3*%{v:lua.lsp_statusline_no_errors()}"..
                \"%4*%{v:lua.lsp_statusline_has_errors()}%*"
    let rhs = g:statusline_winid is# win_getid() ? s:stl_sess : ''
    return s:stl_info.."%7*%f%* "..stl_lsp.."%="..rhs..' '
endfu

set statusline=%!MyStatusLine()

" Tab line
set tabline=%!MyTabLine()

fu! MyTabLine()
    let s = ''
    for i in range(1, tabpagenr('$'))
        let s .= i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        let s .= '%'.i.'T %{MyTabLabel('.i.')}'
    endfor
    return s.'%#TabLineFill#%T'
endfu

fu! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let modified = ''
    for b in buflist
        if getbufvar(b, '&modified')
            let modified = '+ '
            break
        endif
    endfor
    let name = fnamemodify(bufname(buflist[tabpagewinnr(a:n) - 1]), ':t:s/^$/[No Name]/')
    return modified.name.' '
endfu

" Autocmds
aug vimrc | au!
    au CursorMoved * call HlSearch()
    au InsertEnter * call StopHL()

    fu! HlSearch()
        " bail out if cursor is at top/bottom of window
        let wininfo = getwininfo(win_getid())[0]
        let lnum = getcurpos()[1]
        if lnum == wininfo.botline - &scrolloff || lnum == wininfo.topline + &scrolloff
            return
        endif

        try
            let pos = match(getline('.'), @/, col('.') - 1) + 1
            if pos != col('.')
                call StopHL()
            endif
        catch
            call StopHL()
        endtry
    endfu

    fu! StopHL()
        if !v:hlsearch || mode() isnot# 'n'
            return
        endif
        sil call feedkeys("\<Plug>(StopHL)", 'm')
    endfu

    no <silent> <Plug>(StopHL) :<C-U>nohlsearch<cr>
    no! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
aug END

" targets.vim
" if has('vim_starting')
"     let g:targets_jumpRanges = ''
"     let g:targets_aiAI = 'aIAi'
"     let g:targets_nl = 'nN'
"     au vimrc User targets#mappings#user call targets#mappings#extend({
"             \ 's': { '': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
"             \             {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
"             \             {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}] },
"             \ "'": {'quote': [{'d':"'"}, {'d':'"'}]},
"             \ 'b': {'pair': [{'o':'(', 'c':')'}]},
"             \ })
" endif
