import { tracked } from "@glimmer/tracking";
import { worldForSlug } from "./worlds";

/**
 * Where am I? — resolved from the body class, not from a route's outlet args.
 *
 * WHY (found in live testing, v9.4): the identity bar was mounted at
 * `topic-above-post-stream`, and core wraps that outlet in
 * `{{#unless @controller.shouldHideScrollableContentAbove}}`. Deep-link into
 * the middle of a topic — /t/coronavirus/1802/1512 — and the outlet does not
 * render at all. Which is precisely the case the bar exists for: the whole
 * point is knowing which world you are in at reply 1,512.
 *
 * So the world is resolved from `document.body`, which carries
 * `category-<slug>` (top level) or `category-<parent>-<child>` (a room) on
 * every route, deep links included, and the components mount from the global
 * `above-main-container` outlet. Longest token wins, so a room beats its
 * world. Uncategorized and anything not in worlds.js resolve to null, which
 * is the signal to draw nothing.
 *
 * "Am I on a topic?" comes from the same read — `archetype-regular` and
 * friends are on the body for topic routes and nothing else. v9.4 asked the
 * router instead, which was the second half of the deep-link bug: on a cold
 * load straight to /t/<slug>/<id>/1512 the body class is written AFTER
 * `page:changed` fires, so the one resolve attempt ran against a body that
 * did not name the category yet, and nothing ever re-ran it. Reading both
 * facts from one source, driven by a MutationObserver on the class attribute,
 * removes the ordering question entirely.
 */
class WorldState {
  @tracked category = null; // the exact category, room or world
  @tracked parent = null; // its world's category, when in a room
  @tracked world = null; // the worlds.js entry
  @tracked isTopic = false;

  /** The top-level category — for the mark, the rooms, the counts. */
  get topCategory() {
    return this.parent || this.category;
  }

  /** The room's name, or null at the top level. */
  get room() {
    return this.parent ? this.category?.name : null;
  }
}

export const currentWorld = new WorldState();

export function resolveCurrentWorld(site) {
  const classes = document.body.classList;
  const categories = site?.categories || [];
  const byId = new Map(categories.map((c) => [c.id, c]));

  let best = null;
  for (const category of categories) {
    const parent = category.parent_category_id
      ? byId.get(category.parent_category_id)
      : null;
    const token = parent
      ? `category-${parent.slug}-${category.slug}`
      : `category-${category.slug}`;
    if (
      classes.contains(token) &&
      (!best || token.length > best.token.length)
    ) {
      best = { token, category, parent };
    }
  }

  currentWorld.category = best?.category ?? null;
  currentWorld.parent = best?.parent ?? null;
  currentWorld.world = best
    ? worldForSlug((best.parent || best.category).slug)
    : null;
  currentWorld.isTopic = Array.prototype.some.call(classes, (c) =>
    c.startsWith("archetype-")
  );
}
