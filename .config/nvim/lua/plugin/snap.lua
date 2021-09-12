local snap = require("snap")
local function get_sorted_buffers(request)
  local function _1_()
    local original_buf = vim.api.nvim_win_get_buf(request.winnr)
    local bufs
    local function _2_(_241)
      return ((vim.fn.bufname(_241) ~= "") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1) and (_241 ~= original_buf))
    end
    bufs = vim.tbl_filter(_2_, vim.api.nvim_list_bufs())
    local function _3_(_241, _242)
      return ((vim.fn.getbufinfo(_241))[1].lastused > (vim.fn.getbufinfo(_242))[1].lastused)
    end
    table.sort(bufs, _3_)
    local function _4_(_241)
      return vim.fn.bufname(_241)
    end
    return vim.tbl_map(_4_, bufs)
  end
  return _1_
end
local function sorted_buffers(request)
  return snap.sync(get_sorted_buffers(request))
end
local mappings = {["enter-split"] = {"<C-s>"}, ["enter-vsplit"] = {"<C-l>"}, next = {"<C-v>"}}
local file = (snap.config.file):with({mappings = mappings, reverse = true})
local function _5_()
  return snap.run({multiselect = (snap.get("select.vimgrep")).multiselect, producer = snap.get("consumer.limit")(10000, snap.get("producer.ripgrep.vimgrep")), select = (snap.get("select.vimgrep")).select, views = {snap.get("preview.vimgrep")}})
end
local function _6_()
  return snap.run({producer = snap.get("consumer.fzy")(snap.get("producer.vim.help")), prompt = "Help>", select = (snap.get("select.help")).select, views = {snap.get("preview.help")}})
end
return snap.maps({{"<space>b", file({producer = sorted_buffers})}, {"<space>o", file({producer = "vim.oldfile"})}, {"<space>f", file({producer = "ripgrep.file"})}, {"<space>a", _5_}, {"<space>h", _6_}})
