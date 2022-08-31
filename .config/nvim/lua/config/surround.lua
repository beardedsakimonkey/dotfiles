local nvim_surround = require("nvim-surround")
local config = require("nvim-surround.config")
local get_selection = config["get_selection"]

-- Addapted from surround.mini
local get_line_cols = function(line_num) return vim.fn.getline(line_num):len() end

local pos_to_left = function(pos)
  if pos.line == 1 and pos.col == 1 then return { line = pos.line, col = pos.col } end
  if pos.col == 1 then return { line = pos.line - 1, col = get_line_cols(pos.line - 1) } end
  return { line = pos.line, col = pos.col - 1 }
end

local pos_to_right = function(pos)
  local n_cols = get_line_cols(pos.line)
  -- Using `>` and not `>=` helps with removing '\n' and in the last line
  if pos.line == vim.api.nvim_buf_line_count(0) and pos.col > n_cols then return { line = pos.line, col = n_cols } end
  if pos.col > n_cols then return { line = pos.line + 1, col = 1 } end
  return { line = pos.line, col = pos.col + 1 }
end

function get_biggest_node(nodes)
  local biggest_node, biggest_byte_count = nil, -math.huge
  for _, node in ipairs(nodes) do
    local _, _, start_byte = node:start()
    local _, _, end_byte = node:end_()
    local byte_count = end_byte - start_byte + 1
    if biggest_byte_count < byte_count then
      biggest_node, biggest_byte_count = node, byte_count
    end
  end
  return biggest_node
end

function get_selections(captures)
  captures.inner = type(captures.inner) == "string" and { captures.inner } or captures.inner
  captures.outer = type(captures.outer) == "string" and { captures.outer } or captures.outer

  local ts_query = require('nvim-treesitter.query')

  local outer_matches = {}
  for _, capture in ipairs(captures.outer) do
    local m = ts_query.get_capture_matches_recursively(0, capture, 'textobjects')
    vim.list_extend(outer_matches, m)
  end

  local matched_node_pairs = vim.tbl_map(
    function (outer_match)
      local outer_node = outer_match.node
      -- Pick inner node as the biggest node matching inner query. This is
      -- needed because query output is not quaranteed to come in order.
      local inner_matches = {}
      for _, capture in ipairs(captures.inner) do
        local m = ts_query.get_capture_matches(0, capture, 'textobjects', outer_node)
        vim.list_extend(inner_matches, m)
      end
      local inner_nodes = vim.tbl_map(function(x) return x.node end, inner_matches)
      return { outer = outer_node, inner = get_biggest_node(inner_nodes) }
    end,
    outer_matches
  )

  local selections = vim.tbl_map(function(node_pair)
    -- `node:range()` returns 0-based numbers for end-exclusive region
    local left_from_line, left_from_col, right_to_line, right_to_col = node_pair.outer:range()
    local left_from = { line = left_from_line + 1, col = left_from_col + 1 }
    local right_to = { line = right_to_line + 1, col = right_to_col }

    local left_to, right_from
    if node_pair.inner == nil then
      left_to = right_to
      right_from = pos_to_right(right_to)
      right_to = nil
    else
      local left_to_line, left_to_col, right_from_line, right_from_col = node_pair.inner:range()
      left_to = { line = left_to_line + 1, col = left_to_col + 1 }
      right_from = { line = right_from_line + 1, col = right_from_col }
      -- Take into account that inner capture should be both edges exclusive
      left_to, right_from = pos_to_left(left_to), pos_to_right(right_from)
    end

    return {
      left = {
        first_pos = { left_from.line, left_from.col },
        last_pos = { left_to.line, left_to.col },
      },
      right = {
        first_pos = { right_from.line, right_from.col },
        last_pos = { right_to.line, right_to.col },
      },
    }
  end, matched_node_pairs)

  local best_selection = require('nvim-surround.utils').filter_selections_list(selections)
  return best_selection
end

nvim_surround.setup({
  surrounds = {
    F = {
      delete = function ()
        return get_selections({
          inner = "@function.inner",
          outer = "@function.outer",
        })
      end,
      -- find = function ()
      --   return get_selection({query = {capture = "@function.outer", type = "textobjects"}})
      -- end,
    },
    o = {
      delete = function ()
        return get_selections({
          inner = {"@conditional.inner", "@loop.inner"},
          outer = {"@conditional.outer", "@loop.outer"},
        })
      end,
      -- find = function ()
      --   return get_selection({query = {capture = "@conditional.outer", type = "textobjects"}})
      -- end,
    },
    B = {
      delete = function ()
        return get_selections({
          inner = "@block.inner",
          outer = "@block.outer",
        })
      end,
    },
  },
  aliases = { B = false },
  indent_lines = false,
})
