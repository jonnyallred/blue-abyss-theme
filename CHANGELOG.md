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

## v9.4 — two bugs live testing found

**Fixed: the identity bar never appeared where it matters.** It was mounted at
`topic-above-post-stream`, and core wraps that outlet in
`{{#unless @controller.shouldHideScrollableContentAbove}}`. Deep-link into the
middle of a topic — `/t/coronavirus/1802/1512` — and it does not render at
all, which is precisely the case the bar exists for. The bar and the rules
launcher now mount from the global `above-main-container` outlet and resolve
the world from the body class (`lib/current-world.js`), which is present on
every route. The bar is fixed rather than sticky and ships its own in-flow
spacer, so nothing else needs padding.

**Fixed: `interface_color_selector` re-armed the v8 invisible-text bug.**
Choosing Light or Dark flips the two palette stylesheets' `media` attributes to
`all` / `none` and stamps nothing on the document, so a member on a dark OS who
picks Light got Royal Light's palette while every
`@media (prefers-color-scheme: dark)` rule in this file still matched — dark
wash under dark text. Every mode-dependent value is now a single
`light-dark(light, dark)` pair, which resolves against the palette actually
applied. Correct under the OS setting and under the toggle, and 12% less CSS.

**Also**
- Masthead blurb: entities decoded (`Technology &amp; Internet Culture`), first
  sentence only, falling back to `worlds.js` for the four categories with no
  description. Category descriptions here carry admin notes members don't need.
- Rooms in the masthead come from the world, not the current category, so
  standing in Commons › Science you can step sideways into Literature.
- The Rules buttons in the masthead and identity bar are gated on
  `enable_rules_button` — they were rendering, and doing nothing, with the law
  switched off.
- Identity bar trimmed from 53px to 36px.

## v9.5 — the deep-link bar, actually fixed

v9.4 moved the identity bar to a global outlet, which was necessary but not
sufficient: it still did not appear on `/t/coronavirus/1802/1512`, while
working perfectly at the top of the same topic.

The second half of the bug was ordering. Discourse writes the `category-…`
body class **after** `page:changed` fires, so on a cold load straight to a
deep link the one resolve attempt ran against a body that did not yet name the
category — and nothing ever re-ran it. In-app navigation happened to work
because the class from the previous page was still there to correct on the
next event.

Resolution is now driven by a `MutationObserver` on the body's class
attribute: whenever the class lands, we see it. "Am I on a topic?" moved to
the same read (`archetype-*` is on the body for topic routes and nothing
else), so the router is no longer consulted and there is one source of truth
instead of two that could disagree.
