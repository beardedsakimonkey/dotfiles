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
                        (tset opts 1 name)
                        (use opts))))))

;; fnlfmt: skip
(use {
  :wbthomason/packer.nvim {}
  :mhartington/formatter.nvim {:require :formatter}
  :hrsh7th/nvim-compe {:require :compe}
  :ggandor/lightspeed.nvim {:require :lightspeed}
  :camspiers/snap {:require :snap :rocks :fzy}

  :mbbill/undotree {}
  :tommcdo/vim-exchange {}
  :wellle/targets.vim {}
  :andymass/vim-matchup {}
  :AndrewRadev/linediff.vim {:require :linediff}
  :AndrewRadev/undoquit.vim {:require :undoquit}

  :bakpakin/fennel.vim {}
  :rescript-lang/vim-rescript {}

  :nvim-treesitter/nvim-treesitter {:branch :0.5-compat :require :nvim_treesitter}
  :nvim-treesitter/playground {}
  :nkrkv/nvim-treesitter-rescript {}

  "~/code/nvim-filetree" {:require :filetree}

  :tpope/vim-commentary {}
  :tpope/vim-surround {}
  :tpope/vim-sleuth {}
  :tpope/vim-repeat {}})

