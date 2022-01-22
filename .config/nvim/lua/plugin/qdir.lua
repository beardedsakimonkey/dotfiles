local qdir = require("qdir")
local function endswith_any(str, suffixes)
  local hidden = false
  for _, suf in ipairs(suffixes) do
    if hidden then break end
    if vim.endswith(str, suf) then
      hidden = true
    end
  end
  return hidden
end
local function _2_(file, cwd)
  local suffixes = {".bs.js", ".o"}
  if vim.startswith(cwd, vim.fn.stdpath("config")) then
    table.insert(suffixes, ".lua")
  end
  return endswith_any(file.name, suffixes)
end
qdir.setup({["auto-open"] = true, ["is-file-hidden"] = _2_, ["show-hidden-files"] = false})
return vim.api.nvim_set_keymap("n", "-", "<Cmd>Qdir<CR>", {noremap = true})
