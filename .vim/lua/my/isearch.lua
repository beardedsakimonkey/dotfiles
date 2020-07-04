local api = vim.api

local frame_buf
local results_buf
local results_win
local preview_buf
local preview_win
local input_buf
local input_win
-- the window from which the search was executed
local prev_win
local show_preview

-- namespaces are useful for batch deletion/updating
local matches_ns = api.nvim_create_namespace('isearch_matches')

local function find_min_subsequence(target, sequence)
  local t = 1
  local s = 1
  local min_subsequence = {
    length = -1,
    start_index = nil,
    columns = {},
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
      columns = {},
    }
    while s <= #sequence and t <= #target do
      if sequence:sub(s, s) ~= target:sub(t, t) then
        t = t + 1
        new_min.length = new_min.length + 1
      else
        table.insert(new_min.columns, t)
        s = s + 1
        t = t + 1
      end
    end

    if s > #sequence then
      if new_min.length <= min_subsequence.length
        or min_subsequence.length == -1 then
        min_subsequence = new_min
      end
    end

    s = 1
    t = new_min.start_index + 1
  end

  return min_subsequence.start_index == nil and nil or min_subsequence.columns
end

-- assert(vim.deep_equal(find_min_subsequence('~/foo/bar/foo.txt', 'foo'), {11, 12, 13}))

local function calc_score(columns, path)
  local tail_s, tail_e  = path:find('[^/]+/?$')
  if not tail_s then return 0 end
  local count = 0
  local prev_column = -1
  for _, column in ipairs(columns) do
    local is_consecutive = column == prev_column + 1
    if is_consecutive then
      count = count + 1
    end
    if column >= tail_s  and column <= tail_e then
      count = count + 1
    end
    prev_column = column
  end
  return count
end

local function fuzzy_match(query, line)
  if #line == 0 then return nil end
  local match = { columns = {}, score = 0, line = line }
  if #query == 0 then return match end
  local columns = find_min_subsequence(line:lower(), query:lower())
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

local function update_results_info(total)
  local virt_text = { {'(' .. total .. ')', 'Comment'} }
  api.nvim_buf_set_virtual_text(input_buf, -1, 0, virt_text, {})
  api.nvim_command('redraw!')
end

