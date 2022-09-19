;; TODO: Why does this require take 8ms?
(local lspconfig (require :lspconfig))

(fn on_attach [_client bufnr]
  (fn buf_keymap [lhs rhs]
    (vim.api.nvim_buf_set_keymap bufnr :n lhs rhs {:noremap true :silent true}))

  (buf_keymap :gD "<Cmd>lua vim.lsp.buf.declaration()<CR>zz")
  (buf_keymap :gd "<Cmd>lua vim.lsp.buf.definition()<CR>zz")
  (buf_keymap :gh "<Cmd>lua vim.lsp.buf.hover()<CR>")
  (buf_keymap :gm "<Cmd>lua vim.lsp.buf.implementation()<CR>")
  (buf_keymap :gs "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  (buf_keymap :gt "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
  (buf_keymap :gr "<Cmd>lua vim.lsp.buf.rename()<CR>")
  (buf_keymap :ga "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  (buf_keymap :<space>w "<Cmd>lua vim.lsp.buf.formatting()<CR>"))

(vim.diagnostic.config {:virtual_text {:prefix "●"}})

(local cfg {: on_attach :flags {:debounce_text_changes 150}})

(set lspconfig.util.default_config
     (vim.tbl_extend :force lspconfig.util.default_config cfg))

(lspconfig.clangd.setup {})
(lspconfig.rls.setup {})

;; (local configs (require :lspconfig.configs))
;; (set configs.fennel-ls
;;       {:default_config {:filetypes [:fennel]
;;                         :cmd [:/Users/tim/code/fennel-ls/fennel-ls]
;;                         :root_dir (fn [dir]
;;                                     (lspconfig.util.find_git_ancestor dir))
;;                         :settings {}}})

;; (lspconfig.fennel-ls.setup (vim.lsp.protocol.make_client_capabilities))
