vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    virtual_lines = false,
    signs = false,
})

com('LspLog', function() vim.cmd('tabnew ' .. vim.lsp.log.get_filename()) end)
com('LspStatus', function()
    local clients = vim.lsp.get_clients({bufnr = 0})
    if vim.tbl_isempty(clients) then
        vim.notify('No LSP clients attached to the current buffer.', vim.log.levels.INFO)
        return
    end
    local lines = {}
    for _, client in ipairs(clients) do
        table.insert(lines, ('%s (id %d)'):format(client.name, client.id))
    end
    vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end)

local au = aug'my/lsp'

au('LspAttach', '*', function(args)
    local buf = args.buf
    -- Don't install LSP keymaps/settings on special buffers (e.g. dora's
    -- nofile buffer), where they'd clobber the buffer's own buffer-local maps.
    if vim.bo[buf].buftype ~= '' then return end
    -- The built-in on_attach handler sets this to use the lsp server. But this
    -- means we can't gq on comments. So reset it.
    vim.bo[buf].formatexpr = nil
    vim.bo[buf].autocomplete = true

    local function map(lhs, rhs)
        vim.keymap.set('n', lhs, rhs, {noremap = true, silent = true, buffer = buf})
    end
    vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', {buffer = buf})
    map('gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
    map('gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
    map('gi', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    map('gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('gr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
    map('gR', '<Cmd>lua vim.lsp.buf.references()<CR>')
    map('ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
    map(',f', '<Cmd>lua vim.lsp.buf.format({async=true})<CR>')
    map('g0', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>')

    map(']e', '<Cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>')
    map('[e', '<Cmd>lua vim.diagnostic.jump({count=-1, float=true})<CR>')

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end
        -- don't highlight in comments
        client.server_capabilities.semanticTokensProvider = nil
    end
end)


local definition_handler = function(...)
    vim.lsp.handlers['textDocument/definition'](...)
    vim.cmd 'norm! zz'
end

vim.lsp.config('*', {
    root_markers = {'.git'},
})

-- Typescript
vim.lsp.config('tsserver', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {'typescript', 'typescriptreact', 'javascript'},
    root_markers = {'tsconfig.json', 'package.json'},
    handlers = { ['textDocument/definition'] = definition_handler },
})
vim.lsp.enable('tsserver')

-- Typst
vim.lsp.config('tinymist', {
    cmd = {'tinymist'},
    filetypes = {'typst'},
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {'typst.toml'})
        local name = vim.api.nvim_buf_get_name(bufnr)

        if root == nil and name ~= '' then
            root = vim.fs.dirname(name)
        end

        if root ~= nil then
            on_dir(root)
        end
    end,
})
vim.lsp.enable('tinymist')

-- Go
vim.lsp.config('gopls', {
    cmd = {'gopls'},
    filetypes = {'go', 'gomod', 'gowork', 'gotmpl'},
    root_markers = {'go.work', 'go.mod'},
})
vim.lsp.enable('gopls')

-- Lua
vim.lsp.config('lua_ls', {
    cmd = {'lua-language-server'},
    filetypes = {'lua'},
    root_markers = {{'.luarc.json', '.luarc.jsonc'}},
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = {
                checkThirdParty = false,
                library = vim.list_extend(
                    vim.api.nvim_get_runtime_file('', true),
                    { '${3rd}/luv/library' }
                ),
            },
        },
    }
})
vim.lsp.enable('lua_ls')

-- Swift
vim.lsp.config('sourcekit', {
    cmd = {'sourcekit-lsp'},
    filetypes = {'swift', 'objc', 'objcpp', 'c', 'cpp'},
    root_dir = function(bufnr, on_dir)
        on_dir(vim.fs.root(bufnr, {
            {'buildServer.json', '.bsp'},
            function(name)
                local ext = vim.fs.ext(name)
                return ext == 'xcodeproj' or ext == 'xcworkspace'
            end,
            {'compile_commands.json', 'Package.swift'},
        }))
    end,
    get_language_id = function(_, filetype)
        local language_ids = {
            objc = 'objective-c',
            objcpp = 'objective-cpp',
        }
        return language_ids[filetype] or filetype
    end,
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
        textDocument = {
            diagnostic = {
                dynamicRegistration = true,
                relatedDocumentSupport = true,
            },
        },
    },
})
vim.lsp.enable('sourcekit')
