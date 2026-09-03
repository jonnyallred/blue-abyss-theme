# Changelog

## v9 — Worlds
Colour alone told you the room had changed, not which room you were in. v9
adds identity and law on top of the v1–v8 colour work.

**Added**
- World masthead on category pages (`discovery-above`).
- Sticky identity bar on topic pages (`topic-above-post-stream`).
- "Worlds" sidebar section — every top-level category, fixed order, real icons.
- Floating Rules button and overlay; Overton window widget; `g r` shortcut.
- One-line rule reminder above the composer (`composer-open`).
- Draft charters for all eleven worlds in `lib/rules.js`, plus a JSON override
  theme setting for editing without a deploy.
- Three display tiers (academic serif, civic grotesque, the Abyss's own) plus
  monospace for Meta and Staff. Commons is set in the site face on purpose.
- Ten CSS-gradient motifs, one per world. No image assets.

**Changed**
- Marks are read from the category itself, with `worlds.js` as the fallback,
  so an icon changed in a category's Style tab propagates to the masthead,
  identity bar, overlay and sidebar at once and the two can never drift.
- Colours re-allocated around the wheel: no two worlds within 30 degrees.
  Politics (Conventional) → institutional navy; Politics (Critical) →
  vermilion; Philosophy → violet; International Affairs → cobalt. The three
  purples and three blues are gone.
- The Abyss is now **one** colour across all its rooms, as it was in the old
  forum. v4's per-room hues are retired.
- Commons unchanged in principle: one colour, 22 rooms.
- Meta and Staff are deliberately colourless — graphite and monospace.
- Per-room selectors replaced by `[class*="category-<slug>"]`, so new
  subcategories need no CSS.

**Removed**
- `--header_background`. Horizon paints `.d-header` from an html-scoped
  `--background-color` and has never read it (found in v8, kept then as
  harmless dead code). The masthead does that job now.

## v1–v8
Per-category accents and background wash. See the header comment in
`common/common.scss` for the full history — the v3, v7 and v8 findings are
still load-bearing and are documented there.
