local _local_1_ = require("util")
local FF_PROFILE = _local_1_["FF-PROFILE"]
local function update_userjs()
  vim.cmd(("lcd " .. FF_PROFILE))
  vim.cmd("terminal ./updater.sh && ./prefsCleaner.sh")
  return vim.cmd("lcd -")
end
return vim.api.nvim_create_user_command("UpdateUserJs", update_userjs, {})
