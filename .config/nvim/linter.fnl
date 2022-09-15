;; TODO:
;;  - better checking of module fields
;;    - follow destructres
;;    - somehow avoid staleness issues
;;  - better arity-check
;;    - follow destructres
;;    - arity-check local function
;;  - better checking of unused locals
;;    - handle destructuring, e.g. `(local [a] 1)`
;;    - support `let` and `import-macros`

(local inspect (require :inspect))

;; -- destrucutre --------------------------------------------------------------

(fn descend [target [part & parts]]
  (if (= nil part) target
      (= :table (type target)) (match (. target part)
                                 new-target (descend new-target parts))
      target))

(fn require? [rhs]
  (and (list? rhs) (sym? (. rhs 1)) (= :require (tostring (. rhs 1)))
       (= :string (type (. rhs 2)))))

;; (fn rec* [node path cb]
;;   (each [k v (pairs node)]
;;     (when (sym? v)
;;       (cb (.. path "." k) v))))

;; (fn rec [node cb]
;;   (rec* node "" cb))

;; When destructuring a `require`, save symmeta for the created bindings. Also
;; perform existence checks on the destructured fields.
(fn on-destructure [rhs lhs scope opts]
  (when (require? rhs)
    (when (sym? lhs)
      (local meta (. scope.symmeta (tostring lhs)))
      (set meta.required (tostring (. rhs 2))))
    ;; (when (table? lhs)
    ;;   (rec lhs "" #(print $1 $2))
    ;; (each [k v (pairs lhs)]
    ;;   (table.insert path k)
    ;;   (print k (inspect v))
    ;;   (when (sym? v)
    ;;     (local meta (. scope.symmeta (tostring v)))
    ;;     (set meta.required (tostring v))))
    ))

;; -- symbol-to-expression -----------------------------------------------------

(fn has-fields? [module-name parts]
  (local module (and module-name (require module-name)))
  (local target (descend module parts))
  (or (= nil module) (not= nil target)))

(fn on-symbol-to-expression [symbol scope]
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

;; -- call ---------------------------------------------------------------------

(fn arity-check? [module module-name]
  (or (-?> module getmetatable (. :arity-check?)) (pcall debug.getlocal #nil 1)))

(fn min-arity [target nparams]
  (match (debug.getlocal target nparams)
    localname (if (and (localname:match :^_3f) (< 0 nparams))
                  (min-arity target (- nparams 1))
                  nparams)
    _ nparams))

(fn getfn [v]
  (if (= :function (type v)) [v false]
      (let [mt (getmetatable v)]
        (if (and (= :table (type v)) (= :table (type mt))
                 (= :function (type mt.__call))) [mt.__call true]
            [v false]))))

(fn on-call [[f & args] scope]
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

;; -- check-unused -------------------------------------------------------------

(fn local? [ast name]
  (and (= :table (type ast)) (= :table (type (. ast 1)))
       (or (= :local (. ast 1 1)) (= :var (. ast 1 1)))
       (= :table (type (. ast 2))) (= name (. ast 2 1))))

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

(fn check-unused [ast scope]
  (each [symname (pairs scope.symmeta)]
    (local valid? (or (. scope.symmeta symname :used) (symname:find "^_")))
    (when (not valid?)
      (local name (or symname "?"))
      (assert-compile false (: "unused local %s" :format name)
                      (or (find-local ast name) ast)))))

{:destructure on-destructure
 :symbol-to-expression on-symbol-to-expression
 :call on-call
 :fn check-unused
 :do check-unused
 :chunk check-unused
 :name :my/linter
 :versions [:1.3.0]}
