local util = require'util'

local function handle_large_buffer()
    local size = vim.fn.getfsize(vim.fn.expand'<afile>')
    if size > (1024 * 1024) or size == -2 then
        vim.cmd 'syntax clear'
    end
end

local function setup_formatoptions()
    vim.opt.fo = vim.opt.fo
        + 'j' -- remove comment leader joining lines
        + 'c' -- auto-wrap comments
    local amatch = vim.fn.expand'<amatch>'
    if amatch ~= 'markdown' and amatch ~= 'gitcommit' then
        vim.opt.fo = vim.opt.fo - 't'  -- don't auto-wrap text
    end
    vim.opt.fo = vim.opt.fo - 'o'  -- don't auto-insert comment leader on 'o'
end

local function setup_folding()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    local ok, has_parser = pcall(vim.treesitter.language.add, lang)
    if ok and has_parser then
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    else
        vim.opt_local.foldmethod = 'indent'
        vim.opt_local.foldexpr = '0'
    end
end

local function source_lua()
    local name = vim.fn.expand'<afile>:p'
    if vim.startswith(name, vim.fn.stdpath'config')
        and not name:match('after/ftplugin') then
        vim.cmd('luafile ' .. fe(name))
    end
end

local function source_tmux()
    vim.fn.system('tmux source-file ' .. se(vim.fn.expand'<afile>:p'))
end

local function run_command(command, options)
    options = vim.tbl_extend('force', {text = true}, options or {})
    vim.system(command, options, vim.schedule_wrap(function(result)
        if result.code == 0 then return end
        local output = result.stderr ~= '' and result.stderr or result.stdout
        vim.notify(output, vim.log.levels.ERROR)
    end))
end

local function reload_herdr()
    run_command({'herdr', 'server', 'reload-config'})
end

local function update_user_js()
    local cmd = util.FF_PROFILE .. 'updater.sh'
    vim.uv.spawn(cmd, {args = {'-d', '-s', '-b'}}, function(exit)
        print(exit == 0 and 'Updated user.js' or ('exited nonzero: ' .. exit))
    end)
end

local function build_go(args)
    local root = vim.fs.root(args.buf, {'go.work', 'go.mod', '.git'})
        or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))

    -- This only builds the package at the project root, not subprojects.
    run_command({'go', 'build'}, {cwd = root})
end

local function build_typescript(args)
    local root = vim.fs.root(args.buf, {'tsconfig.json', '.git'})
        or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))
    local tsc = vim.fn.exepath'tsc'

    if tsc == '' then
        vim.notify('tsc not found in PATH', vim.log.levels.ERROR)
        return
    end

    run_command({tsc, '--project', root}, {cwd = root})
end

local function fast_theme()
    local zsh = os.getenv'HOME'
        .. '/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh'
    if util.exists(zsh) then
        local out = vim.fn.system('source ' .. zsh .. ' && fast-theme '
            .. vim.fn.expand'<afile>:p')
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_err_writeln(out)
        end
    else
        vim.api.nvim_err_writeln('zsh script not found')
    end
end

-- A nameless `:w` errors with E32 before any BufWriteCmd can run, so instead
-- give an unnamed buffer a generated $HOME name the moment it's edited; a plain
-- `:w` then just writes there (the file isn't created until you actually save).
local function name_scratch(args)
    if vim.api.nvim_buf_get_name(args.buf) ~= '' then return end
    local name = vim.fn.expand'~'
        .. os.date'/scratch-%Y-%m-%d-%H%M%S' .. '-' .. args.buf .. '.txt'
    vim.api.nvim_buf_set_name(args.buf, name)
end

local function setup_scratch_write(args)
    -- only plain unnamed file buffers, and only arm the hook once
    if vim.api.nvim_buf_get_name(args.buf) ~= ''
        or vim.bo[args.buf].buftype ~= ''
        or vim.b[args.buf].scratch_write then
        return
    end
    vim.b[args.buf].scratch_write = true
    vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
        buffer = args.buf,
        once = true,
        callback = name_scratch,
    })
end

local function restore_cursor_position(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
        vim.api.nvim_win_set_cursor(0, mark)
    end
end

local function set_highlights()
    local function add_undercurl(name)
        vim.api.nvim_set_hl(0, name, {undercurl = true, update = true})
    end
    -- undercurl instead of underline
    add_undercurl('DiagnosticUnderlineError')
    add_undercurl('DiagnosticUnderlineWarn')
    add_undercurl('DiagnosticUnderlineInfo')
    add_undercurl('DiagnosticUnderlineHint')
    add_undercurl('DiagnosticUnderlineOk')
    vim.api.nvim_set_hl(0, 'FoldColumn', { link = 'Comment' })
    -- no border background
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', update = true })
    -- don't change foreground on matching parens
    vim.api.nvim_set_hl(0, 'MatchParen', { fg = 'NONE', update = true })
end

local au = aug'my/autocmds'
au('BufReadPre', '*', handle_large_buffer)
au('BufRead', {'.bash_history', '.zsh_history'}, 'setlocal noundofile')
au('FileType', '*', setup_formatoptions)
au('FileType', '*', setup_folding)
au('BufWritePost', '*.lua', source_lua, {nested = true})
au('BufWritePost', '*/.config/nvim/plugin/*.vim', 'source <afile>:p')
au('BufWritePost', '*tmux.conf', source_tmux)
au('BufWritePost', '*/.config/herdr/config.toml', reload_herdr)
au('BufWritePost', 'user-overrides.js', update_user_js)
au('BufWritePost', '*/.zsh/overlay.ini', fast_theme)
au('BufWritePost', '*.go', build_go)
au('BufWritePost', '*.ts', build_typescript)
au('VimResized', '*', 'wincmd =')
au({'FocusGained', 'BufEnter'}, '*', 'checktime')
au('TextYankPost', '*', function() vim.hl.on_yank{on_visual = true, timeout = 250} end)
au('BufReadPost', '*', restore_cursor_position)
au({'BufNewFile', 'BufEnter'}, '*', setup_scratch_write)
au('ColorScheme', '*', set_highlights)
