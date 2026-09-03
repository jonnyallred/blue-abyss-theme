/**
 * "Once per world, per member."
 *
 * Discourse gives theme components no server-side per-user storage, so this is
 * localStorage keyed by member id, world slug and rules version. The practical
 * consequence: a member who signs in on a second device sees each world's
 * rules once more there. That is the honest limit of a theme component — the
 * alternative is a plugin with a user custom field. Bumping RULES_VERSION
 * re-shows every world to everyone, on purpose.
 */
const KEY = "blue-abyss:rules-seen";

function read() {
  try {
    return JSON.parse(window.localStorage.getItem(KEY) || "{}");
  } catch {
    return {};
  }
}

function token(userId, slug, version) {
  return `${userId || "anon"}:${slug}:${version}`;
}

export function hasSeen(userId, slug, version) {
  return read()[token(userId, slug, version)] === true;
}

export function markSeen(userId, slug, version) {
  try {
    const all = read();
    all[token(userId, slug, version)] = true;
    window.localStorage.setItem(KEY, JSON.stringify(all));
  } catch {
    // Private browsing, storage disabled, quota — never load-bearing.
  }
}
