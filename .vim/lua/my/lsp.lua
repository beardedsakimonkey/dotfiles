local nvim_lsp = require 'nvim_lsp'
local util = require 'vim.lsp.util'
local protocol = require 'vim.lsp.protocol'

local M = {}

local diagnostic_ns = vim.api.nvim_create_namespace('my_lsp_diagnostics')

local function buf_diagnostics_virtual_text(bufnr, diagnostics)
  if not diagnostics then
    return
  end
  local buffer_line_diagnostics = util.diagnostics_group_by_line(diagnostics)
  for line, line_diags in pairs(buffer_line_diagnostics) do
    local virt_texts = {}
    for i = 1, #line_diags do
      local severity_name = protocol.DiagnosticSeverity[line_diags[i].severity]
      table.insert(virt_texts, {'✘', 'LspDiagnostics' .. severity_name})
    end
    vim.api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
  end
end

function M.update_diagnostics(bufnr, diagnostics)
  bufnr = bufnr or vim.api.nvim_win_get_buf(0)
  diagnostics = diagnostics or util.diagnostics_by_buf[bufnr] or {}

  util.buf_diagnostics_save_positions(bufnr, diagnostics)
  util.buf_diagnostics_underline(bufnr, diagnostics)
  buf_diagnostics_virtual_text(bufnr, diagnostics)
  -- util.buf_diagnostics_signs(bufnr, diagnostics)
  vim.api.nvim_command("doautocmd User LspDiagnosticsChanged")
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
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    util.buf_clear_diagnostics(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)

    local diagnostics = result.diagnostics

    local diagnostics_count = 0
    for _, diagnostic in ipairs(diagnostics) do
      if diagnostic.severity == nil then
        diagnostic.severity = protocol.DiagnosticSeverity.Error
      end
      if diagnostic.severity == protocol.DiagnosticSeverity.Error
        or diagnostic.severity == protocol.DiagnosticSeverity.Warning then
        diagnostics_count = diagnostics_count + 1
      end
    end

    -- update diagnostics count buffer variable for the statusline
    vim.fn.setbufvar(bufnr, 'diagnostics_count', diagnostics_count)

    local mode = vim.api.nvim_get_mode().mode
    local in_insert_mode = mode == 'i' or mode == 'ic'
    if not in_insert_mode then
      M.update_diagnostics(bufnr, diagnostics)
    end
  end
end

local function setup_keymaps(bufnr)
  local keymaps = {
    ['<cr>'] = '<cmd>lua vim.lsp.buf.definition()<cr>',
    ['gd'] = '<cmd>lua vim.lsp.buf.declaration()<cr>',
    ['gh'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
    ['gr'] = '<cmd>lua vim.lsp.buf.references()<cr>',
    ['gs'] = '<cmd>lua vim.lsp.buf.signature_help()<cr>',
    ['gt'] = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
    ['ge'] = "<cmd>lua vim.lsp.util.show_line_diagnostics()<cr>",
    ['R'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
  }
  for lhs,rhs in pairs(keymaps) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true })
  end
end

local function on_attach()
  local bufnr = vim.api.nvim_get_current_buf()
  setup_keymaps(bufnr)

  monkey_patch_diagnostics()

  vim.api.nvim_command('augroup my_lsp')
  vim.api.nvim_command('autocmd! * <buffer>')
  vim.api.nvim_command('autocmd InsertLeave <buffer> lua require"my.lsp".update_diagnostics()')
  vim.api.nvim_command('augroup end')

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

if not vim.g.loaded_my_lsp then
  nvim_lsp.rls.setup{
    on_attach = on_attach,
  }

  nvim_lsp.vimls.setup{
    on_attach = on_attach,
  }

  nvim_lsp.sumneko_lua.setup{
    on_attach = on_attach,
    settings = {
      runtime = {
        version = 'Lua 5.1',
      },
      Lua = {
        diagnostics = {
          globals = {'vim', 'unpack'}
        }
      }
    }
  }
end
vim.g.loaded_my_lsp = true

-- vim.lsp.set_log_level('debug')

package.loaded['my.lsp'] = nil
return M