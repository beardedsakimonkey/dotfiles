(module plugins {autoload {packer packer core aniseed.core}})

(fn safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :plugin. name))]
    (when (not ok?)
      (print (.. "dotfiles error: " val-or-err)))))

(fn use [...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup (fn [use use-rocks]
                      (for [i 1 (core.count pkgs) 2]
                        (let [name (. pkgs i)
                              opts (. pkgs (+ i 1))]
                          (-?> (. opts :mod) (safe-require-plugin-config))
                          (if (. opts :rock)
                              (use-rocks name)
                              (use (core.assoc opts 1 name)))))))))

;; REMEMBER TO QUIT AND RUN :PackerCompile WHEN MAKING CHANGES

;; fnlfmt: skip
(use
  :wbthomason/packer.nvim {}
  :Olical/aniseed {}
  :Olical/conjure {}
  :mhartington/formatter.nvim {:mod :formatter}
  :hrsh7th/nvim-compe {:mod :compe}
  :tami5/compe-conjure {}
  :camspiers/snap {:mod :snap}
  :fzy {:rock true}

  "~/code/nvim-filetree" {:mod :filetree}

  :mbbill/undotree {}
  :tommcdo/vim-exchange {}
  :wellle/targets.vim {}
  :andymass/vim-matchup {}
  :AndrewRadev/linediff.vim {}
  :AndrewRadev/undoquit.vim {:mod :undoquit}

  :tpope/vim-commentary {}
  :tpope/vim-surround {}
  :tpope/vim-sleuth {}
  :tpope/vim-repeat {})

