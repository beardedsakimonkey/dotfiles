local cmp = require("cmp")
local function small_3f(buf)
  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
  return (byte_size < (1024 * 1024))
end
local function get_bufnrs()
  local visible_bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if small_3f(buf) then
      visible_bufs[buf] = true
    else
    end
  end
  return vim.tbl_keys(visible_bufs)
end
return cmp.setup({sources = {{name = "buffer", option = {get_bufnrs = get_bufnrs}}, {name = "path"}, {name = "nvim_lua"}, {name = "nvim_lsp"}}, mapping = {["<Tab>"] = cmp.mapping.confirm({select = true}), ["<C-j>"] = cmp.mapping.select_next_item(), ["<C-k>"] = cmp.mapping.select_prev_item()}, experimental = {ghost_text = true}})
