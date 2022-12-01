(local packer (require :packer))

(fn use [pkgs]
  (local spec {:config {}})
  (tset spec 1 (fn [use]
                 (each [name opts (pairs pkgs)]
                   (tset opts 1 name)
                   (use opts))))
  (packer.startup spec))

(use {;;
      ;; Neovim
      ;;
      :beardedsakimonkey/packer.nvim {}
      :lewis6991/impatient.nvim {}
      :beardedsakimonkey/nvim-udir {:config "require'config.udir'"
                                    :branch :develop}
      :beardedsakimonkey/nvim-ufind {:config "require'config.ufind'"}
      :neovim/nvim-lspconfig {:config "require'config.lsp'"}
      :mhartington/formatter.nvim {:config "require'config.formatter'"}
      :mfussenegger/nvim-lint {:config "require'config.lint'"}
      :ggandor/lightspeed.nvim {:config "require'config.lightspeed'"}
      :jose-elias-alvarez/minsnip.nvim {:config "require'config.minsnip'"
                                        :commit :6ae2f32}
      :norcalli/nvim-colorizer.lua {:setup "require'config.colorizer'"}
      :Darazaki/indent-o-matic {:commit :f7d4382}
      :kylechui/nvim-surround {:config "require'config.surround'"}
      :ii14/neorepl.nvim {}
      :Wansmer/treesj {:config "require'config.treesj'"}
      :folke/neodev.nvim {}
      ;;
      ;; Treesitter
      ;;
      :nvim-treesitter/nvim-treesitter {:config "require'config.treesitter'"
                                        :run ":TSUpdate"}
      :nvim-treesitter/playground {:after :nvim-treesitter}
      :nvim-treesitter/nvim-treesitter-textobjects {:after :nvim-treesitter}
      ;;
      ;; Completion
      ;;
      :hrsh7th/nvim-cmp {:config "require'config.cmp'"}
      :hrsh7th/cmp-buffer {:after :nvim-cmp}
      :hrsh7th/cmp-nvim-lua {:after :nvim-cmp}
      :hrsh7th/cmp-path {:after :nvim-cmp}
      :hrsh7th/cmp-nvim-lsp {}
      ;;
      ;; Vimscript
      ;;
      :mbbill/undotree {}
      :tommcdo/vim-exchange {}
      :dstein64/vim-startuptime {}
      :AndrewRadev/linediff.vim {:config "require'config.linediff'"}
      :tommcdo/vim-lion {:config "vim.g.lion_squeeze_spaces = 1"}
      :tpope/vim-commentary {}
      :tpope/vim-repeat {}
      ;;
      ;; Languages
      ;;
      ;; :rescript-lang/vim-rescript {}
      :bakpakin/fennel.vim {}
      :gpanders/fennel-repl.nvim {}
      :beardedsakimonkey/nvim-antifennel {}})
