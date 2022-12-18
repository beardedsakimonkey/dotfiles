local lspconfig = require("lspconfig")
local function on_attach(_client, bufnr)
  vim.bo[bufnr]["formatexpr"] = ""
  local function buf_keymap(lhs, rhs)
    return vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, {noremap = true, silent = true})
  end
  buf_keymap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
  buf_keymap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  buf_keymap("gh", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  buf_keymap("gm", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
  buf_keymap("gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_keymap("gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_keymap("gr", "<Cmd>lua vim.lsp.buf.rename()<CR>")
  buf_keymap("ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  return buf_keymap("<space>w", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
end
vim.diagnostic.config({signs = false, virtual_text = false})
local textDocument_2fdefinition = vim.lsp.handlers["textDocument/definition"]
local function location_handler(...)
  textDocument_2fdefinition(...)
  return vim.cmd("normal! zz")
end
vim.lsp.handlers["textDocument/definition"] = location_handler
local cfg = {on_attach = on_attach, flags = {debounce_text_changes = 150}}
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, cfg)
lspconfig.clangd.setup({})
lspconfig.rls.setup({})
local root_files = {".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml"}
local function _1_(fname)
  local util = require("lspconfig.util")
  local root = (util.root_pattern(unpack(root_files))(fname) or util.root_pattern("lua/")(fname))
  if (root ~= vim.env.HOME) then
    return root
  else
    return nil
  end
end
return lspconfig.sumneko_lua.setup({root_dir = _1_, settings = {Lua = {telemetry = {enable = false}, diagnostics = {globals = {"vim"}}, completion = {keywordSnippet = false}, workspace = {library = vim.api.nvim_get_runtime_file("", true)}, runtime = {version = "LuaJIT"}}}})
