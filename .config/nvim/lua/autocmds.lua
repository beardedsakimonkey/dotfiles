local ns = vim.api.nvim_create_namespace("my/autocmds")
local function on_fnl_err(output)
  local lines = vim.split(output, "\n")
  local _let_1_ = vim.fn.getqflist({efm = "%C%[%^^]%#,%E%>Parse error in %f:%l,%E%>Compile error in %f:%l,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#", lines = lines})
  local items = _let_1_["items"]
  for _, v in ipairs(items) do
    v.text = (v.text):gsub("^\n", "")
  end
  local results = vim.diagnostic.fromqflist(items)
  vim.diagnostic.set(ns, tonumber(vim.fn.expand("<abuf>")), results)
  local function _2_()
    return vim.api.nvim_echo({{output, "WarningMsg"}}, true, {})
  end
  return vim.schedule(_2_)
end
local function write_file(text, filename)
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
  local roots = {config_dir, (vim.fn.stdpath("data") .. "/site/pack/packer/start/nvim-udir/"), (vim.fn.stdpath("data") .. "/site/pack/packer/start/snap/"), (vim.fn.stdpath("data") .. "/site/pack/packer/opt/nvim-antifennel/")}
  local src = vim.fn.expand("<afile>:p")
  local _3froot
  local function _4_(_241)
    return vim.startswith(src, _241)
  end
  _3froot = tbl_find(_4_, roots)
  local src0
  if (_3froot and vim.startswith(src, _3froot)) then
    src0 = src:sub((1 + #_3froot))
  else
    src0 = src
  end
  local dest = src0:gsub(".fnl$", ".lua")
  local compile_3f = (_3froot and not vim.endswith(src0, "macros.fnl"))
  local buf = tonumber(vim.fn.expand("<abuf>"))
  vim.diagnostic.reset(ns, buf)
  if compile_3f then
    local cmd = ("fennel --plugin ~/bin/linter.fnl --globals 'vim' --compile " .. vim.fn.shellescape(src0))
    if _3froot then
      vim.cmd(("lcd " .. vim.fn.fnameescape(_3froot)))
    else
    end
    local output = vim.fn.system(cmd)
    if (0 ~= vim.v.shell_error) then
      vim.api.nvim_buf_set_var(buf, "comp_err", true)
      on_fnl_err(output)
    else
      vim.api.nvim_buf_set_var(buf, "comp_err", false)
      write_file(output, dest)
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
    if (src0 == "colors/navajo.fnl") then
      vim.cmd(("luafile " .. vim.fn.fnameescape(dest)))
      if vim.g.colors_name then
        vim.cmd(("colorscheme " .. vim.g.colors_name))
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
local function handle_large_buffer()
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
local function source_tmux_cfg()
  local file = vim.fn.shellescape(vim.fn.expand("<afile>:p"))
  return vim.fn.system(("tmux source-file " .. file))
end
local function setup_formatoptions()
  do end (vim.opt_local.formatoptions):append("jcn")
  if ("markdown" ~= vim.fn.expand("<amatch>")) then
    do end (vim.opt_local.formatoptions):remove("t")
  else
  end
  do end (vim.opt_local.formatoptions):remove("r")
  return (vim.opt_local.formatoptions):remove("o")
end
local function update_user_js()
  local function _19_(code)
    assert((0 == code))
    return print("Updated user.js")
  end
  return vim.loop.spawn("/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/updater.sh", {args = {"-d", "-s", "-b"}}, _19_)
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
  local function on_exit(code, signal)
    if (0 ~= code) then
      return print(string.format("spawn failed (exit code %d, signal %d)", code, signal))
    else
      return nil
    end
  end
  vim.loop.spawn("curl", {stdio = {nil, stdout, stderr}, args = {"--location", "--silent", "--show-error", vim.fn.expand("<afile>")}}, on_exit)
  local function on_stdout_2ferr(_3ferr, _3fdata)
    assert(not _3ferr, _3ferr)
    if (nil ~= _3fdata) then
      local lines = vim.split(strip_trailing_newline(_3fdata), "\n")
      local function _22_()
        local start
        if vim.bo.modified then
          start = -1
        else
          start = 0
        end
        return vim.api.nvim_buf_set_lines(0, start, -1, false, lines)
      end
      return vim.schedule(_22_)
    else
      return nil
    end
  end
  vim.loop.read_start(stdout, on_stdout_2ferr)
  return vim.loop.read_start(stderr, on_stdout_2ferr)
end
local function template_h()
  local file_name = vim.fn.expand("<afile>:t")
  local guard = string.upper(file_name:gsub("%.", "_"))
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {("#ifndef " .. guard), ("#define " .. guard), "", "#endif"})
end
local function template_c()
  local str = "#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n\tprintf(\"hi\\n\");\n}"
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(str, "\n"))
end
local function fast_theme()
  local zsh = (os.getenv("HOME") .. "/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh")
  if vim.loop.fs_access(zsh, "R") then
    local cmd = ("source " .. zsh .. " && fast-theme " .. vim.fn.expand("<afile>:p"))
    local output = vim.fn.system(cmd)
    if (0 ~= vim.v.shell_error) then
      return vim.api.nvim_err_writeln(output)
    else
      return nil
    end
  else
    return vim.api.nvim_err_writeln("zsh script not found")
  end
end
vim.api.nvim_create_augroup("my/autocmds", {clear = true})
local _27_ = "my/autocmds"
vim.api.nvim_create_autocmd("BufReadPre", {callback = handle_large_buffer, group = _27_, pattern = "*"})
vim.api.nvim_create_autocmd("FileType", {callback = setup_formatoptions, group = _27_, pattern = "*"})
vim.api.nvim_create_autocmd({"BufWritePre", "FileWritePre"}, {callback = maybe_create_directories, group = _27_, pattern = "*"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = fast_theme, group = _27_, pattern = "*/.zsh/overlay.ini"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = compile_fennel, group = _27_, pattern = "*.fnl"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = source_tmux_cfg, group = _27_, pattern = "*tmux.conf"})
vim.api.nvim_create_autocmd("BufWritePost", {command = "source <afile>:p", group = _27_, pattern = "*/.config/nvim/plugin/*.vim"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = update_user_js, group = _27_, pattern = "user-overrides.js"})
local function _28_()
  return vim.api.nvim_create_autocmd("BufWritePost", {buffer = 0, callback = maybe_make_executable, group = "my/autocmds", once = true})
end
vim.api.nvim_create_autocmd("BufNewFile", {callback = _28_, group = _27_, pattern = "*"})
vim.api.nvim_create_autocmd("BufNewFile", {callback = edit_url, group = _27_, pattern = {"http://*", "https://*"}})
local function _29_()
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {"#!/bin/bash"})
end
vim.api.nvim_create_autocmd("BufNewFile", {callback = _29_, group = _27_, pattern = "*.sh"})
vim.api.nvim_create_autocmd("BufNewFile", {callback = template_h, group = _27_, pattern = "*.h"})
vim.api.nvim_create_autocmd("BufNewFile", {callback = template_c, group = _27_, pattern = "main.c"})
vim.api.nvim_create_autocmd("VimResized", {command = "wincmd =", group = _27_, pattern = "*"})
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {command = "checktime", group = _27_, pattern = "*"})
local function _30_()
  return vim.highlight.on_yank({on_visual = false})
end
vim.api.nvim_create_autocmd("TextYankPost", {callback = _30_, group = _27_, pattern = "*"})
return _27_
