local snap = require("snap")
local function get_sorted_buffers()
  local bufs
  local function _1_(_241)
    return ((vim.fn.bufname(_241) ~= "") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1))
  end
  bufs = vim.tbl_filter(_1_, vim.api.nvim_list_bufs())
  local function _2_(_241, _242)
    return ((vim.fn.getbufinfo(_241))[1].lastused > (vim.fn.getbufinfo(_242))[1].lastused)
  end
  table.sort(bufs, _2_)
  local function _3_(_241)
    return vim.fn.bufname(_241)
  end
  return vim.tbl_map(_3_, bufs)
end
local function sorted_buffers()
  return snap.sync(get_sorted_buffers)
end
local mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}}
local file = (snap.config.file):with({mappings = mappings, reverse = true})
local function _4_()
  return snap.run({multiselect = (snap.get("select.vimgrep")).multiselect, producer = snap.get("consumer.limit")(10000, snap.get("producer.ripgrep.vimgrep")), select = (snap.get("select.vimgrep")).select, views = {snap.get("preview.vimgrep")}})
end
local function _5_()
  return snap.run({producer = snap.get("consumer.fzy")(snap.get("producer.vim.help")), prompt = "Help>", select = (snap.get("select.help")).select, views = {snap.get("preview.help")}})
end
return snap.maps({{"<space>b", file({producer = sorted_buffers})}, {"<space>o", file({producer = "vim.oldfile"})}, {"<space>f", file({producer = "ripgrep.file"})}, {"<space>a", _4_}, {"<space>g", _5_}})
