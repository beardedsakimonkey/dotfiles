(import-macros {: au} :macros)
(local uv vim.loop)

(fn strip-trailing-newline [str]
  (if (= "\n" (str:sub -1)) (str:sub 1 -2) str))

(fn edit-url []
  (local file (vim.fn.expand :<afile>))
  (local stdout (uv.new_pipe))
  (local stderr (uv.new_pipe))

  (fn on-exit [exit-code signal]
    (if (not= 0 exit-code)
        (print (string.format "spawn failed (exit code %d, signal %d)"
                              exit-code signal))))

  (local opts {:stdio [nil stdout stderr]
               :args [; follow redirects
                      :--location
                      :--silent
                      :--show-error
                      (vim.fn.expand :<afile>)]})
  (local (handle pid) (uv.spawn :curl opts on-exit))

  (fn on-stdout/err [?err ?data]
    (assert (not ?err) ?err)
    (when (not= nil ?data)
      (local lines (vim.split (strip-trailing-newline ?data) "\n"))
      (vim.schedule (fn []
                      (local start (if vim.bo.modified -1 0))
                      (vim.api.nvim_buf_set_lines 0 start -1 false lines)))))

  (uv.read_start stdout on-stdout/err)
  (uv.read_start stderr on-stdout/err))

(vim.cmd "augroup edit_url | au!")
(au :BufNewFile [http://* https://*] edit-url)
(vim.cmd "augroup END")

