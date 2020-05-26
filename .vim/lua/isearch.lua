local api = vim.api

local results_buf
local results_win
local ns

local function fuzzy_match(str, query)
  if #query == 0 then return true end
  if #str == 0 then return false end
  local match_cols = {}
  for q in query:gmatch('%S+') do
    local qi = 1
    for si=1,#str do
      local sc = str:sub(si, si)
      local qc = q:sub(qi, qi)
      if sc == qc then
        table.insert(match_cols, si)
        qi = qi + 1
        if qi > #q then
          return match_cols
        end
      end
    end
  end
  return nil
end

local function fuzzy_filter(query, items)
  query = query or ''
  local lines = {}
  local match_cols = {}
  for _, item in ipairs(items) do
    local matches = fuzzy_match(item, query)
    if matches then
      table.insert(lines, item)
      table.insert(match_cols, matches)
    end
  end
  return lines, match_cols
end

local function move_results_cursor(offset)
  local pos = api.nvim_win_get_cursor(results_win)
  local lines = api.nvim_buf_line_count(results_buf)
  local row = math.max(1, math.min(lines, pos[1] + offset))
  api.nvim_win_set_cursor(results_win, { row, 0 })
  api.nvim_command('redraw!')
end

local function filter(input)
  local frame_buf = api.nvim_create_buf(false, true)
  local input_buf = api.nvim_create_buf(false, true)
  results_buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(input_buf, 'bufhidden', 'wipe')

  local columns = api.nvim_get_option('columns')
  local lines = api.nvim_get_option('lines')

  local height = math.ceil(lines * 0.6 - 4)
  local width = math.ceil(columns * 0.6)

  local row = math.ceil((lines - height) / 2 - 1)
  local col = math.ceil((columns - width) / 2)

  local top = '┌' .. ('─'):rep(width - 2) .. '┐'
  local mid = '│' .. (' '):rep(width - 2) .. '│'
  local bot = '└' .. ('─'):rep(width - 2) .. '┘'

  local border_lines = {}
  table.insert(border_lines, top)
  for _=1,height - 2 do
    table.insert(border_lines, mid)
  end
  table.insert(border_lines, bot)

  results_win = api.nvim_open_win(results_buf, true, {
    style = 'minimal',
    relative = 'editor',
    width = width - 4,
    height = height - 3,
    row = row + 2,
    col = col + 2,
  })

  api.nvim_command([[syntax match Comment =.*\/\ze[^\/]\+\/\?$=]])

  local frame_win = api.nvim_open_win(frame_buf, false, {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
  })

  api.nvim_buf_set_lines(frame_buf, 0, -1, true, border_lines)

  local input_win = api.nvim_open_win(input_buf, true, {
    style = 'minimal',
    relative = 'editor',
    width = width - 4,
    height = 1,
    row = row + 1,
    col = col + 2,
  })

  api.nvim_command('autocmd BufWipeout <buffer> bwipeout ' .. frame_buf .. ' ' .. results_buf)

  api.nvim_buf_set_keymap(input_buf, 'i', '<esc>', '<cmd>stopinsert<bar>bunload<cr>', { nowait = true, noremap = true, silent = true })
  api.nvim_buf_set_keymap(input_buf, 'n', '<esc>', '<cmd>stopinsert<bar>bunload<cr>', { nowait = true, noremap = true, silent = true })

  api.nvim_buf_set_keymap(input_buf, 'i', '<c-j>', '<cmd>lua require"isearch".next_result()<cr>', { nowait = true, noremap = true, silent = true })
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-k>', '<cmd>lua require"isearch".prev_result()<cr>', { nowait = true, noremap = true, silent = true })
  api.nvim_buf_set_keymap(input_buf, 'i', '<cr>', '<cmd>lua require"isearch".open_result()<cr>', { nowait = true, noremap = true, silent = true })
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-l>', '<cmd>lua require"isearch".open_result("vsplit")<cr>', { nowait = true, noremap = true, silent = true })
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-s>', '<cmd>lua require"isearch".open_result("split")<cr>', { nowait = true, noremap = true, silent = true })
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-t>', '<cmd>lua require"isearch".open_result("tabedit")<cr>', { nowait = true, noremap = true, silent = true })

  api.nvim_win_set_option(results_win, 'cursorline', true)

  api.nvim_win_set_option(frame_win, 'winhighlight', 'NormalFloat:isearchResults')
  api.nvim_win_set_option(input_win, 'winhighlight', 'NormalFloat:isearchInput')
  api.nvim_win_set_option(results_win, 'winhighlight', 'NormalFloat:isearchResults,CursorLine:isearchCursorLine')
  local items
  if type(input) == 'string' then
    items = api.nvim_call_function('systemlist', { input })
  else
    assert(type(input) == 'table')
    items = input
  end

  local items_ = {}
  for k,v in ipairs(items) do
    local fname = api.nvim_call_function('fnamemodify', { v, ':~' })
    items_[k] = fname
  end

  api.nvim_buf_set_lines(results_buf, 0, -1, true, items_)

  local function on_lines(_, buf, _, firstline)
    if firstline ~= 0 then
      return
    end
    local buf_lines = api.nvim_buf_get_lines(buf, firstline, firstline + 1, true)
    assert(#buf_lines > 0, 'empty lines')
    local query = buf_lines[1]
    local lines, match_cols = fuzzy_filter(query, items_)
    vim.schedule(function ()
      if ns then
        api.nvim_buf_clear_namespace(results_buf, ns, 0, -1)
      end
      ns = api.nvim_create_namespace('')
      api.nvim_buf_set_lines(results_buf, 0, -1, true, lines)
      for line=1,#lines do
        for _, col in ipairs(match_cols[line]) do
          api.nvim_buf_add_highlight(results_buf, ns, 'isearchMatch', line - 1, col - 1, col)
        end
      end
      move_results_cursor(0)
    end)
  end

  api.nvim_buf_attach(input_buf, false, { on_lines = on_lines })
  api.nvim_command('startinsert')
end

local function open_result(cmd)
  cmd = cmd or 'edit'
  local pos = api.nvim_win_get_cursor(results_win)
  local row = pos[1]
  local lines = api.nvim_buf_get_lines(results_buf, row - 1, row, true)
  api.nvim_command('stopinsert|close|'.. cmd .. lines[1])
end

local function search_oldfiles()
  filter(api.nvim_get_vvar('oldfiles'))
end

local function search_buffers()
  local bufs = api.nvim_list_bufs()
  local bufnames = {}
  for i=#bufs,1,-1 do
    if api.nvim_buf_is_loaded(bufs[i]) then
      table.insert(bufnames, api.nvim_buf_get_name(bufs[i]))
    end
  end
  filter(bufnames)
end

local function search_files()
  filter('fd --max-depth 10 --type f')
end

package.loaded.isearch = nil

return {
  search_files = search_files,
  search_buffers = search_buffers,
  search_oldfiles = search_oldfiles,
  prev_result = function () move_results_cursor(-1) end,
  next_result = function () move_results_cursor(1) end,
  open_result = open_result,
}
