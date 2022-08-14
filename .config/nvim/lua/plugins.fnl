(import-macros {: opt} :macros)

;; Install packer.nvim if needed.
(local path (.. (vim.fn.stdpath :data) :/site/pack/packer/start/packer.nvim))
(local bootstrap? (not (vim.loop.fs_access path :R)))
(when bootstrap?
  (os.execute (.. "git clone --depth=1 https://github.com/wbthomason/packer.nvim "
                  path))
  (opt runtimepath ^= (.. (vim.fn.stdpath :data) "/site/pack/*/start/*,"
                          vim.o.runtimepath)))

(local packer (require :packer))

(fn use [pkgs]
  (packer.startup (fn [use]
                    (each [name opts (pairs pkgs)]
                      (tset opts 1 name)
                      (use opts)))))

(use {;;
      ;; Neovim
      ;;
      :wbthomason/packer.nvim {}
      :neovim/nvim-lspconfig {:config "require'config.lsp'"}
      :beardedsakimonkey/nvim-udir {:config "require'config.udir'"
                                    :branch :config}
      :mhartington/formatter.nvim {:config "require'config.formatter'"
                                   :opt true
                                   :ft [:fennel :go]}
      :ggandor/lightspeed.nvim {:config "require'config.lightspeed'"}
      :beardedsakimonkey/snap {:config "require'config.snap'"}
      :jose-elias-alvarez/minsnip.nvim {:config "require'config.minsnip'"
                                        :commit :6ae2f32}
      :norcalli/nvim-colorizer.lua {:setup "require'config.colorizer'"
                                    :opt true
                                    :cmd :ColorizerAttachToBuffer}
      :Darazaki/indent-o-matic {:commit :f7d4382}
      :kylechui/nvim-surround {:config "require'config.surround'"}
      ;;
      ;; Treesitter
      ;;
      :nvim-treesitter/nvim-treesitter {:config "require'config.treesitter'"}
      :nvim-treesitter/playground {:opt true
                                   :ft :query
                                   :cmd [:TSPlaygroundToggle
                                         :TSHighlightCapturesUnderCursor]
                                   :after :nvim-treesitter}
      :nvim-treesitter/nvim-treesitter-textobjects {:after :nvim-treesitter}
      :windwp/nvim-ts-autotag {:config "require'nvim-ts-autotag'.setup()"
                               :opt true
                               :ft [:html :rescript :typescript :javascript]
                               :after :nvim-treesitter}
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
      :mbbill/undotree {:opt true :cmd :UndotreeToggle}
      :tommcdo/vim-exchange {:opt true :keys :cx}
      :dstein64/vim-startuptime {:opt true :cmd :StartupTime}
      :AndrewRadev/linediff.vim {:config "require'config.linediff'"
                                 :opt true
                                 :keys [[:v :D]]}
      :tommcdo/vim-lion {:opt true
                         :keys [:gl :gL]
                         :config "vim.g.lion_squeeze_spaces = 1"}
      :AndrewRadev/undoquit.vim {:config "require'config.undoquit'"}
      :tpope/vim-commentary {}
      :tpope/vim-repeat {}
      ;;
      ;; Languages
      ;;
      :rescript-lang/vim-rescript {:opt true :ft :rescript}
      :gpanders/fennel-repl.nvim {:opt true :cmd :FennelRepl :ft :fennel}
      :beardedsakimonkey/nvim-antifennel {:opt true :cmd :Antifennel}})

(when bootstrap?
  (packer.sync))

