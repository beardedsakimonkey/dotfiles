vim.cmd("augroup my/autocmds | au!")
local ns = vim.api.nvim_create_namespace("my/autocmds")
local function on_fnl_err(output)
  print(output)
  local lines = vim.split(output, "\n")
  local _let_1_ = vim.fn.getqflist({efm = "%C%[%^^]%#,%E%>Parse error in %f:%l,%E%>Compile error in %f:%l,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#", lines = lines})
  local items = _let_1_["items"]
  for _, v in ipairs(items) do
    v.text = (v.text):gsub("^\n", "")
  end
  local results = vim.diagnostic.fromqflist(items)
  return vim.diagnostic.set(ns, tonumber(vim.fn.expand("<abuf>")), results)
end
local function write_21(text, filename)
  local handle = assert(io.open(filename, "w+"))
  handle:write(text)
  return handle:close()
end
local function tbl_find(pred_3f, seq)
  local _3fres = nil
  for _, v in ipairs(seq) do
    if (nil ~= _3fres) then break end
    if pred_3f(v) then
      _3fres = v
    else
    end
  end
  return _3fres
end
local function compile_fennel()
  local config_dir = (vim.fn.stdpath("config") .. "/")
  local roots = {config_dir, "/Users/tim/code/udir/"}
  local src = vim.fn.expand("<afile>:p")
  local _3froot
  local function _3_(_241)
    return vim.startswith(src, _241)
  end
  _3froot = tbl_find(_3_, roots)
  local src0
  if _3froot then
    src0 = src:gsub(("^" .. _3froot), "")
  else
    src0 = src
  end
  local dest = src0:gsub(".fnl$", ".lua")
  local compile_3f = (_3froot and not vim.endswith(src0, "macros.fnl"))
  vim.diagnostic.reset(ns, tonumber(vim.fn.expand("<abuf>")))
  if compile_3f then
    local cmd = ("fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile " .. vim.fn.shellescape(src0))
    if _3froot then
      vim.cmd(("lcd " .. _3froot))
    else
    end
    local output = vim.fn.system(cmd)
    if (0 ~= vim.v.shell_error) then
      on_fnl_err(output)
    else
      write_21(output, dest)
    end
    if ((0 == vim.v.shell_error) and (_3froot == config_dir)) then
      if not vim.startswith(src0, "after/ftplugin") then
        vim.cmd(("luafile " .. vim.fn.fnameescape(dest)))
      else
      end
      if (src0 == "lua/plugins.fnl") then
        vim.cmd("PackerCompile")
      else
      end
    else
    end
    if _3froot then
      return vim.cmd("lcd -")
    else
      return nil
    end
  else
    return nil
  end
end
local function handle_large_buffers()
  local size = vim.fn.getfsize(vim.fn.expand("<afile>"))
  if ((size > (1024 * 1024)) or (size == -2)) then
    return vim.cmd("syntax clear")
  else
    return nil
  end
end
local function maybe_make_executable()
  local first_line = (vim.api.nvim_buf_get_lines(0, 0, 1, false))[1]
  if first_line:match("^#!%S+") then
    local path = vim.fn.shellescape(vim.fn.expand("<afile>:p"))
    return vim.cmd(("sil !chmod +x " .. path))
  else
    return nil
  end
end
local function setup_make_executable()
  _G["my__au__maybe_make_executable"] = maybe_make_executable
  return vim.cmd("autocmd BufWritePost <buffer> ++once lua my__au__maybe_make_executable()")
end
local function maybe_create_directories()
  local afile = vim.fn.expand("<afile>")
  local create_3f = not afile:match("://")
  local new = vim.fn.fnameescape(vim.fn.expand("<afile>:p:h"))
  if create_3f then
    return vim.fn.mkdir(new, "p")
  else
    return nil
  end
end
local function highlight_text()
  return vim.highlight.on_yank({higroup = "IncSearch", timeout = 150, on_visual = false, on_macro = true})
end
local function source_colorscheme()
  vim.cmd(("source " .. vim.fn.fnameescape(vim.fn.expand("<afile>:p"))))
  if vim.g.colors_name then
    return vim.cmd(("colorscheme " .. vim.g.colors_name))
  else
    return nil
  end
end
local function source_tmux_cfg()
  local file = vim.fn.shellescape(vim.fn.expand("<afile>:p"))
  return vim.fn.system(("tmux source-file " .. file))
end
local function restore_cursor_position()
  local last_cursor_pos = vim.api.nvim_buf_get_mark(0, "\"")
  if not vim.endswith(vim.bo.filetype, "commit") then
    return pcall(vim.api.nvim_win_set_cursor, 0, last_cursor_pos)
  else
    return nil
  end
