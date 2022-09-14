local _local_1_ = require("util")
local FF_PROFILE = _local_1_["FF-PROFILE"]
local s_5c = _local_1_["s\\"]
local function update_userjs()
  return vim.cmd(("botright new | terminal cd " .. s_5c(FF_PROFILE) .. " && ./updater.sh && ./prefsCleaner.sh"))
end
vim.api.nvim_create_user_command("UpdateUserJs", update_userjs, {})
vim.api.nvim_create_user_command("Scratch", "call my#scratch(<q-args>, <q-mods>)", {nargs = 1, complete = "command"})
vim.api.nvim_create_user_command("Messages", "<mods> Scratch messages", {nargs = 0})
vim.api.nvim_create_user_command("Marks", "<mods> Scratch marks <args>", {nargs = "?"})
vim.api.nvim_create_user_command("Highlight", "<mods> Scratch highlight <args>", {nargs = "?", complete = "highlight"})
vim.api.nvim_create_user_command("Jumps", "<mods> Scratch jumps", {nargs = 0})
return vim.api.nvim_create_user_command("Scriptnames", "<mods> Scratch scriptnames", {nargs = 0})
