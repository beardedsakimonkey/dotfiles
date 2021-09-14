local function _1_()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ""
  else
    local errors = (vim.lsp.diagnostic.get_count("Error") or 0)
    if (errors == 0) then
      return "\226\156\148"
    else
      return ""
    end
  end
end
_G["my__lsp_statusline_no_errors"] = _1_
local function my__lsp_statusline_has_errors()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return ""
  else
    local errors = (vim.lsp.diagnostic.get_count("Error") or 0)
    if (errors > 0) then
      return "\226\156\152"
    else
      return ""
    end
  end
end
_G["my__lsp_statusline_has_errors"] = my__lsp_statusline_has_errors
local function my__statusline()
  local current_win_3f = (vim.g.statusline_winid == vim.fn.win_getid())
  local rhs
  if current_win_3f then
    rhs = "%6*%{session#status()}%*"
  else
    rhs = ""
  end
  local lsp = "%3*%{v:lua.my__lsp_statusline_no_errors()}%4*%{v:lua.my__lsp_statusline_has_errors()}%*"
  local _7_
  if current_win_3f then
    _7_ = "%8*"
  else
    _7_ = ""
  end
  return ("%1*%{!&modifiable?'  X ':&ro?'  RO ':''}%2*%{&modified?'  + ':''}%* %7*%{expand('%:h')}/" .. _7_ .. "%{expand('%:t')}%*" .. lsp .. " %=" .. rhs .. " ")
end
_G["my__statusline"] = my__statusline
vim.opt["statusline"] = "%!v:lua.my__statusline()"
local function my__tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local _9_
    if (i == vim.fn.tabpagenr()) then
      _9_ = "%#TabLineSel#"
    else
      _9_ = "%#TabLine#"
    end
    s = (s .. _9_ .. "%" .. i .. "T %{v:lua.my__tab_label(" .. i .. ")}")
  end
  return (s .. "%#TabLineFill#%T")
end
local function my__tab_label(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local modified = ""
  for _, b in ipairs(buflist) do
    if (modified ~= "") then break end
    if vim.api.nvim_buf_get_option(b, "modified") then
      modified = "+ "
    end
  end
  local name = vim.fn.fnamemodify(vim.fn.bufname(buflist[vim.fn.tabpagewinnr(n)]), ":t:s/^$/[No Name]/")
  return (modified .. name .. " ")
end
_G["my__tab_label"] = my__tab_label
_G["my__tabline"] = my__tabline
vim.opt["tabline"] = "%!v:lua.my__tabline()"
return nil
