local util = require'util'

local fe = vim.fn.fnameescape
local se = vim.fn.shellescape

local function handle_large_buffer()
    local size = vim.fn.getfsize(vim.fn.expand'<afile>')
    if size > (1024 * 1024) or size == -2 then
        vim.cmd('syntax clear')
    end
end

local function setup_fo()
    vim.opt.formatoptions = vim.opt.formatoptions
        + 'j' -- remove comment leader joining lines
        + 'c' -- auto-wrap comments
    local amatch = vim.fn.expand'<amatch>'
    if amatch ~= 'markdown' and amatch ~= 'gitcommit'  then
        vim.opt.formatoptions = vim.opt.formatoptions - 't'  -- don't auto-wrap text
    end
    vim.opt.formatoptions = vim.opt.formatoptions - 'o'  -- don't auto-insert comment leader on 'o'
end

local function source_lua()
    local name = vim.fn.expand'<afile>:p'
    if vim.startswith(name, vim.fn.stdpath'config') and
        not name:match('after/ftplugin') and
        not name:match('/lsp%.lua$') -- avoid spinning up a bunch of lsp servers
        then
        vim.cmd('luafile ' .. fe(name))
    end
end

local function source_tmux()
    vim.fn.system('tmux source-file ' .. se(vim.fn.expand'<afile>:p'))
end

local function update_user_js()
    local function on_exit(exit)
        print(exit == 0 and 'Updated user.js' or ('exited nonzero: ' .. exit))
    end
    print('Updating...')
    vim.loop.spawn(util.FF_PROFILE .. 'updater.sh', {args = {'-d', '-s', '-b'}}, on_exit)
end

local function fast_theme()
    local zsh = os.getenv'HOME'
        .. '/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh'
    if util.exists(zsh) then
        local cmd = 'source ' .. zsh .. ' && fast-theme ' .. vim.fn.expand'<afile>:p'
        local output = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_err_writeln(output)
        end
    else
        vim.api.nvim_err_writeln('zsh script not found')
    end
end

local function edit_url()
    local abuf = tonumber(vim.fn.expand'<abuf>') or 0
    vim.bo[abuf].buftype = 'nofile'
    local url = vim.fn.expand'<afile>':gsub(
        '^https://github%.com/(.-)/blob/(.*)',
        'https://raw.githubusercontent.com/%1/%2'
    )
    local function on_stdout(chunk)
        vim.schedule(function()
            local lines = vim.api.nvim_buf_get_lines(abuf, 0, 1, false)
            local is_empty = #lines == 1 and lines[1] == ''
            vim.api.nvim_buf_set_lines(abuf, is_empty and 0 or -1, -1, true, vim.split(chunk, '\n'))
        end)
    end
    require'ufind.util'.spawn('curl', {'--location', '--silent', '--show-error', url}, on_stdout)
end

local AUGROUP = 'my/autocmds'

local function au(event, pattern, cmd, opts)
    opts = opts or {}
    opts.group = AUGROUP
    opts.pattern = pattern
    if type(cmd) == 'string' then
        opts.command = cmd
    else
        opts.callback = cmd
    end
    vim.api.nvim_create_autocmd(event, opts)
end

vim.api.nvim_create_augroup(AUGROUP, {clear = true})

au('BufReadPre', '*', handle_large_buffer)
au('FileType', '*', setup_fo)
au('BufWritePost', '*.lua', source_lua)
au('BufWritePost', '*/.config/nvim/plugin/*.vim', 'source <afile>:p')
au('BufWritePost', '*tmux.conf', source_tmux)
au('BufWritePost', 'user-overrides.js', update_user_js)
au('BufWritePost', '*/.zsh/overlay.ini', fast_theme)
au('BufNewFile', {'http://*', 'https://*'}, edit_url)
au('VimResized', '*', 'wincmd =')
au({'FocusGained', 'BufEnter'}, '*', 'checktime')
au('TextYankPost', '*', function() vim.highlight.on_yank({on_visual = false}) end)
au('TermOpen', '*', 'set nonumber | startinsert')
au('TermClose', '*', "exec 'bd! ' .. expand('<abuf>')")
