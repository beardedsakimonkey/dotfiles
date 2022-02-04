local M = {}
local _local_1_ = vim.diagnostic.severity
local ERROR = _local_1_["ERROR"]
local WARN = _local_1_["WARN"]
M.lsp_errors = function()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ""
  else
    local count = vim.tbl_count(vim.diagnostic.get(0, {severity = ERROR}))
    if (count > 0) then
      return (" \226\151\143 " .. count)
    else
      return ""
    end
  end
end
M.lsp_warns = function()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ""
  else
    local count = vim.tbl_count(vim.diagnostic.get(0, {severity = WARN}))
    if (count > 0) then
      return (" \226\151\143 " .. count)
    else
      return ""
    end
  end
end
M.show = function()
  local current_win_3f = (vim.g.statusline_winid == vim.fn.win_getid())
  local rhs
  if current_win_3f then
    rhs = "%6*%{session#status()}%*"
  else
    rhs = ""
  end
  local lsp = "%3*%{v:lua.require'statusline'.lsp_errors()} %4*%{v:lua.require'statusline'.lsp_warns()}%*"
  return ("%1*%{!&modifiable?'  X ':&ro?'  RO ':''}%2*%{&modified?'  + ':''}%* %7*" .. "%{expand('%:t')}%* " .. lsp .. " %=" .. rhs .. " ")
end
vim.opt["statusline"] = "%!v:lua.require'statusline'.show()"
M.tabline = function()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local function _7_()
      if (i == vim.fn.tabpagenr()) then
        return "%#TabLineSel#"
      else
        return "%#TabLine#"
      end
    end
    s = (s .. _7_() .. "%" .. i .. "T %{v:lua.require'statusline'.tablabel(" .. i .. ")}")
  end
  return (s .. "%#TabLineFill#%T")
end
M.tablabel = function(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local modified = ""
  for _, b in ipairs(buflist) do
    if (modified ~= "") then break end
    if vim.api.nvim_buf_get_option(b, "modified") then
      modified = "+ "
    else
    end
  end
  local name = vim.fn.fnamemodify(vim.fn.bufname(buflist[vim.fn.tabpagewinnr(n)]), ":t:s/^$/[No Name]/")
  return (modified .. name .. " ")
end
vim.opt["tabline"] = "%!v:lua.require'statusline'.tabline()"
return M
