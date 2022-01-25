(local packer (require :packer))

(fn use [pkgs]
  (packer.startup (fn [use use-rocks]
                    (each [name opts (pairs pkgs)]
                      (do
                        (tset opts 1 name)
                        (use opts))))))

;; To profile, run :PackerCompile profile=true, restart nvim, :PackerProfile
(use {;; Neovim
      :wbthomason/packer.nvim {}
      :lewis6991/impatient.nvim {}
      :mhartington/formatter.nvim {:config "require'config.formatter'"
                                   :opt true
                                   :ft [:fennel :go]}
      :ggandor/lightspeed.nvim {:config "require'config.lightspeed'"}
      :camspiers/snap {:config "require'config.snap'" :rocks :fzy}
      :jose-elias-alvarez/minsnip.nvim {:config "require'config.minsnip'"}
      :norcalli/nvim-colorizer.lua {:setup "require'config.colorizer'"
                                    :opt true
                                    :cmd :ColorizerAttachToBuffer}
      ;; Treesitter
      :nvim-treesitter/nvim-treesitter {:branch :0.5-compat
                                        :config "require'config.nvim-treesitter'"
                                        :run ":TSUpdate"}
      :nvim-treesitter/playground {:opt true :cmd :TSPlaygroundToggle}
      :nkrkv/nvim-treesitter-rescript {:opt true :ft :rescript}
      ;; LSP
      :neovim/nvim-lspconfig {:config "require'config.lspconfig'"}
      ;; Completion
      :hrsh7th/nvim-cmp {:config "require'config.cmp'"}
      :hrsh7th/cmp-buffer {:after :nvim-cmp}
      :hrsh7th/cmp-nvim-lua {:after :nvim-cmp}
      :hrsh7th/cmp-path {:after :nvim-cmp}
      :hrsh7th/cmp-nvim-lsp {}
      :hrsh7th/cmp-cmdline {:after :nvim-cmp}
      ;; Vimscript
      :mbbill/undotree {:opt true :cmd [:UndotreeToggle]}
      :tommcdo/vim-exchange {}
      :wellle/targets.vim {:config "require'config.targets'"}
      :andymass/vim-matchup {:config "require'config.matchup'"}
      :AndrewRadev/linediff.vim {:config "require'config.linediff'"}
      :AndrewRadev/undoquit.vim {:config "require'config.undoquit'"}
      :tpope/vim-commentary {}
      :tpope/vim-surround {}
      :tpope/vim-sleuth {}
      :tpope/vim-repeat {}
      ;; Languages
      :bakpakin/fennel.vim {}
      :rescript-lang/vim-rescript {}
      :tikhomirov/vim-glsl {}
      ;; Local
      "~/code/udir" {:config "require'config.udir'"}})

