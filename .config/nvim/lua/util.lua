local s_5c = vim.fn.shellescape
local f_5c = vim.fn.fnameescape
local _24HOME = os.getenv("HOME")
local _24TMUX = os.getenv("TMUX")
local function f_exists_3f(path)
  return (true == vim.loop.fs_access(path, ""))
end
local function system(cmd_parts, cb)
  local stdout_pipe = vim.loop.new_pipe()
  local stderr_pipe = vim.loop.new_pipe()
  local stdout = ""
  local stderr = ""
  local function on_exit(exit_code, _signal)
    return cb(stdout, stderr, exit_code)
  end
  local cmd = table.remove(cmd_parts, 1)
  local args = cmd_parts
  vim.loop.spawn(cmd, {stdio = {nil, stdout_pipe, stderr_pipe}, args = args}, on_exit)
  local function on_stdout_2ferr(stdout_3f, _3ferr, _3fdata)
    assert(not _3ferr, _3ferr)
    if (nil ~= _3fdata) then
      if stdout_3f then
        stdout = (stdout .. _3fdata)
        return nil
      else
        stderr = (stderr .. _3fdata)
        return nil
      end
    else
      return nil
    end
  end
  local function _3_(...)
    return on_stdout_2ferr(true, ...)
  end
  vim.loop.read_start(stdout_pipe, _3_)
  local function _4_(...)
    return on_stdout_2ferr(false, ...)
  end
  return vim.loop.read_start(stderr_pipe, _4_)
end
return {["s\\"] = s_5c, ["f\\"] = f_5c, ["$HOME"] = _24HOME, ["$TMUX"] = _24TMUX, ["f-exists?"] = f_exists_3f, system = system}
