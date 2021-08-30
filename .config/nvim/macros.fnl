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

(fn map [mode lhs rhs ...]
  (let [fn-name (if (sym? rhs) (to-lua-string rhs :my__map__) nil)
        opts (collect [_ v (ipairs [...])]
               (values v true))
        command (if fn-name
                    (if opts.expr
                        (.. "v:lua." fn-name "()")
                        (.. "<Cmd>lua " fn-name "()<CR>"))
                    rhs)]
    `(do
       ,(if fn-name `(tset _G ,fn-name ,rhs))
       (vim.api.nvim_set_keymap ,(tostring mode) ,lhs ,command ,opts))))

(fn no [mode lhs rhs ...]
  (map mode lhs rhs :noremap ...))

{: au : set! : setlocal! : no : map}

