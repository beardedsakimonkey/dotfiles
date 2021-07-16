local snap = require'snap'

local mappings = {
  ["enter-split"] = {"<C-s>"},
  ["enter-vsplit"] = {"<C-l>"},
}

local file = snap.config.file:with { mappings = mappings }

snap.maps {
  {"<space>f", file {producer = "ripgrep.file"}},
  {"<space>b", file {producer = "vim.buffer"}},
  {"<space>o", file {producer = "vim.oldfile"}},
  {"<space>a", function ()
    snap.run {
      producer = snap.get'consumer.limit'(10000, snap.get'producer.ripgrep.vimgrep'),
      select = snap.get'select.vimgrep'.select,
      multiselect = snap.get'select.vimgrep'.multiselect,
      views = {snap.get'preview.vimgrep'},
      mappings = mappings,
    }
  end
  },
}
