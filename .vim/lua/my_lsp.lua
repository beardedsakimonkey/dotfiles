local nvim_lsp = require 'nvim_lsp'
local util = require 'vim.lsp.util'
local protocol = require 'vim.lsp.protocol'

local M = {}

function M.update_diagnostics(bufnr, diagnostics)
  bufnr = bufnr or vim.api.nvim_win_get_buf(0)
  diagnostics = diagnostics or util.diagnostics_by_buf[bufnr]
  util.buf_diagnostics_save_positions(bufnr, diagnostics)
  util.buf_diagnostics_underline(bufnr, diagnostics)
  -- util.buf_diagnostics_virtual_text(bufnr, diagnostics)
  util.buf_diagnostics_signs(bufnr, diagnostics)
  vim.api.nvim_command("doautocmd User LspDiagnosticsChanged")

  -- vim.fn.setqflist({}, 'a', {
  --   title = 'Language Server';
  --   items = vim.lsp.util.locations_to_items(diagnostics);
  -- })
end

local function monkey_patch_diagnostics()
  vim.lsp.callbacks['textDocument/publishDiagnostics'] = function(_, _, result)
    if not result then return end
    local uri = result.uri
    local bufnr = vim.uri_to_bufnr(uri)
    if not bufnr then
      vim.lsp.err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
      return
    end

    util.buf_clear_diagnostics(bufnr)

    local diagnostics = result.diagnostics

    for _, diagnostic in ipairs(diagnostics) do
      if diagnostic.severity == nil then
        diagnostic.severity = protocol.DiagnosticSeverity.Error
      end
    end

    local mode = vim.api.nvim_get_mode().mode
    local in_insert_mode = mode == 'i' or mode == 'ic'
    if not in_insert_mode then
      M.update_diagnostics(bufnr, diagnostics)
    end
  end
end

local function setup_keymaps(bufnr)
  local keymaps = {
    ['<cr>'] = '<cmd>lua vim.lsp.buf.declaration()<cr>',
    ['T'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
    ['gR'] = '<cmd>lua vim.lsp.buf.references()<cr>',
    ['gr'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
    ['gd'] = "<cmd>lua vim.lsp.util.show_line_diagnostics()<cr>",
  }
  for lhs,rhs in pairs(keymaps) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true })
  end
end

local function on_attach()
  local bufnr = vim.api.nvim_get_current_buf()
  setup_keymaps(bufnr)

  monkey_patch_diagnostics()
  vim.api.nvim_command [[augroup my_lsp]]
  vim.api.nvim_command [[autocmd! * <buffer>"]]
  vim.api.nvim_command [[autocmd InsertLeave <buffer> lua require'my_lsp'.update_diagnostics()]]
  vim.api.nvim_command [[augroup end]]

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

nvim_lsp.rust_analyzer.setup{
  on_attach = on_attach,
}

nvim_lsp.vimls.setup{
  on_attach = on_attach,
}

nvim_lsp.sumneko_lua.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = {"vim"}
      }
    }
  }
}

-- vim.lsp.set_log_level("debug")

return M
