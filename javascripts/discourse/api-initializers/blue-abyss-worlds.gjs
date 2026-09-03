import { apiInitializer } from "discourse/lib/api";
import ComposerRuleNudge from "../components/composer-rule-nudge";
import WorldTopicHeader from "../components/world-topic-header";
import WorldMasthead from "../components/world-masthead";
import WorldRulesLauncher from "../components/world-rules-launcher";
import { resolveCurrentWorld } from "../lib/current-world";
import { RULES_VERSION } from "../lib/rules";
import { currentWorldSlug, openRules } from "../lib/rules-bus";
import { hasSeen, markSeen } from "../lib/seen";
import { WORLDS } from "../lib/worlds";

const s = typeof settings === "undefined" ? {} : settings;

export default apiInitializer((api) => {
  const site = api.container.lookup("service:site");

  // ── Where am I ──────────────────────────────────────────────────────────
  // Driven by the body's class attribute rather than by route events, because
  // Discourse writes that class AFTER `page:changed` fires — on a cold load
  // straight to /t/<slug>/<id>/1512 a one-shot resolve runs against a body
  // that does not name the category yet, and nothing re-runs it. Watching the
  // attribute removes the ordering question: whenever the class lands, we see
  // it. The read is a loop over the category list and sets tracked values
  // only, so it cannot loop back on itself.
  const refresh = () => resolveCurrentWorld(site);
  new MutationObserver(refresh).observe(document.body, {
    attributes: true,
    attributeFilter: ["class"],
  });
  api.onPageChange(refresh);
  refresh();

  // ── Identity ────────────────────────────────────────────────────────────
  // `discovery-above` hands us the category on every list page (and null on
  // /latest, /new and friends, where the components render nothing).
  if (s.enable_masthead !== false) {
    api.renderInOutlet(
      "discovery-above",
      <template>
        <WorldMasthead @category={{@outletArgs.category}} />
      </template>
    );
  }

  // The world header sits with the topic title, at the same outlet the title
  // itself renders from — so the two appear together or not at all.
  if (s.enable_identity_bar !== false) {
    api.renderInOutlet(
      "topic-above-post-stream",
      <template>
        <WorldTopicHeader @topic={{@outletArgs.model}} />
      </template>
    );
  }

  // ── The law ─────────────────────────────────────────────────────────────
  // Mounted once, globally, position:fixed — same reason as the identity bar.
  if (s.enable_rules_button !== false) {
    api.renderInOutlet("above-main-container", WorldRulesLauncher);
  }

  if (s.enable_composer_nudge !== false) {
    api.renderInOutlet(
      "composer-open",
      <template>
        <ComposerRuleNudge @model={{@outletArgs.model}} />
      </template>
    );
  }

  // `g` then `r`, alongside Discourse's own g-prefixed navigation shortcuts.
  api.addKeyboardShortcut("g r", () => openRules());

  // ── Once per world, per member ──────────────────────────────────────────
  if (s.auto_open_rules !== false) {
    api.onPageChange(() => {
      // Give the launcher a frame to mount and register itself.
      window.setTimeout(() => {
        const slug = currentWorldSlug();
        if (!slug) {
          return;
        }
        const userId = api.getCurrentUser()?.id;
        if (hasSeen(userId, slug, RULES_VERSION)) {
          return;
        }
        markSeen(userId, slug, RULES_VERSION);
        openRules();
      }, 150);
    });
  }

  // ── The switcher ────────────────────────────────────────────────────────
  // The eleven worlds, always in the same order, with the mark and colour each
  // category already carries. Discourse's own "Categories" section is left
  // alone unless `hide_default_categories_section` is on.
  api.addSidebarSection((BaseCustomSidebarSection, BaseCustomSidebarSectionLink) => {
    return class WorldsSection extends BaseCustomSidebarSection {
      get name() {
        return "blue-abyss-worlds";
      }

      get text() {
        return s.switcher_heading || "Worlds";
      }

      get title() {
        return s.switcher_heading || "Worlds";
      }

      get links() {
        const categories = site?.categories || [];
        return WORLDS.map((world) => {
          const category = categories.find(
            (c) => c.slug === world.slug && !c.parent_category_id
          );
          if (!category) {
            return null;
          }
          return new (class extends BaseCustomSidebarSectionLink {
            get name() {
              return `world-${world.slug}`;
            }
            get href() {
              return category.url;
            }
            get title() {
              return world.blurb;
            }
            get text() {
              return world.name;
            }
            get prefixType() {
              return category.icon ? "icon" : "span";
            }
            get prefixValue() {
              return category.icon || undefined;
            }
            get prefixColor() {
              return world.hex.replace("#", "");
            }
            get classNames() {
              return `ba-world-link ba-world-link--${world.slug}`;
            }
          })();
        }).filter(Boolean);
      }
    };
  });
});
