local snap = require("snap")
local mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}}
local file = (snap.config.file):with({mappings = mappings, reverse = true})
local function _1_()
  return snap.run({multiselect = (snap.get("select.vimgrep")).multiselect, producer = snap.get("consumer.limit")(10000, snap.get("producer.ripgrep.vimgrep")), select = (snap.get("select.vimgrep")).select, views = {snap.get("preview.vimgrep")}})
end
return snap.maps({{"<space>b", file({producer = "vim.buffer"})}, {"<space>o", file({producer = "vim.oldfile"})}, {"<space>f", file({producer = "ripgrep.file"})}, {"<space>a", _1_}})
