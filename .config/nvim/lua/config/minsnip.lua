local minsnip = require("minsnip")
local function _1_()
  local _2_ = vim.bo.filetype
  if (_2_ == "lua") then
    return "print($0)"
  elseif (_2_ == "c") then
    return "printf(\"$0\\n\");"
  elseif (_2_ == "fennel") then
    return "(print $0)"
  elseif (_2_ == "javascript") then
    return "console.log($0)"
  elseif (_2_ == "rescript") then
    return "Js.log($0)"
  else
    return nil
  end
end
minsnip.setup({cl = _1_})
local function expand_snippet()
  if not minsnip.jump() then
    return vim.api.nvim_input("<C-l>")
  else
    return nil
  end
end
_G["my__map__expand_snippet"] = expand_snippet
return vim.api.nvim_set_keymap("i", "<C-l>", "<Cmd>lua my__map__expand_snippet()<CR>", {noremap = true})
