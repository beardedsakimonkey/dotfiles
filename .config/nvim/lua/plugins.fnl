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
      :beardedsakimonkey/nvim-udir {:config "require'config.udir'"}
      :beardedsakimonkey/nvim-ufind {:config "require'config.ufind'"}
      :neovim/nvim-lspconfig {:config "require'config.lsp'"}
      :mhartington/formatter.nvim {:config "require'config.formatter'"
                                   :opt true
                                   :ft [:fennel :go]}
      :mfussenegger/nvim-lint {:config "require'config.lint'"}
      :ggandor/lightspeed.nvim {:config "require'config.lightspeed'"}
      :jose-elias-alvarez/minsnip.nvim {:config "require'config.minsnip'"
                                        :commit :6ae2f32}
      :norcalli/nvim-colorizer.lua {:setup "require'config.colorizer'"
                                    :opt true
                                    :cmd :ColorizerAttachToBuffer}
      :Darazaki/indent-o-matic {:commit :f7d4382}
      :kylechui/nvim-surround {:config "require'config.surround'"}
      ;; :echasnovski/mini.nvim {:config "require'config.mini'"}
      :ii14/neorepl.nvim {:opt true :cmd :Repl}
      ;; TODO: Doesn't work for fennel
      ;; :monkoose/matchparen.nvim {:config "require'matchparen'.setup()"}
      ;;
      ;; Treesitter
      ;;
      :nvim-treesitter/nvim-treesitter {:config "require'config.treesitter'"
                                        :run ":TSUpdate"}
      :nvim-treesitter/playground {:opt true
                                   :ft :query
                                   :cmd [:TSPlaygroundToggle
                                         :TSHighlightCapturesUnderCursor]
                                   :after :nvim-treesitter}
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
      :farmergreg/vim-lastplace {:commit :cef9d62}
      :AndrewRadev/undoquit.vim {:commit :74d2a1f}
      :mbbill/undotree {:opt true :cmd :UndotreeToggle}
      :tommcdo/vim-exchange {:opt true :keys [[:n :cx] [:v :X]]}
      :dstein64/vim-startuptime {:opt true :cmd :StartupTime}
      :AndrewRadev/linediff.vim {:config "require'config.linediff'"
                                 :opt true
                                 :keys [[:v :D]]}
      :tommcdo/vim-lion {:opt true
                         :keys [:gl :gL]
                         :config "vim.g.lion_squeeze_spaces = 1"}
      :tpope/vim-commentary {}
      :tpope/vim-repeat {}
      ;;
      ;; Languages
      ;;
      :rescript-lang/vim-rescript {:disable true :opt true :ft :rescript}
      :bakpakin/fennel.vim {:opt true :ft :fennel}
      :gpanders/fennel-repl.nvim {:opt true :cmd :FennelRepl :ft :fennel}
      :beardedsakimonkey/nvim-antifennel {:opt true :cmd :Antifennel}})
