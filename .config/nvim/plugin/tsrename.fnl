;; seems like command-preview is unstable -- nvim crashes

;; (fn complete-rename [buf node new-name _hi?]
;;   (local ts-utils (require :nvim-treesitter.ts_utils))
;;   (local locals (require :nvim-treesitter.locals))
;;   (when (and new-name (> (length new-name) 0))
;;     (local (definition scope) (locals.find_definition node buf))
;;     (local nodes-to-rename {})
;;     (tset nodes-to-rename (node:id) node)
;;     (tset nodes-to-rename (definition:id) definition)
;;     (each [_ n (ipairs (locals.find_usages definition scope buf))]
;;       (tset nodes-to-rename (n:id) n))
;;     (local edits {})
;;     (each [_ node (pairs nodes-to-rename)]
;;       (local lsp-range (ts-utils.node_to_lsp_range node))
;;       (local text-edit {:range lsp-range :newText new-name})
;;       (table.insert edits text-edit))
;;     (vim.lsp.util.apply_text_edits edits buf :utf-8)))

;; (fn tsrename-preview [opts]
;;   (local ts-utils (require :nvim-treesitter.ts_utils))
;;   (local buf (vim.api.nvim_get_current_buf))
;;   (local cursor-node (ts-utils.get_node_at_cursor 0 false))
;;   (when cursor-node
;;     (complete-rename buf cursor-node opts.args true))
;;   ;; show preview without preview window
;;   1)

;; (fn tsrename [opts]
;;   (local ts-utils (require :nvim-treesitter.ts_utils))
;;   (local buf (vim.api.nvim_get_current_buf))
;;   (local cursor-node (ts-utils.get_node_at_cursor 0 false))
;;   (when cursor-node
;;     (complete-rename buf cursor-node opts.args false)))

;; (vim.api.nvim_create_user_command :TSRename tsrename
;;                                   {:nargs 1 :preview tsrename-preview})
