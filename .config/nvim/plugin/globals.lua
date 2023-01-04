local print_ORIG = _G.print

-- Patch `print` to call vim.inspect on each table arg
local function print_PATCHED(...)
    local args = {}
    local num_args = select("#", ...)
    -- Use for loop instead of `tbl_map` because `pairs` iteration stops at nil
    for i = 1, num_args do
        local arg = select(i, ...)
        if ("table" == type(arg)) then
            table.insert(args, vim.inspect(arg))
        elseif ("nil" == type(arg)) then  -- lest it be ignored
            table.insert(args, "nil")
        else
            table.insert(args, arg)
        end
    end
    return print_ORIG(unpack(args))
end

_G.print = print_PATCHED

_G.P = function(...)
    print_PATCHED(...)
    return ...
end
