local util = require'util'

local se = vim.fn.shellescape

local command = vim.api.nvim_create_user_command

command('UpdateUserJs', function()
    vim.cmd(('botright new | terminal cd %s && ./updater.sh && ./prefsCleaner.sh')
    :format(se(util.FF_PROFILE)))
end, {})
command('Scratch', 'call my#scratch(<q-args>, <q-mods>)', {nargs = 1, complete = 'command'})
command('Messages', '<mods> Scratch messages', {nargs = 0})
command('Marks', '<mods> Scratch marks <args>', {nargs = '?'})
command('Highlight', '<mods> Scratch highlight <args>', {nargs = '?', complete = 'highlight'})
command('Jumps', '<mods> Scratch jumps', {nargs = 0})
command('Scriptnames', '<mods> Scratch scriptnames', {nargs = 0})
