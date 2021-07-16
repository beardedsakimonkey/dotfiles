 require'compe'.setup({
    enabled = true,
    autocomplete = true,
    min_length = 2,
    preselect = 'always',
    source = {
      path = true,
      -- omni = true,
      buffer = true,
      nvim_lsp = true,
    },
  })
