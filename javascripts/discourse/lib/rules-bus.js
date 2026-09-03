/**
 * A one-object bus connecting the launcher that is currently on screen to the
 * things that need it: the `g r` keyboard shortcut and the auto-open check
 * (both registered once, in the API initializer), and the Rules buttons in the
 * masthead, identity bar and composer nudge.
 *
 * A module singleton rather than an Ember service: themes resolve services
 * inconsistently across releases, and this needs no state beyond one object.
 */
let active = null;

export function registerLauncher(ctx) {
  active = ctx;
}

export function clearLauncher(ctx) {
  if (active === ctx) {
    active = null;
  }
}

/** The slug of the world currently on screen, or null. */
export function currentWorldSlug() {
  return active?.slug || null;
}

export function openRules() {
  if (active) {
    active.open();
    return true;
  }
  return false;
}
