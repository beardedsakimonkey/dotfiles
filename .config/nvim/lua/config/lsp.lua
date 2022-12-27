local lspconfig = require("lspconfig")

local function on_attach(_client, bufnr)
    -- The built-in on_attach handler sets this to use the lsp server. But this
    -- means we can't gq on comments. So reset it.
    vim.bo[bufnr]["formatexpr"] = ""
    local function buf_keymap(lhs, rhs)
        return vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, {noremap = true, silent = true})
    end

    -- NOTE: Diagnostic mappings are in mappings.fnl because they aren't
    -- necessarily associated with an lsp.
    buf_keymap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
    buf_keymap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
    buf_keymap("gh", "<Cmd>lua vim.lsp.buf.hover()<CR>")
    buf_keymap("gm", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
    buf_keymap("gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
    buf_keymap("gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
    buf_keymap("gr", "<Cmd>lua vim.lsp.buf.rename()<CR>")
    buf_keymap("ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
    buf_keymap("<space>w", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
end

vim.diagnostic.config({signs = false, virtual_text = false})

local textDocument_2fdefinition = vim.lsp.handlers["textDocument/definition"]

local function location_handler(...)
    textDocument_2fdefinition(...)
    vim.cmd("normal! zz")
end

vim.lsp.handlers["textDocument/definition"] = location_handler

local cfg = {on_attach = on_attach, flags = {debounce_text_changes = 150}}

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, cfg)
lspconfig.clangd.setup({})
lspconfig.rls.setup({})

lspconfig.sumneko_lua.setup({
    root_dir = function(fname)
        local util = require("lspconfig.util")
        local root_files = {".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml"}
        local root = (util.root_pattern(unpack(root_files))(fname) or util.root_pattern("lua/")(fname))
        -- Don't scan the home directory
        -- https://github.com/sumneko/lua-language-server/wiki/FAQ#why-is-the-server-scanning-the-wrong-folder
        if (root ~= vim.env.HOME) then
            return root
        end
    end,
    -- See https://github.com/sumneko/lua-language-server/wiki/Settings
    settings = {
        Lua = {
            telemetry = {enable = false},
            diagnostics = {globals = {"vim"}},
            -- cmp doesn't support lsp snippets without using certain plugins
            completion = {keywordSnippet = false},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            runtime = {version = "LuaJIT"},
        },
    },
})
