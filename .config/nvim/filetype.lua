vim.filetype.add{
    extension = {
        flow = 'javascript',
        vert = 'glsl',
        frag = 'glsl',
    },
    filename = {
        ['tmux.conf'] = 'tmux',
        ['.fasdrc'] = 'bash',
        ['rtorrent.rc'] = 'dosini',
        ['.luacheckrc'] = 'lua',
    },
    pattern = {
        ['/zsh/functions/[^/]-$'] = 'zsh',
        ['res?i?$'] = 'ocaml',
    },
}
