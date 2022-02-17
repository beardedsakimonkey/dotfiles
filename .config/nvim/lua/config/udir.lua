local udir = require("udir")
local function endswith_any(str, suffixes)
  local hidden = false
  for _, suf in ipairs(suffixes) do
    if hidden then break end
    if vim.endswith(str, suf) then
      hidden = true
    else
    end
  end
  return hidden
end
local function contains_3f(matches_3f, list)
  local found = false
  for _, v in ipairs(list) do
    if found then break end
    if matches_3f(v) then
      found = true
    else
    end
  end
  return found
end
local function is_file_hidden(file, files, _cwd)
  if vim.endswith(file.name, ".lua") then
    local fnl = string.gsub(file.name, ".lua$", ".fnl")
    local function _3_(_241)
      return (fnl == _241.name)
    end
    return contains_3f(_3_, files)
  elseif "else" then
    local suffixes = {".bs.js", ".o"}
    return endswith_any(file.name, suffixes)
  else
    return nil
  end
end
local m = udir.map
udir.setup({auto_open = true, show_hidden_files = false, is_file_hidden = is_file_hidden, keymaps = {q = m.quit, h = m.up_dir, ["-"] = m.up_dir, l = m.open, ["<CR>"] = m.open, s = m.open_split, v = m.open_vsplit, T = m.open_tab, R = m.reload, r = m.move, d = m.delete, ["+"] = m.create, m = m.move, c = m.copy, C = "<Cmd>lua vim.cmd('lcd ' .. vim.fn.fnameescape(require('udir.store').get().cwd))<CR>", ["."] = m.toggle_hidden_files}})
return vim.api.nvim_set_keymap("n", "-", "<Cmd>Udir<CR>", {noremap = true})
