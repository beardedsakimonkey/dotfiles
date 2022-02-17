;; TODO: Create `command` macro using nvim_add_user_command

;; TODO: Use nvim_define_autocmd (pending https://github.com/neovim/neovim/pull/14661)
;; Create an `augroup` macro that splices group name into each form. This should
;; make it so we can guarantee that an autocmd has a group name.

(fn to-lua-string [sym prefix]
  (let [str (.. prefix (tostring sym))]
    (pick-values 1 (str:gsub "-" "_"))))

(fn join-syms [syms]
  (if (sequence? syms)
      (table.concat (icollect [_ v (ipairs syms)]
                      (tostring v)) ",")
      (tostring syms)))

(fn au [event pattern handler ...]
  (let [fn-name (if (sym? handler) (to-lua-string handler :my__au__) nil)
        event (join-syms event)
        pattern (join-syms pattern)
        opts (table.concat [...] " ")
        command (if fn-name (.. "lua " fn-name "()") handler)]
    `(do
       ,(if fn-name `(tset _G ,fn-name ,handler))
       (vim.cmd ,(.. "autocmd " event " " pattern " " opts " " command)))))

;;
;; Macros for :set and :setlocal
;;
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

;;
;; Macro for :noremap, etc
;;
(fn map [modes lhs rhs ...]
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

;;
;; Macro for b:undo_ftplugin
;;
(fn undo_ftplugin [...]
  (let [cmd (.. " | " (table.concat [...] " | "))]
    `(vim.api.nvim_buf_set_var 0 :undo_ftplugin
                               (.. (or vim.b.undo_ftplugin :exe) ,cmd))))

{: au : opt : opt-local : map : undo_ftplugin}

