local s_5c = vim.fn.shellescape
local f_5c = vim.fn.fnameescape
local _24HOME = os.getenv("HOME")
local _24TMUX = os.getenv("TMUX")
local function exists_3f(path)
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
  local _local_1_ = cmd_parts
  local cmd = _local_1_[1]
  local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_local_1_, 2)
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
  local function _4_(...)
    return on_stdout_2ferr(true, ...)
  end
  vim.loop.read_start(stdout_pipe, _4_)
  local function _5_(...)
    return on_stdout_2ferr(false, ...)
  end
  return vim.loop.read_start(stderr_pipe, _5_)
end
local function find(pred_3f, seq)
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
return {["s\\"] = s_5c, ["f\\"] = f_5c, ["$HOME"] = _24HOME, ["$TMUX"] = _24TMUX, ["exists?"] = exists_3f, system = system, find = find}