local function update_preview()
  local cursor_row, _ = unpack(api.nvim_win_get_cursor(results_win))
  local cursor_line = api.nvim_buf_get_lines(results_buf, cursor_row - 1, cursor_row, true)
  assert(#cursor_line > 0, 'empty buf_get_lines - buffer got unloaded?')
  local raw_line = cursor_line[1]
  local filename = raw_line
  local found_line_nr, _, matched_filename, line_nr = raw_line:find('^([^:]+):(%d+):')
  if found_line_nr then
    filename = matched_filename
  end
  filename = vim.fn.fnamemodify(filename, ':p')
  local function clear_preview()
    api.nvim_buf_set_lines(preview_buf, 0, -1, true, {})
  end
  if vim.fn.filereadable(filename) == 0 then
    clear_preview()
    return
  end
  local size = vim.fn.getfsize(filename)
  local mb = 1024 * 1024
  if size > 2 * mb or size == -2 then
    clear_preview()
    return
  end
  local lines = vim.fn.readfile(filename)
  if #lines == 0 then
    clear_preview()
    return
  end
  -- NOTE: using `nvim_buf_set_lines()` instead of `:edit` has the drawback of
  -- not being able to jump to the " mark. However, it means we don't have to
  -- worry about whether we should unload buffers.
  -- FIXME: this sometimes errors for binary files: `String cannot contain
  -- newlines`
  api.nvim_buf_set_lines(preview_buf, 0, -1, true, lines)
  if found_line_nr then
    local line = tonumber(line_nr) or 1
    api.nvim_win_set_cursor(preview_win, { line, 0 })
    api.nvim_buf_add_highlight(preview_buf, -1, 'isearchPreviewLine', line - 1, 0, -1)
  end
  api.nvim_set_current_win(preview_win)
  -- XXX: This will trigger an autocmd in $VIMRUNTIME/filetype.vim to set
  -- 'filetype', which will, in turn, trigger a FileType autocmd in
  -- $VIMRUNTIME/syntax/syntax.vim to set 'syntax'. Unfortunately, triggering
  -- FileType can cause nvim_lsp to spin up a language server. Ideally,
  -- nvim_lsp would allow users to define their own `autocmd`s, which would
  -- allow for something like:
  --
  --    autocmd FileType foo if &buftype isnot "nofile" | ... | endif
  --
  api.nvim_command('doautocmd filetypedetect BufRead ' .. vim.fn.fnameescape(filename))
  api.nvim_set_current_win(input_win)
end

local function move_results_cursor(offset)
  local cursor_row, _ = unpack(api.nvim_win_get_cursor(results_win))
  local lines = api.nvim_buf_line_count(results_buf)
  local row = math.max(1, math.min(lines, cursor_row + offset))
  api.nvim_win_set_cursor(results_win, { row, 0 })
  api.nvim_command('redraw!')
  if show_preview == true then
    vim.schedule(update_preview)
  end
end

local function search(source, _show_preview)
  show_preview = _show_preview
  frame_buf = api.nvim_create_buf(false, true)
  input_buf = api.nvim_create_buf(false, true)
  results_buf = api.nvim_create_buf(false, true)
  preview_buf = api.nvim_create_buf(false, true)
  prev_win = api.nvim_get_current_win()

  api.nvim_buf_set_option(input_buf, 'bufhidden', 'wipe')

  local num_columns = api.nvim_get_option('columns')
  local num_lines = api.nvim_get_option('lines')

  local height = math.ceil((num_lines * (num_lines < 30 and 0.8 or 0.9)))
  local width = math.ceil(num_columns * (num_columns < 160 and 0.8 or 0.9))

  -- position of the window
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

  results_win = api.nvim_open_win(results_buf, false, {
    style = 'minimal',
    relative = 'editor',
    width = show_preview and math.ceil((width - 4) / 2) or width - 4,
    height = height - 3,
    row = row + 2,
    col = col + 2,
  })

  if show_preview then
    preview_win = api.nvim_open_win(preview_buf, false, {
      style = 'minimal',
      relative = 'editor',
      width = math.ceil((width - 4) / 2) - 1,
      height = height - 2,
      row = row + 1,
      col = col + 2 + math.ceil((width - 4) / 2) + 1,
    })
  end

  local frame_win = api.nvim_open_win(frame_buf, false, {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
  })

  api.nvim_buf_set_lines(frame_buf, 0, -1, true, border_lines)

  input_win = api.nvim_open_win(input_buf, true, {
    style = 'minimal',
    relative = 'editor',
    width = show_preview and math.ceil((width - 4) / 2) or width - 4,
    height = 1,
    row = row + 1,
    col = col + 2,
  })

  api.nvim_command('autocmd BufWipeout <buffer> lua require"my.isearch".quit()')

  local opts = { nowait = true, noremap = true, silent = true }
  api.nvim_buf_set_keymap(input_buf, 'i', '<esc>', '<cmd>stopinsert<bar>bunload<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'n', '<esc>', '<cmd>stopinsert<bar>bunload<cr>', opts)

  api.nvim_buf_set_keymap(input_buf, 'i', '<c-j>', '<cmd>lua require"my.isearch".next_result()<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-k>', '<cmd>lua require"my.isearch".prev_result()<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<down>', '<cmd>lua require"my.isearch".next_result()<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<up>', '<cmd>lua require"my.isearch".prev_result()<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<cr>', '<cmd>lua require"my.isearch".open_result("edit")<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-l>', '<cmd>lua require"my.isearch".open_result("vsplit")<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-s>', '<cmd>lua require"my.isearch".open_result("split")<cr>', opts)
  api.nvim_buf_set_keymap(input_buf, 'i', '<c-t>', '<cmd>lua require"my.isearch".open_result("tabedit")<cr>', opts)

  api.nvim_win_set_option(results_win, 'cursorline', true)

  api.nvim_win_set_option(frame_win, 'winhighlight', 'NormalFloat:isearchResults')
  api.nvim_win_set_option(input_win, 'winhighlight', 'NormalFloat:isearchInput')
  api.nvim_win_set_option(results_win, 'winhighlight', 'NormalFloat:isearchResults,CursorLine:isearchCursorLine')
  if show_preview then
    api.nvim_win_set_option(preview_win, 'winhighlight', 'NormalFloat:isearchPreview')
  end

  -- redraw before running a potentially slow command
  api.nvim_command('redraw!')

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

  -- initial population of the results buffer. don't need to do any fuzzy
  -- matching.
  api.nvim_buf_set_lines(results_buf, 0, -1, true, lines)
  update_results_info(#lines)
  if show_preview then update_preview() end

  local function on_lines(_, buf, _, firstline)
    if firstline ~= 0 then
      return
    end
    local buf_lines = api.nvim_buf_get_lines(buf, firstline, firstline + 1, true)
    assert(#buf_lines > 0, 'empty buf_get_lines - buffer got unloaded?')
    local query = buf_lines[1]
    -- do fuzzy matching
    local matches = fuzzy_filter(query, lines)

    vim.schedule(function ()
      api.nvim_buf_clear_namespace(results_buf, matches_ns, 0, -1)

      -- put the matched lines into the results buffer
      local matched_lines = {}
      for _, match in ipairs(matches) do
        table.insert(matched_lines, match.line)
      end
      api.nvim_buf_set_lines(results_buf, 0, -1, true, matched_lines)

      -- highlight matched characters
      for i, match in ipairs(matches) do
        for _, match_col in ipairs(match.columns) do
          api.nvim_buf_add_highlight(results_buf, matches_ns, 'isearchMatch', i - 1, match_col - 1, match_col)
        end
      end
      -- NOTE: this also updates the preview buffer
      move_results_cursor(0)
      update_results_info(#matched_lines)
    end)
  end

  api.nvim_buf_attach(input_buf, false, { on_lines = vim.schedule_wrap(on_lines) })
  api.nvim_command('startinsert')
end

local function open_result(cmd)
  local pos = api.nvim_win_get_cursor(results_win)
  local row = pos[1]
  local lines = api.nvim_buf_get_lines(results_buf, row - 1, row, true)
  local raw_line = lines[1]
  local filename = raw_line
  local found_line_nr, _, matched_filename, matched_line_nr = raw_line:find('^([^:]+):(%d+):')
  if found_line_nr then
    filename = matched_filename
  end
  cmd = 'stopinsert|close|' .. cmd .. ' ' .. filename
  if matched_line_nr then
    -- TODO: how to jump to a column number?
    cmd = cmd .. '|' .. matched_line_nr
  end
  api.nvim_command(cmd)
end

local function search_oldfiles()
  -- TODO: would like to also score based on ordering
  search(api.nvim_get_vvar('oldfiles'), true)
end

-- exclude unloaded buffers, current buffer, buffers in the current tabpage
local function should_show_buffer(b)
  return api.nvim_buf_is_loaded(b)
    and api.nvim_buf_get_option(b, 'buftype') == ''
    and b ~= api.nvim_get_current_buf()
    and vim.fn.index(vim.fn.tabpagebuflist(), b) == -1
end

local function search_buffers()
  local bufs = api.nvim_list_bufs()
  local bufnames = {}
  for i =# bufs, 1, -1 do
    if should_show_buffer(bufs[i]) then
      table.insert(bufnames, api.nvim_buf_get_name(bufs[i]))
    end
  end
  -- TODO: some way to delete buffers
  search(bufnames, true)
end

local function search_files()
  search('fd --max-depth 5 -I --type f', true)
end

local function grep(cmd)
  search(cmd, true)
end

local function quit()
  local cmd = 'silent bwipeout'
  if frame_buf then cmd = cmd .. ' ' .. frame_buf end
  if results_buf then cmd = cmd .. ' ' .. results_buf end
  if preview_buf then cmd = cmd .. ' ' .. preview_buf end
  api.nvim_command(cmd)
  -- XXX: what happens if window isn't around any longer?
  api.nvim_set_current_win(prev_win)
  frame_buf = nil
  results_buf = nil
  results_win = nil
  preview_buf = nil
  preview_win = nil
  input_buf = nil
  input_win = nil
  prev_win = nil
  show_preview = nil
end

package.loaded['my.isearch'] = nil

return {
  search_files = search_files,
  search_buffers = search_buffers,
  search_oldfiles = search_oldfiles,
  grep = grep,
  prev_result = function () move_results_cursor(-1) end,
  next_result = function () move_results_cursor(1) end,
  open_result = open_result,
  quit = quit,
}
