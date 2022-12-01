(require :impatient)

(local {: exists?} (require :util))
(import-macros {: opt} :macros)

;; Install packer.nvim if needed.
(local path (.. (vim.fn.stdpath :data) :/site/pack/packer/start/packer.nvim))
(when (not (exists? path))
  (os.execute (.. "git clone --depth=1 https://github.com/beardedsakimonkey/packer.nvim "
                  path))
  (opt runtimepath ^= (.. (vim.fn.stdpath :data) :/site/pack/*/start/*))
  (require :plugins)
  (local packer (require :packer))
  (packer.sync))

;; In $VIMRUNTIME/plugin/
(set vim.g.loaded_matchit 1)
(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)
(set vim.g.loaded_remote_plugins 1)
(set vim.g.loaded_spellfile_plugin 1)
(set vim.g.loaded_2html_plugin 1)
(set vim.g.loaded_tutor_mode_plugin 1)

;; In $VIMRUNTIME/autoload/provider/
(set vim.g.loaded_node_provider 1)
(set vim.g.loaded_perl_provider 1)
(set vim.g.loaded_python_provider 1)
(set vim.g.loaded_python3_provider 1)
(set vim.g.loaded_ruby_provider 1)

(vim.cmd.colorscheme :navajo)

;; See :h syntax-loading
(vim.cmd.syntax :enable)

(fn require-safe [mod]
  (local (ok? msg) (xpcall #(require mod) debug.traceback))
  (when (not ok?)
    (vim.api.nvim_err_writeln (: "Config error in %s: %s" :format mod msg))))

(require-safe :mappings)
(require-safe :options)
(require-safe :autocmds)
(require-safe :statusline)
(require-safe :commands)
