local cmp = require("cmp")

local function small(buf)
  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
  return byte_size < (1024 * 1024)  -- Less than 1 MB
end

-- Source buffer words from visible, non-huge buffers
local function get_bufnrs()
  local visible_bufs = {}  -- table to ensure a unique set of bufs
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if small(buf) then
      visible_bufs[buf] = true
    else
    end
  end
  return vim.tbl_keys(visible_bufs)
end

cmp.setup({
  sources = {
    {name = "buffer", option = {get_bufnrs = get_bufnrs}},
    {name = "path"},
    {name = "nvim_lua"},
    {name = "nvim_lsp"}
  },
  snippet = {expand = function() end},
  mapping = {
    ["<Tab>"] = cmp.mapping.confirm({select = true}),
    ["<C-j>"] = function()
      if cmp.visible() then
        return cmp.select_next_item()
      else
        return cmp.complete()
      end
    end,
    ["<C-k>"] = function()
      if cmp.visible() then
        return cmp.select_prev_item()
      else
        return cmp.complete()
      end
    end,
  },
  experimental = {ghost_text = true},
})
cmp.setup.filetype({"neorepl"}, {enabled = false})
