(import-macros {: map} :macros)

(fn jump-to-node [node]
  (local (row col) (node:start))
  (vim.api.nvim_win_set_cursor 0 [(+ 1 row) col]))

(fn fn-motion []
  (local parser (vim.treesitter.get_parser 0))
  (local [tree] (parser:parse))
  (local root (tree:root))
  (local [row col] (vim.api.nvim_win_get_cursor 0))
  (local node (root:descendant_for_range (- row 1) col (- row 1) col))
  (var ?found nil)
  (var cur node)
  (while (and (not ?found) cur)
    (print (cur:type))
    (when (= :fn (cur:type))
      (set ?found cur))
    (set cur (cur:parent)))
  (when ?found
    (jump-to-node ?found)))

(map n "[a" #(fn-motion))