end
local function setup_formatting()
  do end (vim.opt_local.formatoptions):append("jcn")
  do end (vim.opt_local.formatoptions):remove("r")
  do end (vim.opt_local.formatoptions):remove("o")
  return (vim.opt_local.formatoptions):remove("t")
end
local function update_user_js()
  local cmd = "/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/updater.sh"
  local opts = {args = {cmd, "-d", "-s", "-b"}}
  local function on_exit(code, _)
    assert((0 == code))
    return print("Updated user.js")
  end
  local _handle, _pid = assert(vim.loop.spawn(cmd, opts, on_exit))
  return nil
end
local function strip_trailing_newline(str)
  if ("\n" == str:sub(-1)) then
    return str:sub(1, -2)
  else
    return str
  end
end
local function edit_url()
  local stdout = vim.loop.new_pipe()
  local stderr = vim.loop.new_pipe()
  local function on_exit(exit_code, signal)
    if (0 ~= exit_code) then
      return print(string.format("spawn failed (exit code %d, signal %d)", exit_code, signal))
    else
      return nil
    end
  end
  local opts = {stdio = {nil, stdout, stderr}, args = {"--location", "--silent", "--show-error", vim.fn.expand("<afile>")}}
  local _handle, _pid = vim.loop.spawn("curl", opts, on_exit)
  local function on_stdout_2ferr(_3ferr, _3fdata)
    assert(not _3ferr, _3ferr)
    if (nil ~= _3fdata) then
      local lines = vim.split(strip_trailing_newline(_3fdata), "\n")
      local function _19_()
        local start
        if vim.bo.modified then
          start = -1
        else
          start = 0
        end
        return vim.api.nvim_buf_set_lines(0, start, -1, false, lines)
      end
      return vim.schedule(_19_)
    else
      return nil
    end
  end
  vim.loop.read_start(stdout, on_stdout_2ferr)
  return vim.loop.read_start(stderr, on_stdout_2ferr)
end
local function template_sh()
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {"#!/bin/bash"})
end
local function template_h()
  local file_name = vim.fn.expand("<afile>:t")
  local guard = string.upper(file_name:gsub("%.", "_"))
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {("#ifndef " .. guard), ("#define " .. guard), "", "#endif"})
end
do
  _G["my__au__compile_fennel"] = compile_fennel
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__compile_fennel()")
end
do
  _G["my__au__handle_large_buffers"] = handle_large_buffers
  vim.cmd("autocmd BufReadPre *  lua my__au__handle_large_buffers()")
end
do
  _G["my__au__setup_make_executable"] = setup_make_executable
  vim.cmd("autocmd BufNewFile *  lua my__au__setup_make_executable()")
end
do
  _G["my__au__maybe_create_directories"] = maybe_create_directories
  vim.cmd("autocmd BufWritePre,FileWritePre *  lua my__au__maybe_create_directories()")
end
do
  _G["my__au__highlight_text"] = highlight_text
  vim.cmd("autocmd TextYankPost *  lua my__au__highlight_text()")
end
do
  _G["my__au__source_colorscheme"] = source_colorscheme
  vim.cmd("autocmd BufWritePost */colors/*.vim  lua my__au__source_colorscheme()")
end
do
  _G["my__au__source_tmux_cfg"] = source_tmux_cfg
  vim.cmd("autocmd BufWritePost *tmux.conf  lua my__au__source_tmux_cfg()")
end
do
  _G["my__au__restore_cursor_position"] = restore_cursor_position
  vim.cmd("autocmd BufReadPost *  lua my__au__restore_cursor_position()")
end
do
  vim.cmd("autocmd VimResized *  wincmd =")
end
do
  _G["my__au__setup_formatting"] = setup_formatting
  vim.cmd("autocmd FileType *  lua my__au__setup_formatting()")
end
do
  vim.cmd("autocmd FocusGained,BufEnter *  checktime")
end
do
  _G["my__au__update_user_js"] = update_user_js
  vim.cmd("autocmd BufWritePost user-overrides.js  lua my__au__update_user_js()")
end
do
  _G["my__au__edit_url"] = edit_url
  vim.cmd("autocmd BufNewFile http://*,https://*  lua my__au__edit_url()")
end
do
  _G["my__au__template_sh"] = template_sh
  vim.cmd("autocmd BufNewFile *.sh  lua my__au__template_sh()")
end
do
  _G["my__au__template_h"] = template_h
  vim.cmd("autocmd BufNewFile *.h  lua my__au__template_h()")
end
return vim.cmd("augroup END")
