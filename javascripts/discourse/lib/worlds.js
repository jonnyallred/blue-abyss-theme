/**
 * Blue Abyss — Worlds
 * ---------------------------------------------------------------------------
 * SINGLE SOURCE OF TRUTH. One entry per top-level category ("world").
 * Everything the theme draws — accent, mark, typeface tier, background motif,
 * masthead, rules overlay — is generated from this file. Adding a twelfth
 * world means adding a twelfth entry here and one line in common.scss.
 *
 * `slug`    must match the category's Discourse slug exactly.
 * `hue`     is the OKLCH hue used by common.scss. Kept >= 30 degrees from
 *           every other world so no two rooms read as the same colour.
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
    motif: "rings",
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
    motif: "lattice",
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
    motif: "graticule",
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
    motif: "halftone",
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
    motif: "hatch",
    recipe: "light",
    blurb: "Where the mainstream frame is the thing under examination.",
  },
  {
    slug: "law",
    name: "Law",
    icon: "scale-balanced",
    hue: 75,
    chroma: 0.13,
    hex: "#A87024",
    tier: "academic",
    motif: "flutes",
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
    motif: "plot",
    recipe: "light",
    blurb:
      "Theory, economic history, monetary policy, behavioural economics.",
  },
  {
    slug: "commons",
    name: "Commons",
    icon: "people-group",
    hue: 200,
    chroma: 0.12,
    hex: "#1C989E",
    tier: "commons",
    motif: "weave",
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
    motif: "depth",
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
    motif: "blueprint",
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
    motif: "hatch",
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

/** The room within a world — a subcategory name, or null at the top level. */
export function roomFor(category) {
  return category && category.parentCategory ? category.name : null;
}
