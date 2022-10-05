(local formatter (require :formatter))
(local format (require :formatter.format))
(local {: s\ : some? : $HOME} (require :util))
(import-macros {: augroup : autocmd : opt : command} :macros)

;; NOTE: Use :FormatWrite to format this file. (I believe the augroup gets
;; cleared on write before the autocmd executes.)

(fn remove-last-line [text]
  (when (= "" (. text (length text)))
    (table.remove text))
  text)

(fn fnlfmt []
  {:exe :fnlfmt
   :args [(s\ (vim.api.nvim_buf_get_name 0))]
   :stdin true
   :transform remove-last-line})

(local {: gofmt} (require :formatter.filetypes.go))

;; NOTE: YOU MUST UPDATE plugins.fnl WHEN ADDING NEW FILETYPES.
(formatter.setup {:filetype {:fennel [fnlfmt] :go [gofmt]}})

(command :FormatDisable #(set vim.g.format_disabled true))
(command :FormatEnable #(set vim.g.format_disabled false))

(fn falsy? [v]
  (or (not v) (= "" v)))

(local excludes [(.. $HOME :/.local/share/nvim/site/pack/packer/start/snap/lua/)
                 (.. (vim.fn.stdpath :config) :/colors/)])

(augroup :my/formatter
         (autocmd BufWritePost [*.fnl *.go]
                  (fn [{: file : buf}]
                    (local excluded (some? excludes #(vim.startswith file $1)))
                    ;; If compilation failed, we don't want to format, because
                    ;; that would trigger a cascading BufWritePost and thus
                    ;; printing the compile error twice.
                    (when (and (not vim.g.format_disabled) (not excluded)
                               (falsy? (vim.fn.getbufvar buf :comp_err)))
                      (format.format "" "" 1 -1 {:write true})))))
