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
      ;; neovim
      :wbthomason/packer.nvim {}
      :mhartington/formatter.nvim {:require :formatter}
      :ggandor/lightspeed.nvim {:require :lightspeed}
      :camspiers/snap {:require :snap :rocks :fzy}
      :jose-elias-alvarez/minsnip.nvim {:require :minsnip}
      :sindrets/diffview.nvim {}
      :norcalli/nvim-colorizer.lua {:require :colorizer}

      ;; completion
      :hrsh7th/nvim-cmp {:require :cmp}
      :hrsh7th/cmp-buffer {}
      :hrsh7th/cmp-nvim-lua {}
      :hrsh7th/cmp-path {}
      :hrsh7th/cmp-nvim-lsp {}

      ;; vimscript
      :mbbill/undotree {}
      :tommcdo/vim-exchange {}
      :wellle/targets.vim {:require :targets}
      :andymass/vim-matchup {:require :matchup}
      :AndrewRadev/linediff.vim {:require :linediff}
      :AndrewRadev/undoquit.vim {:require :undoquit}

      ;; fennel
      :bakpakin/fennel.vim {}
      :rescript-lang/vim-rescript {}
      :gpanders/nvim-parinfer {}

      ;; treesitter
      :nvim-treesitter/nvim-treesitter {:branch :0.5-compat :require :nvim-treesitter}
      :nvim-treesitter/playground {}
      "~/code/rescript-ts-auto-rename" {}
      :nkrkv/nvim-treesitter-rescript {:run ":TSUpdate rescript"}

      ;; local plugins
      "~/code/nvim-filetree" {:require :filetree}

      ;; tpope
      :tpope/vim-commentary {}
      :tpope/vim-surround {}
      :tpope/vim-sleuth {}
      :tpope/vim-repeat {}})

