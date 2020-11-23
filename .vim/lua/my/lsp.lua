local completion = require 'completion'
local lspconfig = require 'lspconfig'

local M = {}

local function on_attach()
    local bufnr = vim.api.nvim_get_current_buf()
    local keymaps = {
        ['<cr>'] = '<cmd>lua vim.lsp.buf.definition()<cr>',
        ['gd']   = '<cmd>lua vim.lsp.buf.declaration()<cr>',
        ['gh']   = '<cmd>lua vim.lsp.buf.hover()<cr>',
        ['gr']   = '<cmd>lua vim.lsp.buf.references()<cr>',
        ['gs']   = '<cmd>lua vim.lsp.buf.signature_help()<cr>',
        ['gt']   = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
        ['ge']   = "<cmd>lua vim.lsp.util.show_line_diagnostics()<cr>",
        ['R']    = '<cmd>lua vim.lsp.buf.rename()<cr>',
    }
    for lhs,rhs in pairs(keymaps) do
        vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true })
    end

    completion.on_attach()
end

-- vim.lsp.set_log_level('debug')

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        virtual_text = {
            prefix = '✘',
        },
        update_in_insert = false,
    }
)

lspconfig.rls.setup {
    on_attach = on_attach,
}

lspconfig.clangd.setup {
    on_attach = on_attach,
}

return M
