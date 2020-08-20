local snippets = require'snippets'

if vim.fn.has('vim_starting') == 0 then
    return
end

snippets.snippets = {
    reason = {
        l = "Js.log({$0})",
        cl = "className={Stylex.use(styles##$0)}",
        sty = [[
let styles = Stylex.make({
    "$1": {
        $0
    }
});
]],
    },
}

