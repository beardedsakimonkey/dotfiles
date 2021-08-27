local uv = vim.loop
local function recompile_fennel()
  local config_dir = vim.fn.stdpath("config")
  local afile = vim.fn.expand("<afile>:p")
  local out
  do
    local _1_ = afile:gsub(".fnl$", ".lua")
    out = _1_
  end
  local in_config_dir_3f = vim.startswith(afile, config_dir)
  if in_config_dir_3f then
    vim.cmd(("lcd " .. config_dir))
  end
  local err = vim.fn.system(string.format("fennel --compile %s > %s", afile, out))
  if vim.v.shell_error then
    print(err)
  end
  if in_config_dir_3f then
    return vim.cmd("lcd -")
  end
end
do
  _G["my__au__recompile_fennel"] = recompile_fennel
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__recompile_fennel()")
end
local function handle_large_buffers()
  local size = vim.fn.getfsize(vim.fn.expand("<afile>"))
  if ((size > (1024 * 1024)) or (size == -2)) then
    vim.cmd("syntax clear")
    do end (vim.opt_local)["foldmethod"] = "manual"
    vim.opt_local["foldenable"] = false
    vim.opt_local["swapfile"] = false
    vim.opt_local["undofile"] = false
    return nil
  end
end
do
  _G["my__au__handle_large_buffers"] = handle_large_buffers
  vim.cmd("autocmd BufReadPre *  lua my__au__handle_large_buffers()")
end
local function maybe_make_executable()
  local shebang = vim.fn.matchstr(vim.fn.getline(1), "^#!\\S\\+")
  if shebang then
    local name = vim.fn.expand("<afile>:p:S")
    local mode = tonumber("755", 8)
    local error = uv.fs_chmod(name, mode)
    if error then
      return print("Cannot make file '", name, "' executable")
    end
  end
end
local function setup_make_executable()
  _G["my__au__maybe_make_executable"] = maybe_make_executable
  return vim.cmd("autocmd BufWritePost <buffer> ++once lua my__au__maybe_make_executable()")
end
do
  _G["my__au__setup_make_executable"] = setup_make_executable
  vim.cmd("autocmd BufNewFile *  lua my__au__setup_make_executable()")
end
local function maybe_read_template()
  local path = (vim.fn.stdpath("data") .. "/templates")
  local fs = uv.fs_scandir(path)
  local done_3f = false
  while not done_3f do
    local name, type = uv.fs_scandir_next(fs)
    if not name then
      done_3f = true
    elseif "else" then
      local basename = string.match(name, "(%w+)%.")
      if (basename == vim.bo.filetype) then
        done_3f = true
        local file = assert(io.open((path .. "/" .. name)))
        local function close_handlers_7_auto(ok_8_auto, ...)
          file:close()
          if ok_8_auto then
            return ...
          else
            return error(..., 0)
          end
        end
        local function _9_()
          local lines
          do
            local tbl_12_auto = {}
            for v in file:lines() do
              tbl_12_auto[(#tbl_12_auto + 1)] = v
            end
            lines = tbl_12_auto
          end
          if (lines[#lines] == "") then
            table.remove(lines)
          end
          return vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
        end
        close_handlers_7_auto(xpcall(_9_, (package.loaded.fennel or debug).traceback))
      end
    end
  end
  return nil
end
local function highlight_text()
  return vim.highlight.on_yank({higroup = "IncSearch", on_macro = true, on_visual = false, timeout = 150})
end
do
  _G["my__au__highlight_text"] = highlight_text
  vim.cmd("autocmd TextYankPost *  lua my__au__highlight_text()")
end
local function source_colorscheme()
  vim.cmd(("source " .. vim.fn.expand("<afile>:p")))
  if vim.g.colors_name then
    return vim.cmd(("colorscheme " .. vim.g.colors_name))
  end
end
do
  _G["my__au__source_colorscheme"] = source_colorscheme
  vim.cmd("autocmd BufWritePost */colors/*.vim  lua my__au__source_colorscheme()")
end
local function source_tmux_cfg()
  return vim.fn.system(("tmux source-file " .. vim.fn.expand("<afile>:p")))
end
do
  _G["my__au__source_tmux_cfg"] = source_tmux_cfg
  vim.cmd("autocmd BufWritePost *tmux.conf  lua my__au__source_tmux_cfg()")
end
local function restore_cursor_position()
  local last_cursor_pos = vim.api.nvim_buf_get_mark(0, "\"")
  if not vim.endswith(vim.bo.filetype, "commit") then
    return pcall(vim.api.nvim_win_set_cursor, 0, last_cursor_pos)
  end
end
do
  _G["my__au__restore_cursor_position"] = restore_cursor_position
  vim.cmd("autocmd BufReadPost *  lua my__au__restore_cursor_position()")
end
local function resize_splits()
  return vim.cmd("wincmd =")
end
_G["my__au__resize_splits"] = resize_splits
return vim.cmd("autocmd VimResized *  lua my__au__resize_splits()")
