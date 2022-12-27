local function nav_change_list(cmd)
    local _local_1_ = vim.api.nvim_win_get_cursor(0)
    local line = _local_1_[1]
    vim.cmd(("sil! normal! " .. cmd))
    local _local_2_ = vim.api.nvim_win_get_cursor(0)
    local line2 = _local_2_[1]
    if line == line2 then
        vim.cmd(("sil! normal! " .. cmd))
    end
end

-- Adapted from lacygoill's vimrc
local function zoom_toggle()
    if vim.fn.winnr("$") ~= 1 then
        if vim.t.zoom_restore then
            vim.cmd("exe t:zoom_restore")
            vim.cmd("unlet t:zoom_restore")
        else
            vim.t.zoom_restore = vim.fn.winrestcmd()
            vim.cmd("wincmd |")
            vim.cmd("wincmd _")
        end
    end
end

-- Adapted from lacygoill's vimrc
local function repeat_last_edit()
    local changed = vim.fn.getreg("\"", 1, 1)
    if changed then
        local changed0
        -- Escape backslashes
        changed0 = vim.tbl_map(function(c)
            return vim.fn.escape(c, "\\")
        end, changed)
        local pat = table.concat(changed0, "\\n")
        -- Put the last changed text inside the search register, so that we can refer
        -- to it with the text-object `gn`
        vim.fn.setreg("/", ("\\V" .. pat), "c")
        vim.cmd("exe \"norm! cgn\\<c-@>\"")
    end
end

-- Adapted from lacygoill's vimrc
local function search_in_visual_selection()
    vim.api.nvim_input("/\\%V")
end

-- Adapted from lacygoill's vimrc
local function previous_window_in_same_direction(dir)
    local cnr = vim.fn.winnr()
    local pnr = vim.fn.winnr("#")
    local _9_ = dir
    if (_9_ == "h") then
        local leftedge_current_window = vim.fn.win_screenpos(cnr)[2]
        local rightedge_previous_window = ((vim.fn.win_screenpos(pnr)[2] + vim.fn.winwidth(pnr)) - 1)
        return ((leftedge_current_window - 1) == (rightedge_previous_window + 1))
    elseif (_9_ == "l") then
        local leftedge_previous_window = vim.fn.win_screenpos(pnr)[2]
        local rightedge_current_window = ((vim.fn.win_screenpos(cnr)[2] + vim.fn.winwidth(cnr)) - 1)
        return ((leftedge_previous_window - 1) == (rightedge_current_window + 1))
    elseif (_9_ == "j") then
        local topedge_previous_window = vim.fn.win_screenpos(pnr)[1]
        local bottomedge_current_window = ((vim.fn.win_screenpos(cnr)[1] + vim.fn.winheight(cnr)) - 1)
        return ((topedge_previous_window - 1) == (bottomedge_current_window + 1))
    elseif (_9_ == "k") then
        local topedge_current_window = vim.fn.win_screenpos(cnr)[1]
        local bottomedge_previous_window = ((vim.fn.win_screenpos(pnr)[1] + vim.fn.winheight(pnr)) - 1)
        return ((topedge_current_window - 1) == (bottomedge_previous_window + 1))
    else
        return nil
    end
end

local function navigate(dir)
    if previous_window_in_same_direction(dir) then
        return vim.cmd("try | wincmd p | catch | entry")
    else
        return vim.cmd(("try | wincmd " .. dir .. " | catch | endtry"))
    end
end

local function plain_rename()
    local cword = vim.fn.expand("<cword>")
    vim.fn.setreg("/", ("\\<" .. cword .. "\\>"), "c")
    local keys = vim.api.nvim_replace_termcodes(":%s///g<left><left>", true, false, true)
    return vim.api.nvim_feedkeys(keys, "n", false)
end

