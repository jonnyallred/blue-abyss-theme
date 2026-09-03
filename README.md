# Blue Abyss — Worlds

A Discourse **theme component**, sitting on top of Horizon, that turns each
top-level category into a *world*: a place with its own mark, colour,
typeface and posted rules, rather than a filter on one undifferentiated feed.

v1–v8 of this repo coloured the categories. v9 adds the three things colour
alone could never do.

---

## What it adds

**A masthead.** At the top of every category page: the world's mark in a
coloured medallion, its name set in the world's own typeface, its remit, its
live topic and post counts, and its rooms. It does not reimplement *New Topic*
or *Following* — those are core controls and they stay where they are.

**A sticky identity bar.** On topic pages, the masthead collapses to a 34px
bar pinned under the header: mark, world, room, Rules. This is the piece that
has to hold at reply 3,000 of a megathread, which is most of Politics
(Conventional).

**A switcher.** A *Worlds* section in the sidebar listing every top-level
category in a fixed order, each with the icon and colour it already carries.
Discourse's own *Categories* section is left alone unless you turn on
`hide_default_categories_section`.

**The law.** A floating **Rules** button that follows you through a world and
opens an overlay with three zones, in the same order every time:

1. **The window** — the world's Overton window, drawn as a window: an axis
   with the permitted band or bands lit and everything outside hatched out.
   Axis, poles and the number of bands are per-world, which is how Politics
   (Critical) states its whole editorial position in one picture — two bands,
   dark centre, "the centre is already well covered".
2. **Protocols** — numbered mechanics of discussion.
3. **Tone** — how to behave, as opposed to what may be said.

It opens by itself the first time a member enters each world, once. `g` then
`r` opens it from the keyboard. And a one-line version sits above the composer
every time anyone writes — the highest-leverage placement in the design,
because it arrives at the moment of writing rather than on a landing page
somebody saw once.

---

## Install / update

Already installed as a remote theme from this repo:
**Admin → Customize → Themes → Blue Abyss → Check for updates**.

Fresh install: **Install → From a git repository →**
`https://github.com/jonnyallred/blue-abyss-theme.git`, then add it as a
component of Horizon.

Roll back: every release is tagged. Point the remote theme at a tag, or
`git revert` and update.

---

## Before it looks right — the admin checklist

None of this is code, and all of it matters:

| | |
|---|---|
| **International Affairs** | has no icon and still uses the plain Square style. Set style **Icon**, icon `earth-americas`. |
| **BlueAbyss** | icon is `square-full`, a placeholder. Set `water`. |
| **Law** | `gavel` → `scale-balanced` (a gavel is a judge's; scales are the law's). |
| **Commons** | `globe` → `people-group` (a globe already belongs to International Affairs). |
| **Meta / Staff** | style **Icon**, `sliders` and `shield-halved`. |
| **Colours** | set each category's colour to the hex in `javascripts/discourse/lib/worlds.js`. The SCSS does not read them, but the sidebar, category badges and Discourse's own chrome do. |
| **Order** | turn on `fixed_category_positions` and order the worlds deliberately. |
| **Uncategorized** | turn off `allow_uncategorized_topics`. A topic in no world has no rules. |
| **Light mode** | set `interface_color_selector` to something other than `disabled`, so members can choose and both palettes are testable. |

---

## Editing the rules

The drafts live in `javascripts/discourse/lib/rules.js` — versioned, reviewable,
diffable, and **written to be argued with rather than adopted**.

To change a rule *now*, without a deploy, use the **rules override** theme
setting: JSON keyed by category slug, merged over the committed defaults.

```json
{
  "mainstream-politics": {
    "short": "The op-ed test",
    "standard": "If the <em>Times</em> would run it as an op-ed, it is in window."
  }
}
```

Invalid JSON is ignored and logged. Once you are happy with a change, move it
into `rules.js` and clear the override, so the history lives in git.

Bump `RULES_VERSION` in `rules.js` when the text changes materially: every
member is then shown each world's rules once more.

---

## Design notes, and the reasons behind them

**Zero imports from `discourse/components/*` or `discourse/ui-kit/*`.**
Discourse moved its component namespace mid-2026 (`DModal` now lives at
`discourse/ui-kit/d-modal`), and theme components that imported the old paths
broke. Everything here is built from `@glimmer/component`, `@ember/*` and
`discourse/lib/api` only. The rules overlay is hand-rolled rather than built
on `DModal` for exactly this reason — including its Escape handling,
scrim-click and focus management.

**No raw HTML rendering.** Rule copy may contain `<b>` and `<em>`. Rather
than reach for whichever of `htmlSafe` / `trustHTML` the running Discourse
exports this month — and open an injection surface on admin-editable text —
`lib/text.js` parses those two tags into plain segments the template renders.

**One selector per world, not one per room.** Discourse renders
`category-<slug>` for a top-level category and `category-<parent>-<child>` for
a subcategory. `[class*="category-<slug>"]` catches a world and every room
inside it, so Commons' 22 rooms and the Abyss's 18 need no CSS, and neither
will the next one.

**Motifs are CSS gradients.** No image files to upload, host, or keep in sync
— and no per-category asset for you to maintain as the forum grows.

**Marks come from Discourse's own sprite.** The `world_icons` setting exists
because Discourse adds the value of any theme setting whose name contains
`_icon` to the site's SVG sprite. That is the supported way for a theme to
ship glyphs. Keep it in sync with `worlds.js`.

**Three traps from this repo's own history, still respected.**
`--d-content-background` stays a flat colour (v7: Horizon feeds it to
`background-color` in a dozen places, where a gradient computes to
transparent). Every surface value lives inside a `prefers-color-scheme` block
(v8: an unconditional dark literal renders dark-on-dark under Royal Light).
`--header_background` is gone rather than left as dead code — Horizon never
reads it, and the masthead does that job now, visibly.

---

## Known limits

**"Once per world, per member" is stored in the browser.** Discourse gives
theme components no server-side per-user storage, so a member signing in on a
second device sees each world's rules once more there. The alternative is a
plugin with a user custom field. Turn the behaviour off entirely with
`auto_open_rules`.

**Two outlets to verify on upgrade.** `composer-open` and
`topic-above-post-stream` are long-standing but are the most likely names to
move. If either disappears, that feature quietly stops rendering — it does not
break the site.

**Topic-title typography is a broad selector.** The tier fonts are applied to
`.topic-list-item .title`, `.raw-topic-link` and `.fancy-title`. If a future
Horizon release renames those, titles fall back to the site face — visible,
not broken.
