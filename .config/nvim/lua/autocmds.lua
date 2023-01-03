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
    vim.opt_local.formatoptions:append('jcn')
    local amatch = vim.fn.expand'<amatch>'
    if amatch ~= 'markdown' or amatch ~= 'gitcommit'  then
        vim.opt_local.formatoptions:remove('t')
    end
    vim.opt_local.formatoptions:remove('r')
    vim.opt_local.formatoptions:remove('o')
end

local function create_missing_dirs()
    local afile = vim.fn.expand'<afile>'
    if not afile:match('://') then
        vim.fn.mkdir(fe(vim.fn.expand'<afile>:p:h'), 'p')
    end
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
        assert(0 == exit)
        print('Updated user.js')
    end
    vim.loop.spawn(util.FF_PROFILE .. 'updater.sh', {args = {'-d', '-s', '-b'}}, on_exit)
end

local function fast_theme()
    local zsh = os.getenv'HOME' .. '/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh'
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

local function maybe_make_executable()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line:match('^#!%S+') then
        local path = se(vim.fn.expand'<afile>:p')
        vim.cmd('sil !chmod +x ' .. path)
    end
end

local function edit_url()
    local abuf = tonumber(vim.fn.expand'<abuf>') or 0
    vim.bo[abuf].buftype = 'nofile'
    local url = vim.fn.expand'<afile>':gsub(
        '^https://github%.com/(.-)/blob/(.*)',
        'https://raw.githubusercontent.com/%1/%2'
    )
    local function strip_trailing_newline(str)
        if '\n' == str:sub(-1) then
            return str:sub(1, -2)
        else
            return str
        end
    end
    local function cb(stdout, stderr, exit)
        local lines = vim.split(strip_trailing_newline(exit == 0 and stdout or stderr), '\n')
        vim.schedule(function()
            vim.api.nvim_buf_set_lines(abuf, 0, -1, true, lines)
        end)
    end
    util.system({'curl', '--location', '--silent', '--show-error', url}, cb)
end

local function template_sh()
    vim.api.nvim_buf_set_lines(0, 0, -1, true, {'#!/bin/bash'})
end

local function template_h()
    local file_name = vim.fn.expand'<afile>:t'
    local guard = string.upper(file_name:gsub('%.', '_'))
    vim.api.nvim_buf_set_lines(0, 0, -1, true, {('#ifndef ' .. guard), ('#define ' .. guard), '', '#endif'})
end

local function template_c()
    local str = '#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n    printf(\'hi\\n\');\n}'
    vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(str, '\n'))
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

au('BufReadPre', '*', handle_large_buffer)                            -- handle large buffers
au('FileType', '*', setup_fo)                                         -- setup formatoptions
au({'BufWritePre', 'FileWritePre'}, '*', create_missing_dirs)         -- create missing dirs
au('BufWritePost', '*.lua', source_lua)                               -- source lua
au('BufWritePost', '*/.config/nvim/plugin/*.vim', 'source <afile>:p') -- source vim
au('BufWritePost', '*tmux.conf', source_tmux)                         -- source tmux
au('BufWritePost', 'user-overrides.js', update_user_js)               -- update user.js
au('BufWritePost', '*/.zsh/overlay.ini', fast_theme)                  -- zsh-fast-theme
au('BufNewFile', '*', function()                                      -- make executable
    au('BufWritePost', nil, maybe_make_executable, {buffer = 0, once = true})
end)
au('BufNewFile', {'http://*', 'https://*'}, edit_url)                 -- edit url
au('BufNewFile', '*.sh', template_sh)                                 -- *.sh template
au('BufNewFile', '*.h', template_h)                                   -- *.h template
au('BufNewFile', 'main.c', template_c)                                -- *.c template
au('VimResized', '*', 'wincmd =')                                     -- vimresized
au({'FocusGained', 'BufEnter'}, '*', 'checktime')                     -- checktime
au('TextYankPost', '*', function()                                    -- highlight yank
    vim.highlight.on_yank({on_visual = false})
end)
au('TermOpen', '*', 'set nonumber | startinsert')                     -- termopen
au('TermClose', '*', "exec 'bd! ' .. expand('<abuf>')")               -- termclose
