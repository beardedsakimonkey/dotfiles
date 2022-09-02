(local s\ vim.fn.shellescape)
(local f\ vim.fn.fnameescape)

(local $HOME (os.getenv :HOME))
(local $TMUX (os.getenv :TMUX))

(fn exists? [path]
  ;; Passing "" as the mode corresponds to access(2)'s F_OK
  (= true (vim.loop.fs_access path "")))

;; Use this over `vim.fn.system` if you want to avoid blocking the main thread.
;; Usage: (system [:curl :-i :google.com] (fn [stdout stderr exit-code] ...))
(fn system [cmd-parts cb]
  (local stdout-pipe (vim.loop.new_pipe))
  (local stderr-pipe (vim.loop.new_pipe))
  ;; Not using arrays because chunks of stdout/err can stop mid-line, which
  ;; would add complication.
  (var stdout "")
  (var stderr "")

  (fn on-exit [exit-code _signal]
    (cb stdout stderr exit-code))

  (local [cmd & args] cmd-parts)
  (vim.loop.spawn cmd {:stdio [nil stdout-pipe stderr-pipe] : args} on-exit)

  (fn on-stdout/err [stdout? ?err ?data]
    (assert (not ?err) ?err)
    (when (not= nil ?data)
      (if stdout?
          (set stdout (.. stdout ?data))
          (set stderr (.. stderr ?data)))))

  (vim.loop.read_start stdout-pipe (partial on-stdout/err true))
  (vim.loop.read_start stderr-pipe (partial on-stdout/err false)))

{: s\ : f\ : $HOME : $TMUX : exists? : system}

