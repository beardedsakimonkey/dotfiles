local uv = vim.loop
vim.cmd("augroup mine | au!")
local function compile_config_fennel()
  local config_dir = vim.fn.stdpath("config")
  local src = vim.fn.expand("<afile>:p")
  local dest
  do
    local _1_ = src:gsub(".fnl$", ".lua")
    dest = _1_
  end
  local compile_3f = (vim.startswith(src, config_dir) and not vim.endswith(src, "macros.fnl"))
  if compile_3f then
    local cmd = string.format("fennel --compile %s > %s", vim.fn.fnameescape(src), vim.fn.fnameescape(dest))
    vim.cmd(("lcd " .. config_dir))
    local output = vim.fn.system(cmd)
    if vim.v.shell_error then
      print(output)
    end
    vim.cmd("lcd -")
    return vim.cmd(("luafile " .. dest))
  end
end
do
  _G["my__au__compile_config_fennel"] = compile_config_fennel
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__compile_config_fennel()")
end
local function compile_qdir_fennel()
  local dir = "/Users/tim/code/qdir/"
  local src = vim.fn.expand("<afile>:p")
  local src2
  do
    local _4_ = src:gsub(("^" .. dir), "")
    src2 = _4_
  end
  local dest
  do
    local _5_ = src2:gsub(".fnl$", ".lua")
    dest = _5_
  end
  local compile_3f = vim.startswith(src, dir)
  if compile_3f then
    vim.cmd(("lcd " .. dir))
    do
      local cmd = string.format("fennel --compile %s > %s", vim.fn.fnameescape(src2), vim.fn.fnameescape(dest))
      local output = vim.fn.system(cmd)
      if vim.v.shell_error then
        print(output)
      end
    end
    return vim.cmd("lcd -")
  end
end
do
  _G["my__au__compile_qdir_fennel"] = compile_qdir_fennel
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__compile_qdir_fennel()")
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
        local function _12_()
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
        close_handlers_7_auto(xpcall(_12_, (package.loaded.fennel or debug).traceback))
      end
    end
  end
  return nil
end
local function maybe_create_directories()
  local afile = vim.fn.expand("<afile>")
  local create_3f = not afile:match("://")
  local new = vim.fn.expand("<afile>:p:h")
  if create_3f then
    return vim.fn.mkdir(new, "p")
  end
end
do
  _G["my__au__maybe_create_directories"] = maybe_create_directories
  vim.cmd("autocmd BufWritePre,FileWritePre *  lua my__au__maybe_create_directories()")
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
do
  vim.cmd("autocmd VimResized *  wincmd =")
end
local function setup_formatting()
  do end (vim.opt_local.formatoptions):append("jcn")
  do end (vim.opt_local.formatoptions):remove("r")
  do end (vim.opt_local.formatoptions):remove("o")
  return (vim.opt_local.formatoptions):remove("t")
end
do
  _G["my__au__setup_formatting"] = setup_formatting
  vim.cmd("autocmd FileType *  lua my__au__setup_formatting()")
end
do
  vim.cmd("autocmd FocusGained,BufEnter *  checktime")
end
return vim.cmd("augroup END")
