local configs = require("nvim-treesitter.configs")

local function large_buf(lang, bufnr)
  local size = vim.fn.getfsize(vim.fn.bufname(bufnr))
  return size > (1024 * 1024) or size == -2 or lang == "markdown"
end

-- Enable treesitter highlighting for lua
vim.g.ts_highlight_lua = true

configs.setup({
  ensure_installed = {"javascript", "fennel", "markdown", "markdown_inline", "query"},
  highlight = {enable = true, disable = large_buf},
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
    persist_queries = false,
  },
  textobjects = {
    move = {
      enable = true,
      disable = large_buf,
      goto_next_end = {["]a"] = "@parameter.inner"},
      goto_previous_start = {["[a"] = "@parameter.inner"},
      set_jumps = false,
    },
    select = {
      enable = true,
      disable = large_buf,
      lookahead = true,
      keymaps = {
        aF = "@function.outer",
        iF = "@function.inner",
        af = "@call.outer",
        ["if"] = "@call.inner",
        aB = "@block.outer",
        iB = "@block.inner",
        aa = "@parameter.outer",
        ia = "@parameter.inner",
      },
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "BufEnter"},
  },
})

-- From nvim-treesitter/playground
vim.keymap.set("n", "gy", "<Cmd>TSHighlightCapturesUnderCursor<CR>", {})
