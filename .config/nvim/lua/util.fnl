(local s\ vim.fn.shellescape)
(local f\ vim.fn.fnameescape)

(fn f-exists? [path]
  ;; Passing "" as the mode corresponds to access(2)'s F_OK
  (= true (vim.loop.fs_access path "")))

{: s\ : f\ : f-exists?}

