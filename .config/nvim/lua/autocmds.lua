vim.cmd("augroup my/autocmds | au!")
local efm = "%C%[%^^]%#,%E%>Parse error in %f:%l,%E%>Compile error in %f:%l,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#"
local ns = vim.api.nvim_create_namespace("my/autocmds")
local function on_fnl_err(output)
  if string.match(output, "macros.fnl") then
    print(output)
  else
    print(output)
  end
  local lines = vim.split(output, "\n")
  local _let_2_ = vim.fn.getqflist({efm = efm, lines = lines})
  local items = _let_2_["items"]
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
local function compile_config_fennel()
  vim.diagnostic.reset(ns, tonumber(vim.fn.expand("<abuf>")))
  local config_dir = vim.fn.stdpath("config")
  local src = vim.fn.expand("<afile>:p")
  local dest = src:gsub(".fnl$", ".lua")
  local compile_3f = (vim.startswith(src, config_dir) and not vim.endswith(src, "macros.fnl"))
  if compile_3f then
    local cmd = string.format("fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile %s", vim.fn.fnameescape(src))
    vim.cmd(("lcd " .. config_dir))
    local output = vim.fn.system(cmd)
    if (0 ~= vim.v.shell_error) then
      on_fnl_err(output)
    else
      write_21(output, dest)
    end
    vim.cmd("lcd -")
    if not vim.startswith(src, (config_dir .. "/after/ftplugin")) then
      vim.cmd(("luafile " .. dest))
    else
    end
    if ((0 == vim.v.shell_error) and (src == (config_dir .. "/lua/plugins.fnl"))) then
      return vim.cmd("PackerCompile")
    else
      return nil
    end
  else
    return nil
  end
end
local function compile_udir_fennel()
  local dir = "/Users/tim/code/udir/"
  local src = vim.fn.expand("<afile>:p")
  local src2 = src:gsub(("^" .. dir), "")
  local dest = src2:gsub(".fnl$", ".lua")
  local compile_3f = vim.startswith(src, dir)
  if compile_3f then
    vim.cmd(("lcd " .. dir))
    do
      local cmd = string.format("fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile %s > %s", vim.fn.fnameescape(src2), vim.fn.fnameescape(dest))
      local output = vim.fn.system(cmd)
      if vim.v.shell_error then
        on_fnl_err(output)
      else
      end
    end
    return vim.cmd("lcd -")
  else
    return nil
  end
end
local function handle_large_buffers()
  local size = vim.fn.getfsize(vim.fn.expand("<afile>"))
  if ((size > (1024 * 1024)) or (size == -2)) then
    vim.cmd("syntax clear")
    do end (vim)["opt_local"]["foldmethod"] = "manual"
    vim["opt_local"]["foldenable"] = false
    vim["opt_local"]["swapfile"] = false
    vim["opt_local"]["undofile"] = false
    return nil
  else
    return nil
  end
end
local function maybe_make_executable()
  local first_line = (vim.api.nvim_buf_get_lines(0, 0, 1, false))[1]
  if first_line:match("^#!%S+") then
    local path = vim.fn.expand("<afile>:p:S")
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
  local new = vim.fn.expand("<afile>:p:h")
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
  vim.cmd(("source " .. vim.fn.expand("<afile>:p")))
  if vim.g.colors_name then
    return vim.cmd(("colorscheme " .. vim.g.colors_name))
  else
    return nil
  end
end
local function source_tmux_cfg()
  return vim.fn.system(("tmux source-file " .. vim.fn.expand("<afile>:p")))
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
do
  _G["my__au__compile_config_fennel"] = compile_config_fennel
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__compile_config_fennel()")
end
do
  _G["my__au__compile_udir_fennel"] = compile_udir_fennel
  vim.cmd("autocmd BufWritePost *.fnl  lua my__au__compile_udir_fennel()")
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
local function template_sh()
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {"#!/bin/bash"})
end
local function template_h()
  local file_name = vim.fn.expand("<afile>:t")
  local guard = string.upper(file_name:gsub("%.", "_"))
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {("#ifndef " .. guard), ("#define " .. guard), "", "#endif"})
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
