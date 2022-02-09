local uv = vim.loop
local function strip_trailing_newline(str)
  if ("\n" == str:sub(-1)) then
    return str:sub(1, -2)
  else
    return str
  end
end
local function edit_url()
  local file = vim.fn.expand("<afile>")
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()
  local function on_exit(exit_code, signal)
    if (0 ~= exit_code) then
      return print(string.format("spawn failed (exit code %d, signal %d)", exit_code, signal))
    else
      return nil
    end
  end
  local opts = {stdio = {nil, stdout, stderr}, args = {"--location", "--silent", "--show-error", vim.fn.expand("<afile>")}}
  local handle, pid = uv.spawn("curl", opts, on_exit)
  local function on_stdout_2ferr(_3ferr, _3fdata)
    assert(not _3ferr, _3ferr)
    if (nil ~= _3fdata) then
      local lines = vim.split(strip_trailing_newline(_3fdata), "\n")
      local function _3_()
        local start
        if vim.bo.modified then
          start = -1
        else
          start = 0
        end
        return vim.api.nvim_buf_set_lines(0, start, -1, false, lines)
      end
      return vim.schedule(_3_)
    else
      return nil
    end
  end
  uv.read_start(stdout, on_stdout_2ferr)
  return uv.read_start(stderr, on_stdout_2ferr)
end
vim.cmd("augroup edit_url | au!")
do
  _G["my__au__edit_url"] = edit_url
  vim.cmd("autocmd BufNewFile http://*,https://*  lua my__au__edit_url()")
end
return vim.cmd("augroup END")
