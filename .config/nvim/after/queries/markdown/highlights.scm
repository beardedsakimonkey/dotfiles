;; nvim-treesitter's capture groups only include @text.title for titles, so we
;; make custom capture groups to highlight different level headings differently.
[
 (setext_heading (setext_h1_underline))
] @text.title1

[
 (setext_heading (setext_h2_underline))
] @text.title2

;; italics blockquote
(block_quote) @text.emphasis
