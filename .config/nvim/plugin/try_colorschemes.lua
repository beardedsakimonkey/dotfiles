-- local path = '/Users/tim/.local/share/nvim/site/pack/packer/start/vim-colorschemes/colors/'

-- _G.cur = _G.cur or 0

-- local names = {}

-- for name in vim.fs.dir(path) do
--     local basename = name:match('^(.*)%.vim$')
--     table.insert(names, basename)
-- end

-- vim.keymap.set('n', 'l', function ()
--     _G.cur = _G.cur + 1
--     if _G.cur > #names then _G.cur = 1 end
--     vim.cmd('colorscheme ' .. names[_G.cur])
--     print(names[_G.cur])
-- end, {nowait = true})
