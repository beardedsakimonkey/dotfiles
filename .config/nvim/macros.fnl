(fn to-lua-string [sym]
  (let [str (.. :my__au__ (tostring sym))]
    (pick-values 1 (str:gsub "-" "_"))))

(fn autocmd [event pattern handler ...]
  (assert (sym? handler))
  (let [fn-name (to-lua-string handler)
        event (if (sequence? event)
                  (table.concat (icollect [_ v (ipairs event)]
                                  (tostring v))
                                ",")
                  :else
                  (tostring event))
        pattern (if (sequence? pattern)
                    (table.concat (icollect [_ v (ipairs pattern)]
                                    (tostring v))
                                  ",")
                    :else
                    (tostring pattern))
        opts (table.concat [...] " ")
        command (.. "lua " fn-name "()")]
    `(do
       ;; TODO: Check to make sure that we're not overriding an existing key
       (tset _G ,fn-name ,handler)
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
  (let [opts (collect [_ v (ipairs [...])]
               (values v true))]
    `(vim.api.nvim_set_keymap ,(tostring mode) ,lhs ,rhs ,opts)))

(fn no [mode lhs rhs ...]
  (map mode lhs rhs :noremap ...))

{: autocmd : set! : setlocal! : no : map}

