local minsnip = require("minsnip")
local function join(seq)
  return table.concat(seq, "\n")
end
local function _1_()
  local _2_ = vim.bo.filetype
  if (_2_ == "c") then
    return "printf(\"$0\\n\");"
  elseif (_2_ == "vim") then
    return "echom $0"
  elseif (_2_ == "lua") then
    return "print($0)"
  elseif (_2_ == "fennel") then
    return "(print $0)"
  elseif (_2_ == "javascript") then
    return "console.log($0)"
  elseif (_2_ == "rescript") then
    return "Js.log($0)"
  elseif (_2_ == "rust") then
    return "println!(\"$0\")"
  else
    return nil
  end
end
local function _4_()
  local _5_ = vim.bo.filetype
  if (_5_ == "lua") then
    return join({"local dbg = require'debugger'", "dbg.auto_where = 10", "dbg()"})
  else
    return nil
  end
end
local function _7_()
  return join({"| $0 |    |    |", "| -- | -- | -- |", "|    |    |    |"})
end
minsnip.setup({cl = _1_, d = _4_, table = _7_})
local function expand_snippet()
  if not minsnip.jump() then
    return vim.api.nvim_input("<C-l>")
  else
    return nil
  end
end
return vim.keymap.set("i", "<C-l>", expand_snippet, {})
