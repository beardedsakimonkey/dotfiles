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
      ;; Neovim
      :wbthomason/packer.nvim {}
      :mhartington/formatter.nvim {:require :formatter}
      :ggandor/lightspeed.nvim {:require :lightspeed}
      :camspiers/snap {:require :snap :rocks :fzy}
      :jose-elias-alvarez/minsnip.nvim {:require :minsnip}
      :norcalli/nvim-colorizer.lua {:require :colorizer}
      :lewis6991/impatient.nvim {}

      ;; Treesitter
      :nvim-treesitter/nvim-treesitter {:branch :0.5-compat :require :nvim-treesitter}
      :nvim-treesitter/playground {}
      :nkrkv/nvim-treesitter-rescript {:run ":TSUpdate rescript"}

      ;; LSP
      :neovim/nvim-lspconfig {:require :lspconfig}

      ;; Completion
      :hrsh7th/cmp-buffer {}
      :hrsh7th/cmp-nvim-lua {}
      :hrsh7th/cmp-path {}
      :hrsh7th/cmp-nvim-lsp {}
      :hrsh7th/cmp-cmdline {}
      :hrsh7th/nvim-cmp {:require :cmp}

      ;; Vimscript
      :mbbill/undotree {}
      :tommcdo/vim-exchange {}
      :wellle/targets.vim {:require :targets}
      :andymass/vim-matchup {:require :matchup}
      :AndrewRadev/linediff.vim {:require :linediff}
      :AndrewRadev/undoquit.vim {:require :undoquit}
      :tpope/vim-commentary {}
      :tpope/vim-surround {}
      :tpope/vim-sleuth {}
      :tpope/vim-repeat {}

      ;; Languages
      :bakpakin/fennel.vim {}
      :rescript-lang/vim-rescript {}
      :tikhomirov/vim-glsl {}

      ;; Local
      "~/code/qdir" {:require :qdir}
      })

