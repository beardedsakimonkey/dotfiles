(vim.filetype.add {:extension {:re :ocaml
                               :rei :ocaml
                               :res :ocaml
                               :flow :javascript
                               :vert :glsl
                               :frag :glsl}
                   :filename {:tmux.conf :tmux
                              :.fasdrc :bash
                              :rtorrent.rc :dosini
                              :.luacheckrc :lua}
                   :pattern {:.*/zsh/functions/.* :zsh}})
