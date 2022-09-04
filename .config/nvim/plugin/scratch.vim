command! -nargs=1 -complete=command Scratch call my#scratch(<q-args>, <q-mods>)
command! -nargs=0 Messages <mods> Scratch messages
command! -nargs=? Marks <mods> Scratch marks <args>
command! -nargs=? -complete=highlight Highlight <mods> Scratch highlight <args>
command! -nargs=0 Jumps <mods> Scratch jumps
command! -nargs=0 Scriptnames <mods> Scratch scriptnames
