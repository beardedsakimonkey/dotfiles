local function start_repl()
  local _local_1_ = require("fennel-repl")
  local start = _local_1_["start"]
  return start({autoinsert = false})
end
return vim.api.nvim_create_user_command("FennelRepl", start_repl, {})
