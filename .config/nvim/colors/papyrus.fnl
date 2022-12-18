;; Color shorthands: $VIMRUNTIME/rgb.txt

(vim.cmd "hi clear")
(set vim.opt.background :light)

(when (= 1 (vim.fn.exists :syntax_on))
  (vim.cmd "syntax reset"))

(set vim.g.colors_name :papyrus)

(macro hi [name ...]
  (local cfg
         (collect [_ arg (ipairs [...])]
           (let [arg (tostring arg)
                 (key value) (string.match arg "(.+)=(.*)")]
             (if (not= nil key)
                 (values (tostring key) (tostring value))
                 (match arg
                   :bold (values :bold 1)
                   :italic (values :italic 1)
                   :underline (values :underline 1)
                   _ (assert-compile false (.. "Invalid attr " arg)))))))
  `(vim.api.nvim_set_hl 0 ,(tostring name) ,cfg))

(macro link [from to]
  (local cfg {:link to})
  `(vim.api.nvim_set_hl 0 ,from ,cfg))

(hi   Cursor       fg=White        bg=Black)
(hi   Normal       fg=Black        bg=#CDCABD)
(hi   NonText      fg=none         bg=#C5C2B5)
(hi   Visual       fg=fg           bg=OliveDrab2)
(hi   Search       fg=none         bg=#ffd787)
(hi   IncSearch    fg=Black        bg=#ffc17a)
(link :CurSearch    :IncSearch)
(hi   WarningMsg   fg=Red4         bg=none :bold)
(hi   ErrorMsg     fg=White        bg=IndianRed3)
(hi   PreProc      fg=DeepPink4    bg=none)
(hi   Comment      fg=Burlywood4   bg=none)
(hi   Identifier   fg=Black        bg=none)
(hi   Function     fg=Black)
(hi   LineNr       fg=Burlywood4)
(hi   Statement    fg=MidnightBlue bg=none)
(hi   Keyword      fg=MidnightBlue bg=none)
(hi   Type         fg=#6D16BD      bg=none)
(hi   Constant     fg=#BD00BD      bg=none)
(hi   Special      fg=DodgerBlue4  bg=none)
(hi   String       fg=DarkGreen    bg=none)
(hi   Whitespace   fg=#bab28f) ;; trail listchar
(hi   Directory    fg=Blue3        bg=none)
(hi   SignColumn   fg=none         bg=#c9c5b5)
(hi   Todo         fg=Burlywood4   bg=none :bold)
(hi   MatchParen   fg=none         bg=PaleTurquoise)
(hi   Title        fg=DeepPink4    :bold)
(hi   Pmenu        bg=#e5daa5)
(hi   PmenuSel     bg=LightGoldenrod3)
(hi   StatusLine   fg=#CDCABD      bg=MistyRose4)
(hi   StatusLineNC fg=#CDCABD      bg=#b2a99d)
(hi   TabLineFill  bg=MistyRose4)
(hi   VertSplit    fg=#CDCABD      bg=MistyRose4)
(hi   CursorLine   bg=#ccc5b5)
(hi   Underlined   fg=#BD00BD      :underline)
(hi   ColorColumn  bg=#ccb3a9)
(link :CursorLineNr :LineNr)
(link :SpecialKey   :Directory)
;; (link :FloatBorder  :Normal)

(hi   DiffAdd      fg=none         bg=#c6ddb1)
(hi   DiffChange   fg=none         bg=#dbd09d)
(hi   DiffText     fg=none         bg=#f4dc6e)
(hi   DiffDelete   fg=none         bg=#dda296)

(hi User1 fg=AntiqueWhite2 bg=MistyRose4 :bold)
(hi User2 fg=Black         bg=OliveDrab2)
(hi User3 fg=Red3          bg=MistyRose4)
(hi User4 fg=Orange3       bg=MistyRose4)
(hi User5 fg=Grey          bg=MistyRose4)
(hi User6 fg=#CDCABD       bg=MistyRose4 :bold)
(hi User7 fg=#CDCABD       bg=MistyRose4)
(hi User8 fg=AntiqueWhite2 bg=MistyRose4 :bold)

(hi DiagnosticError          fg=Red3)
(hi DiagnosticWarn           fg=Orange3)
(hi DiagnosticInfo           fg=Orange2)
(hi DiagnosticHint           fg=Orange2)
(hi DiagnosticUnderlineError bg=#dda296)
(hi DiagnosticUnderlineWarn  bg=#e5daa5)
(hi DiagnosticUnderlineInfo  bg=#dbd09d)
(hi DiagnosticUnderlineHint  bg=#dbd09d)
(hi DiagnosticSignError      bg=#c9c5b5 fg=Red3)
(hi DiagnosticSignWarn       bg=#c9c5b5 fg=Orange3)
(hi DiagnosticSignInfo       bg=#c9c5b5 fg=Orange2)
(hi DiagnosticSignHint       bg=#c9c5b5 fg=Orange2)

(vim.cmd "sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=")
(vim.cmd "sign define DiagnosticSignWarn  text=● texthl=DiagnosticSignWarn  linehl= numhl=")
(vim.cmd "sign define DiagnosticSignInfo  text=● texthl=DiagnosticSignInfo  linehl= numhl=")
(vim.cmd "sign define DiagnosticSignHint  text=● texthl=DiagnosticSignHint  linehl= numhl=")

(link :UdirExecutable :PreProc)

(hi :UfindMatch fg=#BD00BD bg=none :bold)
(link :UfindCursorLine :DiffChange)

(hi   FennelSymbol fg=Black)

(link :markdownH1   :Title)
(link :markdownH2   :Statement)
(hi   markdownUrl  fg=#0645ad :underline)
(hi   markdownCode bg=#dbd8ce)
;; Custom '@' captures used in after/queries/*
(link "@text.title1" :markdownH1)
(link "@text.title2" :markdownH2)

;; (hi TSError fg=none bg=#dda296)
(link "@constant.builtin" :Constant)
(hi "@function" fg=Black :bold)
(hi "@function.call" fg=Blue3)
(link "@keyword.operator":PreProc)
(link "@keyword.return"  :PreProc)
;; (link "@repeat"          :PreProc)
;; (link "@conditional"     :PreProc)
(link :TSURI          :markdownUrl)
(link :TSLiteral      :markdownCode)