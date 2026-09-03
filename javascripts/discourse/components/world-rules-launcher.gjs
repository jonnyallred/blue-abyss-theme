import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { clearLauncher, registerLauncher } from "../lib/rules-bus";
import { rulesFor } from "../lib/rules";
import { worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";
import WorldRulesModal from "./world-rules-modal";

/**
 * The floating Rules button, and the overlay it owns.
 *
 * Rendered from `discovery-above` (category pages) and `topic-above-post-stream`
 * (topic pages), both of which hand us a category. It is position:fixed, so it
 * sits in the same place wherever it is mounted — which is how it survives
 * reply 3,000 of a megathread. On pages with no world it renders nothing.
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

  get world() {
    return worldForCategory(this.args.category);
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
          @category={{@category}}
          @onClose={{this.close}}
        />
      {{/if}}
    {{/if}}
  </template>
}
