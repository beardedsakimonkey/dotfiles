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
       ;; TODO: Check to make sure that we're not overriding an existing key
       ,(if fn-name `(tset _G ,fn-name ,handler))
       (vim.cmd ,(.. "autocmd " event " " pattern " " opts " " command)))))

(fn set! [option value]
  (let [opt (tostring option)
        val (match (type value)
              :nil true
              _ value)]
    `(tset vim.opt ,opt ,val)))

(fn setlocal! [option value]
  (let [opt (tostring option)
        val (match (type value)
              :nil true
              _ value)]
    `(tset vim.opt_local ,opt ,val)))

(fn setlocal+= [option value]
  (assert-compile (sym? option) "expected sym for option" option)
  `(: (. vim.opt_local ,(tostring option)) :append ,value))

(fn filter [keep? list]
  (icollect [_ v (ipairs list)]
    (when (keep? v)
      v)))

(fn contains? [matches? list]
  (var found false)
  (each [_ v (ipairs list) :until found]
    (when (matches? v)
      (set found true)))
  found)

;; TODO: Support list of modes
(fn map [mode lhs rhs ...]
  (let [fn-name (if (sym? rhs) (to-lua-string rhs :my__map__) nil)
        buffer (contains? #(= :buffer $1) [...])
        opts (collect [_ v (ipairs (filter #(not= :buffer $1) [...]))]
               (values v true))
        command (if fn-name
                    (if opts.expr
                        (.. "v:lua." fn-name "()")
                        (.. "<Cmd>lua " fn-name "()<CR>"))
                    rhs)]
    `(do
       ,(if fn-name `(tset _G ,fn-name ,rhs))
       ,(if buffer
            `(vim.api.nvim_buf_set_keymap 0 ,(tostring mode) ,lhs ,command
                                          ,opts)
            `(vim.api.nvim_set_keymap ,(tostring mode) ,lhs ,command ,opts)))))

(fn no [mode lhs rhs ...]
  (map mode lhs rhs :noremap ...))

(fn undo_ftplugin [...]
  (let [cmd (.. " | " (table.concat [...] " | "))]
    `(vim.api.nvim_buf_set_var 0 :undo_ftplugin
                               (.. (or vim.b.undo_ftplugin :exe) ,cmd))))

{: au : set! : setlocal! : setlocal+= : no : map : undo_ftplugin}

