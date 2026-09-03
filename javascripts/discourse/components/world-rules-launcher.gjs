import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { currentWorld } from "../lib/current-world";
import { clearLauncher, registerLauncher } from "../lib/rules-bus";
import { rulesFor } from "../lib/rules";
import { worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";
import WorldRulesModal from "./world-rules-modal";

/**
 * The floating Rules button, and the overlay it owns.
 *
 * Mounted once from the global `above-main-container` outlet and positioned
 * fixed, so it is present on every route a world covers — including a deep
 * link into the middle of a megathread, where the topic-page outlets do not
 * render at all (see lib/current-world.js). On pages with no world it renders
 * nothing.
 */
export default class WorldRulesLauncher extends Component {
  @tracked isOpen = false;

  constructor() {
    super(...arguments);
    const self = this;
    this._ctx = {
      open: () => self.open(),
      get slug() {
        return self.world?.slug || null;
      },
    };
    registerLauncher(this._ctx);
    this._onKeydown = (event) => {
      if (event.key === "Escape" && this.isOpen) {
        event.stopPropagation();
        this.close();
      }
    };
  }

  willDestroy() {
    super.willDestroy(...arguments);
    clearLauncher(this._ctx);
    document.removeEventListener("keydown", this._onKeydown, true);
  }

  get category() {
    return this.args.category ?? currentWorld.category;
  }

  get world() {
    return worldForCategory(this.category);
  }

  get rules() {
    const world = this.world;
    if (!world) {
      return null;
    }
    return rulesFor(
      world.slug,
      typeof settings === "undefined" ? null : settings.rules_override
    );
  }

  @action
  open() {
    if (!this.rules) {
      return;
    }
    this.isOpen = true;
    document.addEventListener("keydown", this._onKeydown, true);
    requestAnimationFrame(() =>
      document.querySelector(".ba-rules-modal")?.focus()
    );
  }

  @action
  close() {
    this.isOpen = false;
    document.removeEventListener("keydown", this._onKeydown, true);
  }

  @action
  toggle() {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  <template>
    {{#if this.rules}}
      <button
        type="button"
        class="ba-fab"
        title="Rules of this world (g then r)"
        {{on "click" this.toggle}}
      >
        <WorldMark @icon="book-open" />
        <span class="ba-fab__label">Rules</span>
      </button>

      {{#if this.isOpen}}
        <WorldRulesModal
          @world={{this.world}}
          @rules={{this.rules}}
          @category={{this.category}}
          @onClose={{this.close}}
        />
      {{/if}}
    {{/if}}
  </template>
}
