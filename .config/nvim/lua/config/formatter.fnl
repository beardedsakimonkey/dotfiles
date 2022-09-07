(local formatter (require :formatter))
(local format (require :formatter.format))
(local {: some? : $HOME} (require :util))
(import-macros {: augroup : autocmd : opt} :macros)

;; NOTE: Use :FormatWrite to format this file. (I believe the augroup gets
;; cleared on write before the autocmd executes.)

(fn fnlfmt []
  {:exe :fnlfmt :args [(vim.api.nvim_buf_get_name 0)] :stdin true})

(local {: gofmt} (require :formatter.filetypes.go))

;; NOTE: YOU MUST UPDATE plugins.fnl WHEN ADDING NEW FILETYPES.
(formatter.setup {:filetype {:fennel [fnlfmt] :go [gofmt]}})

(vim.api.nvim_create_user_command :FormatDisable
                                  #(set vim.g.format_enabled false) {})

(vim.api.nvim_create_user_command :FormatEnable
                                  #(set vim.g.format_enabled true) {})

(fn falsy? [v]
  (or (not v) (= "" v)))

(local excludes [(.. $HOME :/.local/share/nvim/site/pack/mine/start/snap/lua/)
                 (.. (vim.fn.stdpath :config) :/colors/)])

(augroup :my/formatter
         (autocmd BufWritePost [*.fnl *.go]
                  (fn [{: file : buf}]
                    (local excluded (some? excludes #(vim.startswith file $1)))
                    ;; If compilation failed, we don't want to format, because
                    ;; that would trigger a cascading BufWritePost and thus
                    ;; printing the compile error twice.
                    (when (and vim.g.format_enabled (not excluded)
                               (falsy? (vim.fn.getbufvar buf :comp_err)))
                      (format.format "" "" 1 -1 {:write true})))))

