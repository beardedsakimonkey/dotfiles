;; Highlight keyword-style strings (e.g. `:foo`) as keyword
((string) @keyword (#match? @keyword "^:"))

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @comment

"λ" @keyword.function

((symbol) @function.builtin
 (#any-of? @function.builtin
  "not" "not=" "or" "and"))

(ERROR) @error
