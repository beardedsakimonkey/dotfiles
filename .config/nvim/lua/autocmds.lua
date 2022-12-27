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
    if  amatch ~= 'markdown' or amatch ~= 'gitcommit'  then
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
    if vim.startswith(name, vim.fn.stdpath'config') and not name:match('after/ftplugin') then
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
    local url = vim.fn.expand'<afile>':gsub('^https://github%.com/(.-)/blob/(.*)', 'https://raw.githubusercontent.com/%1/%2')
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

local function autocmd(event, opts)
    vim.api.nvim_create_autocmd(event, vim.tbl_extend('keep', {group = AUGROUP}, opts))
end

vim.api.nvim_create_augroup(AUGROUP, {clear = true})
-- handle large buffers
autocmd('BufReadPre', {callback = handle_large_buffer, pattern = '*'})
-- setup formatoptions
autocmd('FileType', {callback = setup_fo, pattern = '*'})
-- create missing dirs
autocmd({'BufWritePre', 'FileWritePre'}, {callback = create_missing_dirs, pattern = '*'})
-- source lua
autocmd('BufWritePost', {callback = source_lua, pattern = '*.lua'})
-- source vim
autocmd('BufWritePost', {command = 'source <afile>:p', pattern = '*/.config/nvim/plugin/*.vim'})
-- source tmux
autocmd('BufWritePost', {callback = source_tmux, pattern = '*tmux.conf'})
-- update user.js
autocmd('BufWritePost', {callback = update_user_js, pattern = 'user-overrides.js'})
-- zsh-fast-theme
autocmd('BufWritePost', {callback = fast_theme, pattern = '*/.zsh/overlay.ini'})
-- make executable
autocmd('BufNewFile', {callback = function()
    autocmd('BufWritePost', {buffer = 0, callback = maybe_make_executable, once = true})
end, pattern = '*'})
-- edit url
autocmd('BufNewFile', {callback = edit_url, pattern = {'http://*', 'https://*'}})
-- *.sh template
autocmd('BufNewFile', {callback = template_sh, pattern = '*.sh'})
-- *.h template
autocmd('BufNewFile', {callback = template_h, pattern = '*.h'})
-- *.c template
autocmd('BufNewFile', {callback = template_c, pattern = 'main.c'})
-- vimresized
autocmd('VimResized', {command = 'wincmd =', pattern = '*'})
-- checktime
autocmd({'FocusGained', 'BufEnter'}, {command = 'checktime', pattern = '*'})
-- highlight yank
autocmd('TextYankPost', {callback = function()
    vim.highlight.on_yank({on_visual = false})
end, pattern = '*'})
-- termopen
autocmd('TermOpen', {command = 'set nonumber | startinsert', pattern = '*'})
-- termclose
autocmd('TermClose', {command = "exec 'bd! ' .. expand('<abuf>')", pattern = '*'})
