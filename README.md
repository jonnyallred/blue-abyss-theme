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

## Rolling it out

Two stages, deliberately. **Identity ships first** — masthead, identity bar,
switcher, colours, type. The law ships second, once the charters are the
forum's rather than a draft, because the moment the Rules button is on, that
text reads to members as law.

So `enable_rules_button`, `enable_composer_nudge` and `auto_open_rules` all
default to **off**. Turn them on in that order, and turn `auto_open_rules` on
last — its "seen" flag burns on first sight, so whatever a member meets first
is what they have met. (Bumping `RULES_VERSION` in `lib/rules.js` does re-show
every world to everyone, which is the escape hatch.)

Rollback needs no git: a theme component is attached to Horizon in the admin
UI, and detaching it removes everything instantly.

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
| ✅ **Icons and colours** | all eleven categories are on **Icon** style with their v9 colours — done 3 Sep 2026. |
| ✅ **Order** | `fixed_category_positions` on. |
| ✅ **Light mode** | `interface_color_selector` set to `sidebar_footer`. |
| ⬜ **Uncategorized** | `allow_uncategorized_topics` is still on. A topic in no world has no rules. |

The icons the site actually carries are `brain`, `hands-praying`, `earth-americas`,
`landmark`, `bullhorn`, `gavel`, `chart-line`, `user-group`, `water`, `sliders`,
`shield-halved`. Change one in a category's Style tab and it propagates
everywhere — the theme prefers the live icon over its own fallback.

### If you ever want scales on Law

A gavel is a judge's tool; the scales are the law's. But **the category icon
picker only offers icons already in the site's SVG sprite** — it queries
`/svg-sprite/picker-search?only_available=true` — and `scale-balanced` is not
in it, so searching the picker finds nothing however you spell it. The glyph
is on the server; it just has not been requested.

To get it: **Admin → Settings → `svg_icon_subset`**, append `|scale-balanced`,
save, reload. The picker will then offer it and Law can switch. The same is
true of any Font Awesome glyph this site has not used before.

(This theme's `world_icons` setting registers marks the same way — that is how
`book-open`, the Rules glyph, gets into the sprite on install.)

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
