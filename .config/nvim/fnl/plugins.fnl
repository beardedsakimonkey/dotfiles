(local packer (require :packer))

(fn safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :plugin. name))]
    (when (not ok?)
      (print (.. "plugin config error: " val-or-err)))))

(fn use [pkgs]
  (packer.startup (fn [use use-rocks]
                    (each [name opts (pairs pkgs)]
                      (do
                        (-?> (. opts :require) (safe-require-plugin-config))
                        (if (. opts :rock)
                            (use-rocks name)
                            (do
                              (tset opts 1 name)
                              (use opts))))))))

;; QUIT AND RUN :PackerInstall AFTER MAKING CHANGES!!!!!

;; fnlfmt: skip
(use {
  :wbthomason/packer.nvim {}
  :mhartington/formatter.nvim {:require :formatter}
  :hrsh7th/nvim-compe {:require :compe}
  :ggandor/lightspeed.nvim {:require :lightspeed}

  :camspiers/snap {:require :snap}
  :fzy {:rock true}

  :mbbill/undotree {}
  :tommcdo/vim-exchange {}
  :wellle/targets.vim {}
  :andymass/vim-matchup {}
  :AndrewRadev/linediff.vim {:require :linediff}
  :AndrewRadev/undoquit.vim {:require :undoquit}
  :romgrk/equal.operator {}

  :bakpakin/fennel.vim {}

  "~/code/nvim-filetree" {:require :filetree}

  :tpope/vim-commentary {}
  :tpope/vim-surround {}
  :tpope/vim-sleuth {}
  :tpope/vim-repeat {}})

