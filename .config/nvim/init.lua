require('impatient')
local pack_path = vim.fn.stdpath("data") .. "/site/pack"

-- Adapted from Olical's init.lua
function ensure(user, repo)
  -- Ensures a given github.com/USER/REPO is cloned in the pack/packer/start directory.
  local install_path = string.format("%s/packer/start/%s", pack_path, repo, repo)
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd(string.format("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    vim.cmd(string.format("packadd %s", repo))
  end
end

ensure("wbthomason", "packer.nvim")

require('main')
