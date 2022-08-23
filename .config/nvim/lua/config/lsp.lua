local lspconfig = require("lspconfig")
local function on_attach(_client, bufnr)
  local function buf_keymap(lhs, rhs)
    return vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, {noremap = true, silent = true})
  end
  buf_keymap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>zz")
  buf_keymap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>zz")
  buf_keymap("gh", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  buf_keymap("gm", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
  buf_keymap("gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_keymap("gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_keymap("gr", "<Cmd>lua vim.lsp.buf.rename()<CR>")
  buf_keymap("ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_keymap("ge", "<Cmd>lua vim.diagnostic.open_float()<CR>")
  buf_keymap("[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
  buf_keymap("]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
  buf_keymap("gl", "<Cmd>lua vim.diagnostic.setloclist()<CR>")
  return buf_keymap("<space>w", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
end
vim.diagnostic.config({virtual_text = {prefix = "\226\151\143"}})
local cfg = {on_attach = on_attach, flags = {debounce_text_changes = 150}}
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, cfg)
lspconfig.clangd.setup({})
return lspconfig.rls.setup({})
