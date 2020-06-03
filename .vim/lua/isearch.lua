local api = vim.api

local results_buf
local results_win
local ns

local function find_min_subsequence(target, sequence)
  local t = 1
  local s = 1
  local min_subsequence = {
    length = -1,
    start_index = nil,
    indices = {},
  }
  while t <= #target do
    -- increment `t` until it is on the character `s` is on
    while s <= #sequence and t <= #target do
      if sequence:sub(s, s) == target:sub(t, t) then
        break
      end
      t = t + 1
    end
    if t > #target then break end

    -- find the next valid subsequence in `target`
    local new_min = {
      length = 1,
      start_index = t,
      indices = {},
    }
    while s <= #sequence and t <= #target do
      if sequence:sub(s, s) ~= target:sub(t, t) then
        t = t + 1
        new_min.length = new_min.length + 1
      else
        table.insert(new_min.indices, t)
        s = s + 1
      end
    end

    if s > #sequence then
      if new_min.length < min_subsequence.length
        or min_subsequence.length == -1 then
        min_subsequence = new_min
      end
    end

    s = 1
    t = new_min.start_index + 1
  end

  return min_subsequence.start_index == nil and nil or min_subsequence.indices
end

local function calc_score(indices, path)
  local tail_s, tail_e  = path:find('[^/]+/?$')
  if not tail_s then return 0 end
  local count = 0
  for _, index in ipairs(indices) do
    if index >= tail_s  and index <= tail_e then
      count = count + 1
    end
  end
  return count
end

local function fuzzy_match(query, line)
  if #line == 0 then return nil end
  local match = { columns = {}, score = 0, line = line }
  if #query == 0 then return match end
  local columns = find_min_subsequence(line, query)
  if vim.tbl_isempty(columns) then return nil end
  match.columns = columns
  match.score = calc_score(match.columns, line)
  return match
end

local function fuzzy_filter(query, lines)
  query = query or ''
  local matches = {}
  for _, line in ipairs(lines) do
    local match = fuzzy_match(query, line)
    if match then
      table.insert(matches, match)
    end
  end
  table.sort(matches, function (a, b)
    return a.score > b.score
  end)
  return matches
end

local function move_results_cursor(offset)
  local pos = api.nvim_win_get_cursor(results_win)
  local lines = api.nvim_buf_line_count(results_buf)
  local row = math.max(1, math.min(lines, pos[1] + offset))
  api.nvim_win_set_cursor(results_win, { row, 0 })
  api.nvim_command('redraw!')
end

local function filter(source)
  local frame_buf = api.nvim_create_buf(false, true)
  local input_buf = api.nvim_create_buf(false, true)
  results_buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(input_buf, 'bufhidden', 'wipe')

  local num_columns = api.nvim_get_option('columns')
  local num_lines = api.nvim_get_option('lines')

  local height = math.ceil(num_lines * 0.6 - 4)
  local width = math.ceil(num_columns * 0.6)

  local row = math.ceil((num_lines - height) / 2 - 1)
  local col = math.ceil((num_columns - width) / 2)

  local top = '┌' .. ('─'):rep(width - 2) .. '┐'
  local mid = '│' .. (' '):rep(width - 2) .. '│'
  local bot = '└' .. ('─'):rep(width - 2) .. '┘'

  local border_lines = {}
  table.insert(border_lines, top)
  for _ = 1, height - 2 do
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

  local input
  if type(source) == 'string' then
    input = api.nvim_call_function('systemlist', { source })
  else
    assert(type(source) == 'table')
    input = source
  end

  local lines = {}
  for k, v in ipairs(input) do
    local fname = api.nvim_call_function('fnamemodify', { v, ':~' })
    lines[k] = fname
  end

  api.nvim_buf_set_lines(results_buf, 0, -1, true, lines)

  local function on_lines(_, buf, _, firstline)
    if firstline ~= 0 then
      return
    end
    local buf_lines = api.nvim_buf_get_lines(buf, firstline, firstline + 1, true)
    assert(#buf_lines > 0, 'empty lines')
    local query = buf_lines[1]
    local matches = fuzzy_filter(query, lines)
    vim.schedule(function ()
      if ns then
        api.nvim_buf_clear_namespace(results_buf, ns, 0, -1)
      end
      ns = api.nvim_create_namespace('')

      local matched_lines = {}
      for _, match in ipairs(matches) do
        table.insert(matched_lines, match.line)
      end
      api.nvim_buf_set_lines(results_buf, 0, -1, true, matched_lines)

      for i, match in ipairs(matches) do
        for _, match_col in ipairs(match.columns) do
          api.nvim_buf_add_highlight(results_buf, ns, 'isearchMatch', i - 1, match_col - 1, match_col)
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
  for i =# bufs, 1, -1 do
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
