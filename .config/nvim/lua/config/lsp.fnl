;; TODO: Why does this require take 8ms?
(local lspconfig (require :lspconfig))

(fn on_attach [_client bufnr]
  ;; The built-in on_attach handler sets this to use the lsp server. But this
  ;; means we can't gq on comments. So reset it.
  (tset vim.bo bufnr :formatexpr "")

  (fn buf_keymap [lhs rhs]
    (vim.api.nvim_buf_set_keymap bufnr :n lhs rhs {:noremap true :silent true}))

  ;; NOTE: Diagnostic mappings are in mappings.fnl because they aren't
  ;; necessarily associated with an lsp.
  (buf_keymap :gD "<Cmd>lua vim.lsp.buf.declaration()<CR>")
  (buf_keymap :gd "<Cmd>lua vim.lsp.buf.definition()<CR>")
  (buf_keymap :gh "<Cmd>lua vim.lsp.buf.hover()<CR>")
  (buf_keymap :gm "<Cmd>lua vim.lsp.buf.implementation()<CR>")
  (buf_keymap :gs "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  (buf_keymap :gt "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
  (buf_keymap :gr "<Cmd>lua vim.lsp.buf.rename()<CR>")
  (buf_keymap :ga "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  (buf_keymap :<space>w "<Cmd>lua vim.lsp.buf.formatting()<CR>"))

(vim.diagnostic.config {:virtual_text false
                        ;; :float {:suffix (fn [diagnostic]
                        ;;                   (values (if diagnostic.code
                        ;;                               (: " [%s]" :format
                        ;;                                  diagnostic.code)
                        ;;                               "")
                        ;;                           :DiagnosticWarn))}
                        ;; :format (fn [diag]
                        ;;           (if diag.code
                        ;;               (string.format "%s [%s]"
                        ;;                              diag.message
                        ;;                              diag.code)
                        ;;               diag.message))
                        ;; }
                        ;; {:prefix "●"}
                        :signs false})

(local textDocument/definition vim.lsp.handlers.textDocument/definition)
(fn location-handler [...]
  (textDocument/definition ...)
  (vim.cmd "normal! zz"))

(set vim.lsp.handlers.textDocument/definition location-handler)

(local cfg {: on_attach :flags {:debounce_text_changes 150}})

(set lspconfig.util.default_config
     (vim.tbl_extend :force lspconfig.util.default_config cfg))

(lspconfig.clangd.setup {})
(lspconfig.rls.setup {})

(local root-files [:.luarc.json
                   :.luacheckrc
                   :.stylua.toml
                   :stylua.toml
                   :selene.toml])

(lspconfig.sumneko_lua.setup {:root_dir (fn [fname]
                                          (local util (require :lspconfig.util))
                                          (let [root (or ((util.root_pattern (unpack root-files)) fname)
                                                         ((util.root_pattern :lua/) fname))]
                                            ;; Don't scan the home directory
                                            ;; https://github.com/sumneko/lua-language-server/wiki/FAQ#why-is-the-server-scanning-the-wrong-folder
                                            (when (not= root vim.env.HOME)
                                              root)))
                              ;; See https://github.com/sumneko/lua-language-server/wiki/Settings
                              :settings {:Lua {:telemetry {:enable false}
                                               :diagnostics {:globals [:vim]}
                                               ;; cmp doesn't support lsp snippets
                                               ;; without using certain plugins
                                               :completion {:keywordSnippet false}
                                               :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                                   true)}
                                               :runtime {:version :LuaJIT}}}})

;; (local configs (require :lspconfig.configs))
;; (set configs.fennel-ls
;;       {:default_config {:filetypes [:fennel]
;;                         :cmd [:/Users/tim/code/fennel-ls/fennel-ls]
;;                         :root_dir (fn [dir]
;;                                     (lspconfig.util.find_git_ancestor dir))
;;                         :settings {}}})

;; (lspconfig.fennel-ls.setup (vim.lsp.protocol.make_client_capabilities))
