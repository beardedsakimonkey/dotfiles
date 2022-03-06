(fn autocmd [group event pattern cmd ...]
  (each [_ opt (ipairs [...])]
    (assert-compile (or (= opt :++once) (= opt :++nested))
                    (.. "Invalid opt: " opt)))
  (local opts (collect [_ opt (ipairs [...])]
                opt
                true))
  (local (?pattern ?buffer)
         (if (sequence? pattern)
             (values (icollect [_ v (ipairs pattern)]
                       (tostring v)) nil)
             (let [pat (tostring pattern)]
               (match (string.match pat "^<buffer=?(%d*)>$")
                 nil (values pat nil)
                 "" (values nil 0)
                 num (values nil num)))))
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
                                 :once ,opts.++once
                                 :nested ,opts.++nested}))

(fn augroup [name ...]
  `(do
     (vim.api.nvim_create_augroup ,name {:clear true})
     (doto ,name ,...)))

(fn opt* [opt option ?value-or-eq ?value]
  (when _G.undo-cmds
    (table.insert _G.undo-cmds (.. "setl " (tostring option) "<")))
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
  (when _G.undo-cmds
    (table.insert _G.undo-cmds (.. "sil! nun <buffer> " lhs)))
  ;; By default, noremap is true
  (local opts (collect [_ opt (ipairs [...])]
                (values opt true)))
  (local modes (if (sequence? modes)
                   (icollect [_ mode (ipairs modes)]
                     (tostring mode))
                   (tostring modes)))
  `(vim.keymap.set ,modes ,lhs ,rhs ,opts))

(fn undo-ftplugin [...]
  (let [cmd (.. " | " (table.concat [...] " | "))]
    `(vim.api.nvim_buf_set_var 0 :undo_ftplugin
                               (.. (or vim.b.undo_ftplugin :exe) ,cmd))))

(fn helper []
  (undo-ftplugin (unpack _G.undo-cmds)))

(fn with-undo-ftplugin [...]
  (set _G.undo-cmds [])
  (local form `(do
                 ,...))
  (local scope (get-scope))
  (set scope.macros.helper helper)
  (table.insert form `(helper))
  form)

{: augroup
 : autocmd
 : opt
 : opt-local
 : map
 : undo-ftplugin
 : with-undo-ftplugin}

