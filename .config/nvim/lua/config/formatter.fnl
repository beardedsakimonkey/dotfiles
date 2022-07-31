(local formatter (require :formatter))
(local format (require :formatter.format))
(import-macros {: augroup : autocmd : opt} :macros)

;; NOTE: Use :FormatWrite to format this file. (I believe the augroup gets
;; cleared on write before the autocmd executes.)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

(local {: gofmt} (require :formatter.filetypes.go))

;; NOTE: YOU MUST UPDATE plugins.fnl WHEN ADDING NEW FILETYPES.
(formatter.setup {:filetype {:fennel [fnlfmt] :go [gofmt]}})

(fn some? [list pred?]
  (var found false)
  (each [_ v (ipairs list) :until found]
    (when (pred? v)
      (set found true)))
  found)

(local excludes [:/Users/tim/.local/share/nvim/site/pack/mine/start/snap/lua/
                 :/Users/tim/.config/nvim/colors/])

(var enabled true)

(vim.api.nvim_create_user_command :FormatDisable #(set enabled false) {})
(vim.api.nvim_create_user_command :FormatEnable #(set enabled true) {})

(augroup :my/formatter
         (autocmd BufWritePost [*.fnl *.go]
                  (fn [{: file}]
                    (local excluded (some? excludes #(vim.startswith file $1)))
                    ;; If compilation failed, we don't want to format, because
                    ;; that would trigger a cascading BufWritePost and thus
                    ;; printing the compile error twice.
                    (when (and enabled (not excluded) (not vim.b.comp_err))
                      (format.format "" :silent 1 -1 {:write true})))))

