local nvim_lsp = require 'nvim_lsp'
local configs = require 'nvim_lsp/configs'
local util = require 'vim.lsp.util'
local protocol = require 'vim.lsp.protocol'

local M = {}

local function on_attach()
    local bufnr = vim.api.nvim_get_current_buf()
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
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

if not vim.g.loaded_my_lsp then
    nvim_lsp.rls.setup{
        on_attach = on_attach,
    }

    nvim_lsp.vimls.setup{
        on_attach = on_attach,
    }

    nvim_lsp.clangd.setup{
        on_attach = on_attach,
    }
end
vim.g.loaded_my_lsp = true

-- vim.lsp.set_log_level('debug')

package.loaded['my.lsp'] = nil
return M
