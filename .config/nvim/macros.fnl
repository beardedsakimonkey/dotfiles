(fn autocmd [group event pattern cmd ...]
  (local opts (collect [_ opt (ipairs [...])]
                opt
                true))
  (local (?pattern ?buffer)
         (if (sequence? pattern)
             (values (icollect [_ v (ipairs pattern)]
                       (tostring v)) nil)
             (let [pat (tostring pattern)]
               (match (string.match pat "^<buffer=?(%d*)>$")
                 nil
                 (values pat nil)
                 "" ; <buffer>
                 (values nil 0)
                 num ; <buffer=123>
                 (values nil num)))))
  (local event (if (sequence? event)
                   (icollect [_ v (ipairs event)]
                     (tostring v))
                   (tostring event)))
  (local (?command ?callback)
         (if (= :string (type cmd))
             (values cmd nil)
             (values nil cmd)))
  `(vim.api.nvim_create_autocmd ,event
                                {:group ,group
                                 :pattern ,?pattern
                                 :buffer ,?buffer
                                 :command ,?command
                                 :callback ,?callback
                                 :once ,opts.once
                                 :nested ,opts.nested}))

(fn augroup [name ...]
  `(do
     (vim.api.nvim_create_augroup ,name {:clear true})
     (doto ,name ,...)))

(fn opt* [opt option ?value-or-eq ?value]
  (local value-or-eq (if (= nil ?value-or-eq) true ?value-or-eq))
  (local (value ?cmd) (match (tostring value-or-eq)
                        "+=" (values ?value :append)
                        "-=" (values ?value :remove)
                        "^=" (values ?value :prepend)
                        _ (values value-or-eq nil)))
  (if ?cmd
      (if (and (= ?cmd :remove) (sequence? value))
          ;; Remove options one-by-one to avoid issues (see :h set-=)
          (let [form `(do
                        )]
            (each [_ v (ipairs value)]
              (table.insert form `(: (. vim ,opt ,(tostring option)) ,?cmd ,v)))
            form)
          `(: (. vim ,opt ,(tostring option)) ,?cmd ,value))
      `(tset vim ,opt ,(tostring option) ,value)))

(local opt (partial opt* :opt))
(local opt-local (partial opt* :opt_local))

(fn map [modes lhs rhs ...]
  ;; (when _G.undo_ftplugin
  ;;   (table.insert _G.undo_ftplugin :blah))
  (local opts (collect [_ opt (ipairs [...])]
                (values opt true)))
  (if (not= nil opts.remap)
      (do
        (set opts.noremap (not opts.remap))
        (set opts.remap nil))
      (set opts.noremap true))
  (local buffer? (not= nil opts.buffer))
  (set opts.buffer nil)
  ;; XXX: Doesn't handle sym that references a string 
  (local str? (= :string (type rhs)))
  (when (not str?)
    (set opts.callback rhs))
  (local rhs (if str? rhs ""))
  (if (sequence? modes)
      (let [form `(do
                    )]
        (each [_ mode (ipairs modes)]
          (if buffer?
              (table.insert form
                            `(vim.api.nvim_buf_set_keymap 0 ,(tostring mode)
                                                          ,lhs ,rhs ,opts))
              (table.insert form
                            `(vim.api.nvim_set_keymap ,(tostring mode) ,lhs
                                                      ,rhs ,opts))))
        form)
      (if buffer?
          `(vim.api.nvim_buf_set_keymap 0 ,(tostring modes) ,lhs ,rhs ,opts)
          `(vim.api.nvim_set_keymap ,(tostring modes) ,lhs ,rhs ,opts))))

(fn undo_ftplugin [...]
  (let [cmd (.. " | " (table.concat [...] " | "))]
    `(vim.api.nvim_buf_set_var 0 :undo_ftplugin
                               (.. (or vim.b.undo_ftplugin :exe) ,cmd))))

;; (fn with-undo-ftplugin [...]
;;   (set _G.undo_ftplugin [])
;;   (local ast (macroexpand `(do
;;                              ,...) (get-scope)))
;;   (table.insert ast (undo_ftplugin (unpack _G.undo_ftplugin)))
;;   (set _G.undo_ftplugin nil)
;;   ast)

{: augroup
 : autocmd
 : opt
 : opt-local
 : map
 : undo_ftplugin
 ;; : with-undo-ftplugin
 }

