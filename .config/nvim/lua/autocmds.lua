local _local_1_ = require("util")
local s_5c = _local_1_["s\\"]
local f_5c = _local_1_["f\\"]
local _24HOME = _local_1_["$HOME"]
local _24TMUX = _local_1_["$TMUX"]
local f_exists_3f = _local_1_["f-exists?"]
local system = _local_1_["system"]
local ns = vim.api.nvim_create_namespace("my/autocmds")
local function on_fnl_err(output)
  local lines = vim.split(output, "\n")
  local _let_2_ = vim.fn.getqflist({efm = "%C%[%^^]%#,%E%>Parse error in %f:%l:%c,%E%>Compile error in %f:%l:%c,%-Z%p^%.%#,%C%\\s%#%m,%-G* %.%#", lines = lines})
  local items = _let_2_["items"]
  for _, v in ipairs(items) do
    v.text = (v.text):gsub("^\n", "")
  end
  local diagnostics = vim.diagnostic.fromqflist(items)
  vim.diagnostic.set(ns, tonumber(vim.fn.expand("<abuf>")), diagnostics)
  local function no_codes(s)
    return s:gsub("\27%[[0-9]m", "")
  end
  local function _3_()
    return vim.notify(no_codes(output), vim.log.levels.WARN)
  end
  return vim.schedule(_3_)
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
  local function _5_(_241)
    return vim.startswith(src, _241)
  end
  _3froot = tbl_find(_5_, roots)
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
    if _3froot then
      vim.cmd(("lcd " .. f_5c(_3froot)))
    else
    end
    local fennel = require("fennel")
    local linter = (_24HOME .. "/bin/linter.fnl")
    local plugins
    if f_exists_3f(linter) then
      plugins = {fennel.dofile(linter, {env = "_COMPILER", useMetadata = true, ["compiler-env"] = _G})}
    else
      plugins = {}
    end
    local fnl_str = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, true), "\n")
    do
      local _9_, _10_ = nil, nil
      local function _11_()
        return fennel["compile-string"](fnl_str, {filename = src0, plugins = plugins})
      end
      _9_, _10_ = xpcall(_11_, fennel.traceback)
      if ((_9_ == true) and (nil ~= _10_)) then
        local output = _10_
        vim.api.nvim_buf_set_var(buf, "comp_err", false)
        write_file(output, dest)
        if (config_dir == _3froot) then
          if not vim.startswith(src0, "after/ftplugin") then
            vim.cmd(("luafile " .. f_5c(dest)))
          else
          end
          if ("lua/plugins.fnl" == src0) then
            vim.cmd("PackerCompile")
          else
          end
          if (("colors/navajo.fnl" == src0) and vim.g.colors_name) then
            vim.cmd(("colorscheme " .. vim.g.colors_name))
          else
          end
        else
        end
      elseif (true and (nil ~= _10_)) then
        local _ = _9_
        local msg = _10_
        vim.api.nvim_buf_set_var(buf, "comp_err", true)
        on_fnl_err(msg)
      else
      end
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
    local path = s_5c(vim.fn.expand("<afile>:p"))
    return vim.cmd(("sil !chmod +x " .. path))
  else
    return nil
  end
end
local function maybe_create_directories()
  local afile = vim.fn.expand("<afile>")
  local create_3f = not afile:match("://")
  local new = f_5c(vim.fn.expand("<afile>:p:h"))
  if create_3f then
    return vim.fn.mkdir(new, "p")
  else
    return nil
  end
end
local function source_tmux_cfg()
  local file = s_5c(vim.fn.expand("<afile>:p"))
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
  local function _23_(code)
    assert((0 == code))
    return print("Updated user.js")
  end
  return vim.loop.spawn("/Users/tim/Library/Application Support/Firefox/Profiles/2a6723nr.default-release/updater.sh", {args = {"-d", "-s", "-b"}}, _23_)
