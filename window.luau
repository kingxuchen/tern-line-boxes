-- Tern draws the composer's caption row, the bottom status line, the rows of a
-- function-call card and the slash-command list with `font: …/1` (or a line box
-- shorter than the glyphs), so descenders (g, y, p) get clipped. Loosen them
-- here: a plugin sheet, not a theme, so it holds for every theme and every chat
-- style.
--
-- The slash list (`/goal`, `/model`, …) is Tern's rendering of the agent's
-- autocomplete: `.sf-overlay[data-role='omp.autocomplete']` > `.sf-ov-body` >
-- `.sf-list` > `.sf-item` > `.sf-item-label` (the command name), `.sf-item-detail`
-- (its description), `.sf-item-value` ("off"/"on"). The chat-spine skin sets the
-- name to `font: 12.5px/1 var(--tv-font, var(--mono))`, i.e. a line box of exactly
-- 1em, and `.sf-item-label` carries `overflow: hidden` — measured live: box
-- 13.47px for a 13.46px font, while the row itself is 30.16px tall. The mono
-- descender (~0.2em, of which ~1.6px falls below the 1em box) is therefore cut.
-- 1.5 gives 20.19px, still inside the 28–30px row, so no row moves.
--
-- The block bar that fades in at the top-right of a terminal block (the command
-- it ran, "Native"/"Raw", copy) has the same problem in its command lens:
-- `.sf-block-lens` is `font: 11px/1 var(--tv-font, var(--mono))` with
-- `overflow: hidden`, and `.sf-block-lens > .lbl` clips again with
-- `overflow: hidden; text-overflow: ellipsis`. Measured live: 12.69px line box
-- for a 12.69px font (11px × the 1.15 UI scale), with "git pull" ink running
-- 68.5…80.5 against a box of 68.27…80.96 — the descender's last row sits on the
-- clip edge, so the tail of the g is cut. 1.5 gives 19.04px with ~3px of room
-- under the ink; the lens grows from 16.16px (its 14px icon) to 19.04px, still
-- inside the 27.69px bar, so the bar and its neighbours do not move.
tern.css("line-boxes", [[
#statusline,
#statusline .tn-git,
.sf-dock .sf-status :is(.sf-seg-t, .sf-text, .sf-t-accent),
.sf-dock :is(.sf-caption-name, .sf-caption-draft),
.sf-overlay[data-role='omp.autocomplete'] .sf-item-label,
.sf-block-lens,
.sf-tool :is(.sf-text, .sf-elapsed, .sf-chip, .sf-tool-title, .sf-tool-target,
              .sf-tool-meta, .sf-tool-time, .sf-t-path, .sf-t-mono, .sf-t-code) {
	line-height: 1.5 !important;
}
]])

-- The same block bar's "Native"/"Raw" pair must not change shape when the choice
-- moves. Two things made it:
--
-- 1. `.sf-block-opt` takes its text from `.sf-block-bar` (`font: inherit`, so
--    `11.5px/1`), i.e. an 11.5px line box inside a 20px button that the button
--    then centres. Pin the line box to the button's own height instead: the
--    label is centred by the line box itself and can no longer ride on whatever
--    line-height the bar (or any sheet after this one) happens to inherit.
-- 2. `.sf-block-opt.on` draws `box-shadow: 0 0 0 1px var(--l2)`, a ring painted
--    1px OUTSIDE the 20px button. The `.sf-block-seg` track is 22px with 1px
--    padding, so the ring lands exactly on the track's own edge: at the left end
--    the capsule's rounded corner merges with the track's corner, in the middle
--    it sits enclosed by the track — the same capsule reads as two different
--    sizes, and the narrower "Raw" makes it worse. Inset the ring instead: the
--    painted capsule is then exactly the 20px button inside the track, wherever
--    the choice sits. Verified live: ring rows 62/63 and 85/86 at the UI scale in
--    both the Native and the Raw state, seg track and bar unchanged at 25.39px
--    and 27.69px.
tern.css("line-boxes-block-seg", [[
.sf-block-seg .sf-block-opt {
	line-height: 20px !important;
	box-shadow: none !important;
}
.sf-block-seg .sf-block-opt.on {
	box-shadow: inset 0 0 0 1px var(--l2) !important;
}
]])