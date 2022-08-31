(fn descend [target [part & parts]]
  (if (= nil part) target
      (= :table (type target)) (match (. target part)
                                 new-target (descend new-target parts))
      target))

(fn set-set-meta [to scope opts]
  (when (not (or opts.declaration (multi-sym? to)))
    (if (sym? to)
        (tset scope.symmeta (tostring to) :set true)
        (each [_ sub (ipairs to)]
          (set-set-meta sub scope opts)))))

(fn save-meta [from to scope opts]
  "When destructuring, save module name if local is bound to a `require' call.
  Doesn't do any linting on its own; just saves the data for other linters."
  (when (and (sym? to) (not (multi-sym? to)) (list? from) (sym? (. from 1))
             (= :require (tostring (. from 1))) (= :string (type (. from 2))))
    (let [meta (. scope.symmeta (tostring to))]
      (set meta.required (tostring (. from 2)))))
  (set-set-meta to scope opts))

(fn has-fields? [module-name parts]
  (local module (and module-name (require module-name)))
  (local target (descend module parts))
  (or (= nil module) (not= nil target)))

(fn check-module-fields [symbol scope]
  "When referring to a field in a local that's a module, make sure it exists."
  (let [[module-local & parts] (or (multi-sym? symbol) [])
        module-name (-?> scope.symmeta (. (tostring module-local))
                         (. :required))
        field (table.concat parts ".")]
    (var has-fields (has-fields? module-name parts))
    ;; If not found, clear the module cache and retry in case it's stale
    (when (and (not has-fields) (not= nil (. package.loaded module-name)))
      (tset package.loaded module-name nil)
      (set has-fields (has-fields? module-name parts)))
    (assert-compile has-fields
                    (string.format "Missing field %s in module %s"
                                   (or field "?") (or module-name "?"))
                    symbol)))

(fn arity-check? [module module-name]
  (or (-?> module getmetatable (. :arity-check?)) (pcall debug.getlocal #nil 1)
      ; PUC 5.1 can't use debug.getlocal for this
      ;; I don't love this method of configuration but it gets the job done.
      (match (and module-name os os.getenv (os.getenv :FENNEL_LINT_MODULES))
        module-pattern (module-name:find module-pattern))))

(fn min-arity [target nparams]
  (match (debug.getlocal target nparams)
    localname (if (and (localname:match :^_3f) (< 0 nparams))
                  (min-arity target (- nparams 1))
                  nparams)
    _ nparams))

;; TODO: cleanup
(fn getfn [v]
  (if (= :function (type v)) [v false]
      (let [mt (getmetatable v)]
        (if (and (= :table (type v)) (= :table (type mt))
                 (= :function (type mt.__call))) [mt.__call true]
            [v false]))))

(fn arity-check-call [[f & args] scope]
  "Perform static arity checks on static function calls in a module."
  (let [last-arg (. args (length args))
        arity (if (: (tostring f) :find ":") ; method
                  (+ (length args) 1) (length args))
        [f-local & parts] (or (multi-sym? f) [])
        module-name (-?> scope.symmeta (. (tostring f-local)) (. :required))
        module (and module-name (require module-name))
        field (table.concat parts ".")
        [target is-metamethod] (getfn (descend module parts))
        arity (if is-metamethod (+ 1 arity) arity)]
    (when (and (arity-check? module module-name) _G.debug _G.debug.getinfo
               module (not (varg? last-arg)) (not (list? last-arg)))
      (assert-compile (= :function (type target))
                      (string.format "Missing function %s in module %s"
                                     (or field "?") module-name)
                      f)
      (match (_G.debug.getinfo target)
        {: nparams :what :Lua} (let [min (min-arity target nparams)]
                                 ;; TODO: clear cache and retry
                                 (assert-compile (<= min arity)
                                                 (: "Called %s with %s arguments, expected at least %s"
                                                    :format f arity min)
                                                 f))))))

;; ;; Note that this will only check unused args inside functions and let blocks,
;; ;; not top-level locals of a chunk.
;; (fn check-unused [ast scope]
;;   (each [symname (pairs scope.symmeta)]
;;     (let [meta (. scope.symmeta symname)]
;;       (assert-compile (or meta.used (symname:find "^_"))
;;                       (string.format "unused local %s" (or symname :?)) ast)
;;       (assert-compile (or (not meta.var) meta.set)
;;                       (string.format "%s declared as var but never set"
;;                                      symname) ast))))

;; NOTE: `inspect` is found in /usr/local/share/lua/5.1/inspect.lua
;; (local inspect (require :inspect))

;; (fn remove-all-metatables [item path]
;;   (when (not= (. path (length path)) inspect.METATABLE)
;;     item))

(fn local? [ast name]
  (and (= :table (type ast)) (= :table (type (. ast 1)))
       (or (= :local (. ast 1 1)) (= :var (. ast 1 1)))
       (= :table (type (. ast 2))) (= name (. ast 2 1))))

;; Example ast (non-sequential elements removed):
;;
;; {
;;   {
;;     "fn",
;;   },
;;   {
;;   },
;;   {
;;     {
;;       "dir",
;;     }
;;   },
;;   {
;;     {
;;       "local",
;;     },
;;     {
;;       "bar",
;;     }, 1,
;;   },
;; }

(fn find-local [ast name]
  (if (or (not ast) (not= :table (type ast)))
      nil
      (if (local? ast name)
          ast
          (do
            (var ?res nil)
            (each [_ v (ipairs ast) :until ?res]
              (set ?res (find-local v name)))
            ?res))))

;; For the `fn` and `do` hooks, the `ast` is the outer node (e.g. the function
;; or the let form). Instead of passing this node to assert-compile and getting
;; an inaccurate error location, we search for the first `local` in the ast that
;; matches the unused local. For the `chunk` hook, the `ast` is the bottom most
;; node for some reason. Maybe fennel mutates `ast` before calling the hook?

;; FIXME: Doesn't handle destructuring, e.g. `(local [a] 1)`. Also doesn't
;; support `let` or `import-macros`.

(fn check-unused [ast scope]
  (each [symname (pairs scope.symmeta)]
    (local valid? (or (. scope.symmeta symname :used) (symname:find "^_")))
    (when (not valid?)
      (local name (or symname "?"))
      (assert-compile false (: "unused local %s" :format name)
                      (or (find-local ast name) ast)))
    ;; (when (not valid?)
    ;;   (assert-compile valid?
    ;;                   (: "%s," :format
    ;;                      (inspect ast {:process remove-all-metatables}))
    ;;                   ast))
    ))

{:destructure save-meta
 :symbol-to-expression check-module-fields
 :call arity-check-call
 :fn check-unused
 :do check-unused
 :chunk check-unused
 :name :my/linter
 :versions [:1.0.0 :1.1.0 :1.2.0 :1.3.0]}

