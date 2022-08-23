(local s\ vim.fn.shellescape)
(local f\ vim.fn.fnameescape)

(fn f-exists? [path]
  (= true (vim.loop.fs_access path :R)))

{: s\ : f\ : f-exists?}

