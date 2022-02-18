(local packer (require :packer))

(fn use [pkgs]
  (packer.startup (fn []
                    (each [name opts (pairs pkgs)]
                      (do
                        (tset opts 1 name)
                        (packer.use opts))))))

(use {;; Neovim
      :wbthomason/packer.nvim {}
      :mhartington/formatter.nvim {:config "require'config.formatter'"
                                   :opt true
                                   :ft [:fennel :go]}
      :ggandor/lightspeed.nvim {:config "require'config.lightspeed'"}
      :camspiers/snap {:config "require'config.snap'" :rocks :fzy}
      :jose-elias-alvarez/minsnip.nvim {:config "require'config.minsnip'"
                                        :commit :6ae2f32}
      :norcalli/nvim-colorizer.lua {:setup "require'config.colorizer'"
                                    :opt true
                                    :cmd :ColorizerAttachToBuffer}
      :Darazaki/indent-o-matic {:commit :f7d4382}
      ;; Treesitter
      :nvim-treesitter/nvim-treesitter {:config "require'config.treesitter'"
                                        :run ":TSUpdate"}
      :nvim-treesitter/playground {:opt true
                                   :cmd [:TSPlaygroundToggle
                                         :TSHighlightCapturesUnderCursor]
                                   :after :nvim-treesitter}
      :nkrkv/nvim-treesitter-rescript {:opt true
                                       :ft :rescript
                                       :after :nvim-treesitter}
      :windwp/nvim-ts-autotag {:config "require'nvim-ts-autotag'.setup()"
                               :opt true
                               :ft [:html :rescript :typescript :javascript]
                               :after :nvim-treesitter}
      ;; LSP
      :neovim/nvim-lspconfig {:config "require'config.lsp'"}
      ;; Completion
      :hrsh7th/nvim-cmp {:config "require'config.cmp'"}
      :hrsh7th/cmp-buffer {:after :nvim-cmp}
      :hrsh7th/cmp-nvim-lua {:after :nvim-cmp}
      :hrsh7th/cmp-path {:after :nvim-cmp}
      :hrsh7th/cmp-nvim-lsp {}
      ;; Vimscript
      :mbbill/undotree {:opt true :cmd :UndotreeToggle}
      :tommcdo/vim-exchange {:opt true :keys :cx}
      :dstein64/vim-startuptime {:opt true :cmd :StartupTime}
      :AndrewRadev/linediff.vim {:config "require'config.linediff'"
                                 :opt true
                                 :keys [[:v :D]]}
      :AndrewRadev/undoquit.vim {:config "require'config.undoquit'"}
      :tpope/vim-commentary {}
      :tpope/vim-surround {}
      :tpope/vim-repeat {}
      ;; Languages
      :rescript-lang/vim-rescript {:opt true :ft :rescript}
      ;; Local
      "~/code/udir" {:config "require'config.udir'"}})

