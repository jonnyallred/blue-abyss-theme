/**
 * Blue Abyss — Worlds
 * ---------------------------------------------------------------------------
 * SINGLE SOURCE OF TRUTH. One entry per top-level category ("world").
 * Everything the theme draws — accent, mark, typeface tier, header, rules
 * overlay — is generated from this file. Adding a twelfth world means adding
 * a twelfth entry here and one line in common.scss.
 *
 * v9.7 dropped the per-world background motifs. They were a texture layer
 * under the masthead, and once the masthead went there was nothing left for
 * them to sit on. They are in git if a future front-door design wants them.
 *
 * `slug`    must match the category's Discourse slug exactly.
 * `hue`     is the OKLCH hue used by common.scss. Kept >= 30 degrees from
 *           every other world so no two rooms read as the same colour.
 * `icon`    a Font Awesome mark, used only as a FALLBACK. The theme prefers
 *           whatever icon the category itself carries in its Style tab, so
 *           changing an icon in admin propagates everywhere with no deploy
 *           and the two can never drift apart. Keep these in step anyway —
 *           they are what renders if a category's style is set back to Square.
 * `tier`    picks the display typeface (see common.scss $tiers).
 * `recipe`  "light" = bright surface with a mid-tone accent (most worlds)
 *           "abyss" = deeper surface, brighter glow (the Abyss only)
 *           "system" = greyscale, monospace (Meta and Staff)
 */

export const WORLDS = [
  {
    slug: "philosophy",
    name: "Philosophy",
    icon: "brain",
    hue: 285,
    hex: "#6D4FBF",
    tier: "academic",
    recipe: "light",
    blurb:
      "Epistemology, ethics, philosophy of mind and science, logic, aesthetics — and the philosophers themselves.",
  },
  {
    slug: "religious-studies",
    name: "Religious Studies",
    icon: "hands-praying",
    hue: 325,
    hex: "#9C5EAA",
    tier: "academic",
    recipe: "light",
    blurb:
      "Geeking out about religion — text, history, doctrine and practice, from inside and outside.",
  },
  {
    slug: "international-politics",
    name: "International Affairs",
    icon: "earth-americas",
    hue: 255,
    hex: "#3A6BD0",
    tier: "civic",
    recipe: "light",
    blurb: "States, wars, treaties, and the order between them.",
  },
  {
    slug: "mainstream-politics",
    name: "Politics (Conventional)",
    icon: "landmark",
    hue: 250,
    chroma: 0.08,
    lightness: 52,
    hex: "#2B4C7E",
    tier: "civic",
    recipe: "light",
    blurb:
      "American politics as the mainstream argues it — elections, institutions, the news cycle.",
  },
  {
    slug: "politics-critical",
    name: "Politics (Critical)",
    icon: "bullhorn",
    hue: 35,
    chroma: 0.18,
    hex: "#D9481F",
    tier: "civic",
    recipe: "light",
    blurb: "Where the mainstream frame is the thing under examination.",
  },
  {
    slug: "law",
    name: "Law",
    icon: "gavel",
    hue: 75,
    chroma: 0.13,
    hex: "#A87024",
    tier: "academic",
    recipe: "light",
    blurb: "Jurisprudence, doctrine, case-law analysis and legal philosophy.",
  },
  {
    slug: "economics",
    name: "Economics",
    icon: "chart-line",
    hue: 160,
    hex: "#0F9A6B",
    tier: "academic",
    recipe: "light",
    blurb:
      "Theory, economic history, monetary policy, behavioural economics.",
  },
  {
    slug: "commons",
    name: "Commons",
    icon: "user-group",
    hue: 200,
    chroma: 0.12,
    hex: "#1C989E",
    tier: "commons",
    recipe: "light",
    unified: true,
    blurb:
      "Everything else — books, games, science, tech, food, film, and the odd forecast. Casual, low stakes, come as you are.",
  },
  {
    slug: "blue-abyss",
    name: "BlueAbyss",
    icon: "water",
    hue: 205,
    chroma: 0.15,
    lightness: 70,
    hex: "#37D0E8",
    tier: "abyss",
    recipe: "abyss",
    unified: true,
    blurb:
      "The original forum. Years of threads too personal, too raw or too particular to hand to an audience we haven't met yet.",
  },
  {
    slug: "meta",
    name: "Meta",
    icon: "sliders",
    hue: 250,
    chroma: 0.012,
    hex: "#5C6672",
    tier: "system",
    recipe: "system",
    unified: true,
    blurb:
      "The forum talking about itself — announcements, structure, and jankiness worth fixing.",
  },
  {
    slug: "staff",
    name: "Staff",
    icon: "shield-halved",
    hue: 80,
    chroma: 0.03,
    hex: "#7A6A46",
    tier: "system",
    recipe: "system",
    blurb: "Moderator working room. Not listed for members.",
  },
];

const BY_SLUG = new Map(WORLDS.map((w) => [w.slug, w]));

export function worldForSlug(slug) {
  return BY_SLUG.get(slug) || null;
}

/**
 * Walk a category up to its top-level ancestor and return that world.
 * Returns null for Uncategorized and anything not listed above, which is the
 * signal for "draw nothing" — the theme never guesses.
 */
export function worldForCategory(category) {
  let c = category;
  let guard = 0;
  while (c && c.parentCategory && guard++ < 8) {
    c = c.parentCategory;
  }
  return c ? worldForSlug(c.slug) : null;
}

/** The top-level Category object a category belongs to. */
export function topCategoryFor(category) {
  let c = category;
  let guard = 0;
  while (c && c.parentCategory && guard++ < 8) {
    c = c.parentCategory;
  }
  return c || null;
}

/**
 * The mark to draw. The live category icon wins over the fallback in this
 * file, so an icon changed in Admin > Category > Style shows up in the
 * masthead, the identity bar, the overlay and the sidebar at once. Discourse
 * registers category icons in its SVG sprite automatically; the `world_icons`
 * theme setting covers the fallbacks and the Rules glyph, which it does not.
 */
export function markFor(category) {
  const top = topCategoryFor(category);
  const world = top ? worldForSlug(top.slug) : null;
  return top?.icon || world?.icon || "circle";
}

/** The room within a world — a subcategory name, or null at the top level. */
export function roomFor(category) {
  return category && category.parentCategory ? category.name : null;
}
