local util = require'util'

local function get_url(fname, stdout, stderr, exit)
    local branch = vim.fn.system('git branch --show-current'):match('%S+')
    assert(branch, 'no git branch')
    assert(exit == 0, 'Command exited with non-zero exit code\nstderr: ' .. stderr)
    local line = vim.split(stdout, '\n')[1]
    local url = vim.split(line, '%s', {plain=false})[2]
    assert(url and vim.startswith(url, 'http'), 'Could not find url in line: ' .. line)
    url = url:gsub('.git$', '')
    local dir = vim.fs.find('.git', {upward = true, type = 'directory'})[1]
    dir = dir:sub(1, -5)
    return url .. '/blob/main/' .. fname:sub(#dir)
end

local function github_url()
    local fname = vim.fn.expand('%:p')
    util.system({'git', 'remote', '-v'}, vim.schedule_wrap(function(stdout, stderr, exit)
        local ok, res = pcall(get_url, fname, stdout, stderr, exit)
        if not ok then
            vim.notify(res, vim.log.levels.WARN)
        end
        print('Copied', res)
    end))
end

vim.api.nvim_create_user_command('GithubUrl', github_url, {})