end
local function edit_url()
  local buf = tonumber(vim.fn.expand("<abuf>"))
  local function strip_trailing_newline(str)
    if ("\n" == str:sub(-1)) then
      return str:sub(1, -2)
    else
      return str
    end
  end
  local function cb(stdout, stderr, exit_code)
    local lines
    local function _25_()
      if (0 == exit_code) then
        return stdout
      else
        return stderr
      end
    end
    lines = vim.split(strip_trailing_newline(_25_()), "\n")
    local function _26_()
      return vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    end
    return vim.schedule(_26_)
  end
  return system({"curl", "--location", "--silent", "--show-error", vim.fn.expand("<afile>")}, cb)
end
local function template_h()
  local file_name = vim.fn.expand("<afile>:t")
  local guard = string.upper(file_name:gsub("%.", "_"))
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {("#ifndef " .. guard), ("#define " .. guard), "", "#endif"})
end
local function template_c()
  local str = "#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n\9printf(\"hi\\n\");\n}"
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(str, "\n"))
end
local function fast_theme()
  local zsh = (_24HOME .. "/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh")
  if f_exists_3f(zsh) then
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
local sh_repeat_3f = false
local function _29_()
  sh_repeat_3f = not sh_repeat_3f
  local function _30_()
    if sh_repeat_3f then
      return "enabled"
    else
      return "disabled"
    end
  end
  return print("shell repeat", _30_())
end
vim.keymap.set("n", "g.", _29_, {})
local function repeat_shell_cmd()
  local is_tmux_3f = (nil ~= _24TMUX)
  if (is_tmux_3f and sh_repeat_3f) then
    return vim.fn.system("tmux if -F -t '{last}' '#{m:*sh,#{pane_current_command}}' \"send-keys -t '{last}' Up Enter\"")
  else
    return nil
  end
end
vim.api.nvim_create_augroup("my/autocmds", {clear = true})
local _32_ = "my/autocmds"
vim.api.nvim_create_autocmd("BufReadPre", {callback = handle_large_buffer, group = _32_, pattern = "*"})
vim.api.nvim_create_autocmd("FileType", {callback = setup_formatoptions, group = _32_, pattern = "*"})
vim.api.nvim_create_autocmd({"BufWritePre", "FileWritePre"}, {callback = maybe_create_directories, group = _32_, pattern = "*"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = fast_theme, group = _32_, pattern = "*/.zsh/overlay.ini"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = compile_fennel, group = _32_, pattern = "*.fnl"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = repeat_shell_cmd, group = _32_, pattern = "*.rs"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = source_tmux_cfg, group = _32_, pattern = "*tmux.conf"})
vim.api.nvim_create_autocmd("BufWritePost", {command = "source <afile>:p", group = _32_, pattern = "*/.config/nvim/plugin/*.vim"})
vim.api.nvim_create_autocmd("BufWritePost", {callback = update_user_js, group = _32_, pattern = "user-overrides.js"})
local function _33_()
  return vim.api.nvim_create_autocmd("BufWritePost", {buffer = 0, callback = maybe_make_executable, group = "my/autocmds", once = true})
end
vim.api.nvim_create_autocmd("BufNewFile", {callback = _33_, group = _32_, pattern = "*"})
vim.api.nvim_create_autocmd("BufNewFile", {callback = edit_url, group = _32_, pattern = {"http://*", "https://*"}})
local function _34_()
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, {"#!/bin/bash"})
end
vim.api.nvim_create_autocmd("BufNewFile", {callback = _34_, group = _32_, pattern = "*.sh"})
vim.api.nvim_create_autocmd("BufNewFile", {callback = template_h, group = _32_, pattern = "*.h"})
vim.api.nvim_create_autocmd("BufNewFile", {callback = template_c, group = _32_, pattern = "main.c"})
vim.api.nvim_create_autocmd("VimResized", {command = "wincmd =", group = _32_, pattern = "*"})
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {command = "checktime", group = _32_, pattern = "*"})
local function _35_()
  return vim.highlight.on_yank({on_visual = false})
end
vim.api.nvim_create_autocmd("TextYankPost", {callback = _35_, group = _32_, pattern = "*"})
return _32_