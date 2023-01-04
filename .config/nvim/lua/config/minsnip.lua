local minsnip = require('minsnip')

local function join(seq)
    return table.concat(seq, '\n')
end

local function cl()
    local ft = vim.bo.filetype
    if ft == 'c' then
        return 'printf("$0\\n");'
    elseif ft == 'vim' then
        return 'echom $0'
    elseif ft == 'lua' then
        return 'print($0)'
    elseif ft == 'fennel' then
        return '(print $0)'
    elseif ft == 'javascript' then
        return 'console.log($0)'
    elseif ft == 'rescript' then
        return 'Js.log($0)'
    elseif ft == 'rust' then
        return 'println!("$0")'
    end
end

local function d()
    if vim.bo.filetype == 'lua' then
        return join({
            "local dbg = require 'debugger'",
            'dbg.auto_where = 10',
            'dbg()'
        })
    end
end

local function table()
    return join({'| $0 |    |    |',
                 '| -- | -- | -- |',
                 '|    |    |    |'})
end

minsnip.setup({
    cl = cl,
    d = d,
    table = table,
})

local function expand_snippet()
    if not minsnip.jump() then
        return vim.api.nvim_input('<C-l>')
    end
end

vim.keymap.set('i', '<C-l>', expand_snippet)
