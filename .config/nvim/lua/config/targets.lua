vim.g.targets_jumpRanges = ""
vim.g.targets_aiAI = "aIAi"
local function setup_targets()
  return vim.fn["targets#mappings#extend"]({["'"] = {quote = {{d = "'"}, {d = "\""}}}, b = {pair = {{o = "(", c = ")"}}}})
end
_G["my__au__setup_targets"] = setup_targets
return vim.cmd("autocmd User targets#mappings#user  lua my__au__setup_targets()")