-- Adapted from nvim-treesitter-refactor
local function ts_rename()
    local ts_utils = require("nvim-treesitter.ts_utils")
    local locals = require("nvim-treesitter.locals")
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_node = ts_utils.get_node_at_cursor(0, false)
    local function complete_rename(new_name)
        if (new_name and (#new_name > 0)) then
            local definition, scope = locals.find_definition(cursor_node, bufnr)
            local nodes_to_rename = {}
            nodes_to_rename[cursor_node:id()] = cursor_node
            nodes_to_rename[definition:id()] = definition
            for _, n in ipairs(locals.find_usages(definition, scope, bufnr)) do
                nodes_to_rename[n:id()] = n
            end
            local edits = {}
            for _, node in pairs(nodes_to_rename) do
                local lsp_range = ts_utils.node_to_lsp_range(node)
                local text_edit = {range = lsp_range, newText = new_name}
                table.insert(edits, text_edit)
            end
            return vim.lsp.util.apply_text_edits(edits, bufnr, "utf-8")
        else
            return nil
        end
    end
    if not cursor_node then
        vim.api.nvim_err_writeln("No node to rename!")
    else
        vim.ui.input({default = "", prompt = "New name: "}, complete_rename)
    end
end

local function lsp_rename()
    -- vim.lsp.buf.rename()
    vim.api.nvim_feedkeys(":IncRename ", "n", false)
end

local function rename()
    local parsers = require("nvim-treesitter.parsers")
    local ts_enabled = parsers.has_parser(nil)
    local lsp_enabled = not vim.tbl_isempty(vim.lsp.get_active_clients({bufnr = 0}))
    if lsp_enabled then
        lsp_rename()
    elseif ts_enabled then
        ts_rename()
    else
        plain_rename()
    end
end

local map = vim.keymap.set

-- Enhanced defaults
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "<Down>", "gj")
map("n", "<Up>", "gk")
map("n", "<c-e>", "<c-e><c-e>")
map("n", "<c-y>", "<c-y><c-y>")
map("", "<C-g>", "g<C-g>")
map("n", "<", "<<")
map("n", ">", ">>")
map("x", "<", "<gv")
map("x", ">", ">gv")
map({"n", "x"}, "s", "\"_s")
map("n", "p", "getreg(v:register) =~# \"\\n\" ? \"pmv=g']g`v\" : 'p'", {expr = true})
map("n", "P", "getreg(v:register) =~# \"\\n\" ? \"Pmv=g']g`v\" : 'P'", {expr = true})
map("x", "p", "'\"_c<C-r>'.v:register.'<Esc>'", {expr = true})
map("n", "`", "g`")
map("n", "'", "g'")
map("n", "n", "<Cmd>keepj norm! nzzzv<CR>", {silent = true})
map("n", "N", "<Cmd>keepj norm! Nzzzv<CR>", {silent = true})
map("n", "*", "*zzzv", {silent = true})
map("n", "#", "#zzzv", {silent = true})
map("n", "g*", "g*zzzv", {silent = true})
map("n", "g#", "g#zzzv", {silent = true})
map("n", "g;", function() nav_change_list('g;') end)
map("n", "g'", function() nav_change_list("g,") end)
map("n", "<PageUp>", "<PageUp>:keepj norm! H<CR>", {silent = true})
map("n", "<PageDown>", "<PageDown>:keepj norm! L<CR>", {silent = true})
map("n", "/", "/\\V")

-- Rearrange some default mappings
map({"n", "x"}, ";", ":")
map({"n", "x"}, ":", ";")
map("n", "`", "'")
map("n", "'", "`")
map("", "H", "^")
map("", "L", "$")
map("", "(", "H", {silent = true})
map("", ")", "L", {silent = true})
map("n", "<Home>", "<Cmd>keepj norm! gg<CR>", {silent = true})
map("n", "<End>", "<Cmd>keepj norm! G<CR>", {silent = true})
map("n", "<C-s>", "<C-a>", {silent = true})
map("", "<tab>", "<Cmd>keepj norm! %<CR>", {silent = true})
map("n", "<C-p>", "<Tab>")
map("n", "<C-l>", function() navigate'l' end, {silent = true})
map("n", "<C-h>", function() navigate'h' end, {silent = true})
map("n", "<C-j>", function() navigate'j' end, {silent = true})
map("n", "<C-k>", function() navigate'k' end, {silent = true})

-- Miscellaneous
map("n", "cn", "cgn", {silent = true})
map({"n", "x"}, "Z", "zzzH")
map("n", "Q", "@q")
map("n", "<A-LeftMouse>", "<nop>")
map("n", "<CR>", "<Cmd>w<CR>", {silent = true})
map("", "<C-q>", "<Cmd>q<CR>", {silent = true})
map("n", "<space>l", "<Cmd>vsplit<CR>", {silent = true})
map("n", "<space>j", "<Cmd>split<CR>", {silent = true})
map("n", "<space>t", "<Cmd>tabedit<CR>", {silent = true})
map("", "<Space>d", "<Cmd>call Kwbd(1)<CR>", {silent = true})
map("", "<Space>q", "<Cmd>b#<CR>", {silent = true})
map("n", "g>", "<Cmd>40messages<CR>", {silent = true})
map("n", "gi", "g`^")  -- go to last insert
map("n", "g.", "g`.")  -- go to last change
map("n", "gs", "g`[vg`]")  -- select last changed/yanked text
map("n", "gS", "g'[Vg']")
map("n", "<space>z", zoom_toggle, {silent = true})
map("x", ".", ":norm! .<CR>", {silent = true})
map("n", "<space>.", repeat_last_edit)
map("x", "/", search_in_visual_selection)
map("x", "<space>y", "\"*y")
-- Adapted from justinmk's vimrc
map("x", "I", "mode() =~# '[vV]' ? '<C-v>^o^I' : 'I'", {expr = true})
map("x", "A", "mode() =~# '[vV]' ? '<C-v>0o$A' : 'A'", {expr = true})
-- Adapted from primeagen's vimrc
map("x", "J", ":m '>+1<CR>gv=gv")
map("x", "K", ":m '<-2<CR>gv=gv")

-- Command mode
map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")
map("c", "<C-j>", "<C-g>")
map("c", "<C-k>", "<C-t>")
map("c", "<C-a>", "<Home>")

-- Keepjumps
map("n", "M", "<Cmd>keepj norm! M<CR>", {silent = true})
map("n", "{", "<Cmd>keepj norm! {<CR>", {silent = true})
map("n", "}", "<Cmd>keepj norm! }<CR>", {silent = true})
map("n", "gg", "<Cmd>keepj norm! gg<CR>", {silent = true})
map("n", "G", "<Cmd>keepj norm! G<CR>", {silent = true})

-- Search & substitute
-- NOTE: Doesn't support multiline selection. Adapted from lacygoill's vimrc.
map("x", "*", "\"vy:let @/='\\<<c-r>v\\>'<CR>nzzzv", {silent = true})
map("x", "#", "\"vy:let @/='\\<<c-r>v\\>'<CR>Nzzzv", {silent = true})
map("x", "g*", "\"vy:let @/='<c-r>v'<CR>nzzzv", {silent = true})
map("x", "g#", "\"vy:let @/='<c-r>v'<CR>Nzzzv", {silent = true})
map("n", "g/", ":<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {silent = true})
map("x", "g/", "\"vy:let @/='<c-r>v'<Bar>set hls<CR>")
map({"n", "x"}, "<RightMouse>", "<leftmouse>:<c-u>let @/='\\<<c-r>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", {silent = true})
map("n", "<Space>s", "ms:<C-u>%s///g<left><left>")
map("x", "<space>s", "\"vy:let @/='<c-r>v'<CR>:<C-u>%s///g<left><left>")
map("n", "R", rename)
map("n", "gr", "R")

-- Alt
map("!", "<A-h>", "<Left>")
map("!", "<A-l>", "<Right>")
map("!", "<A-j>", "<C-Left>")
map("!", "<A-k>", "<C-Right>")
map("n", "<A-l>", "<C-w>L")
map("n", "<A-h>", "<C-w>H")
map("n", "<A-j>", "<C-w>J")
map("n", "<A-k>", "<C-w>K")

-- Bracket
map("n", "]b", "<Cmd>bnext<CR>", {silent = true})
map("n", "[b", "<Cmd>bprev<CR>", {silent = true})
map("n", "[t", "<Cmd>tabprev<CR>", {silent = true})
map("n", "]t", "<Cmd>tabnext<CR>", {silent = true})
map("n", "]T", "<Cmd>+tabmove<CR>", {silent = true})
map("n", "[T", "<Cmd>-tabmove<CR>", {silent = true})
map("n", "]q", ":<C-u><C-r>=v:count1<CR>cnext<CR>zz", {silent = true})
map("n", "[q", ":<C-u><C-r>=v:count1<CR>cprev<CR>zz", {silent = true})
map("n", "]Q", "<Cmd>cnfile<CR>zz", {silent = true})
map("n", "[Q", "<Cmd>cpfile<CR>zz", {silent = true})
map("n", "]l", ":<C-u><c-r>=v:count1<CR>lnext<CR>zz", {silent = true})
map("n", "[l", ":<C-u><c-r>=v:count1<CR>lprev<CR>zz", {silent = true})
map("n", "]L", "<Cmd>lnfile<CR>zz", {silent = true})
map("n", "[L", "<Cmd>lpfile<CR>zz", {silent = true})
-- Adapted from lacygoill's vimrc.
map("", "]n", "/\\v^[<\\|=>]{7}<CR>zvzz", {silent = true})
map("", "[n", "?\\v^[<\\|=>]{7}<CR>zvzz", {silent = true})
local function move_line(dir)
    vim.cmd("keepj norm! mv")
    vim.cmd("move " .. dir == 'up' and '--' or '+' .. vim.v.count1)
    vim.cmd("keepj norm! =`v")
end
map("n", "[d", function() move_line'up' end)
map("n", "]d", function() move_line'down' end)

-- Bookmarks
map("n", ":V", "<Cmd>e ~/.config/nvim/<CR>", {silent = true})
map("n", ":L", "<Cmd>e ~/.config/nvim/lua/<CR>", {silent = true})
map("n", ":C", "<Cmd>e ~/.config/nvim/lua/config/<CR>", {silent = true})
map("n", ":A", "<Cmd>e ~/.config/nvim/after/ftplugin/<CR>", {silent = true})
map("n", ":P", "<Cmd>e ~/.local/share/nvim/site/pack/packer/start/<CR>", {silent = true})
map("n", ":R", "<Cmd>e $VIMRUNTIME<CR>", {silent = true})
map("n", ":Z", "<Cmd>e ~/.zshrc<CR>", {silent = true})
map("n", ":N", "<Cmd>e ~/notes/_notes.md<CR>", {silent = true})
map("n", ":T", "<Cmd>e ~/notes/_todo.md<CR>", {silent = true})
map("n", ":X", "<Cmd>e ~/.config/tmux/tmux.conf<CR>", {silent = true})
map("n", ":U", "<Cmd>e ~/Library/Application\\ Support/Firefox/Profiles/2a6723nr.default-release/user.js<CR>", {silent = true})

-- Text objects
map({"x", "o"}, "il", "<Cmd>norm! g_v^<CR>", {silent = true})
map({"x", "o"}, "al", "<Cmd>norm! $v0<CR>", {silent = true})
map("x", "id", "<Cmd>norm! G$Vgg0<CR>", {silent = true})
map("o", "id", "<Cmd>norm! GVgg<CR>", {silent = true})

-- Document/file name
map("i", "<C-d>", "<c-r>=expand(\"%:t:r:r:r\")<CR>")
map("c", "<C-d>", "<c-r>=expand(\"%:t:r:r:r\")<CR>")
local function yank_doc(exp)
    local txt = vim.fn.expand(exp)
    vim.fn.setreg('"', txt, "c")
    vim.fn.setreg("+", txt, "c")
end
map("n", "yd", function() yank_doc("%:t:r:r:r") end, {silent = true})
map("n", "yD", function() yank_doc('%:p') end, {silent = true})

-- Toggle options
map("n", "gon", "<Cmd>set number!<CR>", {silent = true})
map("n", "goc", "<Cmd>set cursorline!<CR>", {silent = true})
map("n", "gow", "<Cmd>set wrap!<Bar>set wrap?<CR>", {silent = true})
map("n", "gol", "<Cmd>set hlsearch!<Bar>set hlsearch?<CR>", {silent = true})
map("n", "goi", "<Cmd>set ignorecase!<Bar>set ignorecase?<CR>", {silent = true})
map("n", "gof", "<Cmd>let g:format_disabled = !get(g:, 'format_disabled', 0)<Bar>let g:format_disabled<CR>", {silent = true})

-- Diagnostics
map("n", "ge", "<Cmd>lua vim.diagnostic.open_float()<CR>", {silent = true})
map("n", "[e", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", {silent = true})
map("n", "]e", "<Cmd>lua vim.diagnostic.goto_next()<CR>", {silent = true})
map("n", "gl", "<Cmd>lua vim.diagnostic.setloclist()<CR>", {silent = true})

--Folds
map("n", "zk", "zc", {silent = true})
map("n", "zK", "zC", {silent = true})
map("n", "zj", "zo", {silent = true})
map("n", "zJ", "zO", {silent = true})

-- Avoid typo
vim.cmd 'cnoreabbrev ~? ~/'
vim.cmd [[cnoreabbrev <expr> man getcmdtype() is# ":" && getcmdpos() == 4 ? 'vert Man' : 'man']]
