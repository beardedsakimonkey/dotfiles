local M = {}

M.statusline = function()
  local current_win = vim.g.statusline_winid == vim.fn.win_getid()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local issues = #vim.diagnostic.get(buf)
  local function _1_()
    if (issues > 0) then
      return ("\226\156\152 " .. issues)
    else
      return ""
    end
  end
  local function _2_()
    if current_win then
      return "%6*%{session#status()}%* "
    else
      return ""
    end
  end
  return ("%1*%{!&modifiable ? '  X ' : &ro ? '  RO ' : ''}%2*%{&modified ? '  + ' : ''}%* %7*" .. "%{&buftype == 'nofile' ? '[Nofile]' : expand('%:t')}%* " .. "%{&fileformat != 'unix' ? '[' . &fileformat . '] ' : ''}" .. "%{&fileencoding != 'utf-8' && &fileencoding != '' ? '[' . &fileencoding . '] ' : ''}" .. _1_() .. "%=" .. _2_())
end

vim["opt"]["statusline"] = "%!v:lua.require'statusline'.statusline()"

M.tabline = function()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local function _3_()
      if (i == vim.fn.tabpagenr()) then
        return "%#TabLineSel#"
      else
        return "%#TabLine#"
      end
    end
    s = (s .. _3_() .. "%" .. i .. "T %{v:lua.require'statusline'.tablabel(" .. i .. ")}")
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

vim["opt"]["tabline"] = "%!v:lua.require'statusline'.tabline()"

return M
