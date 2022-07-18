(import-macros {: opt} :macros)

;; Install packer.nvim if needed.
(local path (.. (vim.fn.stdpath :data) :/site/pack/packer/start/packer.nvim))
(local needs-boostrap (not (vim.loop.fs_access path :R)))
(when needs-boostrap
  (os.execute (.. "git clone --depth=1 https://github.com/wbthomason/packer.nvim "
                  path))
  (opt runtimepath ^= (.. (vim.fn.stdpath :data) "/site/pack/*/start/*,"
                          vim.o.runtimepath)))

(fn use [pkgs]
  (local packer (require :packer))
  (packer.startup (fn []
                    (each [name opts (pairs pkgs)]
                      (tset opts 1 name)
                      (packer.use opts)))))

(use {;; Neovim
      :wbthomason/packer.nvim {}
      :beardedsakimonkey/nvim-udir {:config "require'config.udir'"}
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
      ;; Treesitter
      :nvim-treesitter/nvim-treesitter {:config "require'config.treesitter'"
                                        :run ":TSUpdate"}
      :nvim-treesitter/playground {:opt true
                                   :ft :query
                                   :cmd [:TSPlaygroundToggle
                                         :TSHighlightCapturesUnderCursor]
                                   :after :nvim-treesitter}
      :nkrkv/nvim-treesitter-rescript {:opt true
                                       :ft :rescript
                                       :after :nvim-treesitter
                                       :run ":TSUpdate"}
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
      :tommcdo/vim-lion {:opt true
                         :keys [:gl :gL]
                         :config "vim.g.lion_squeeze_spaces = 1"}
      :AndrewRadev/undoquit.vim {:config "require'config.undoquit'"}
      :tpope/vim-commentary {}
      :tpope/vim-surround {}
      :tpope/vim-repeat {}
      ;; Languages
      :rescript-lang/vim-rescript {:opt true :ft :rescript}
      :beardedsakimonkey/fennel-repl.nvim {:opt true
                                           :cmd :FennelRepl
                                           :ft :fennel
                                           :config "require'config.fennelrepl'"}})

(when needs-boostrap
  (local packer (require :packer))
  (packer.sync))

