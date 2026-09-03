import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { openRules } from "../lib/rules-bus";
import { markFor, roomFor, worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * The world, named. One component, one line, both page types.
 *
 * On a category page it sits above the topic list; on a topic page above the
 * title, which then steps down to second voice. It replaced two separate
 * things in v9.7 — a bordered masthead panel with a gradient, a texture, a
 * description and counts, and a fixed translucent bar — neither of which
 * earned the space. What is left is the mark, the world in its own face and
 * accent colour, and the room.
 *
 * `showRooms` adds the room chips underneath, which only category pages want:
 * on a topic page the title follows immediately.
 */
export default class WorldHeader extends Component {
  get category() {
    return this.args.category;
  }

  get world() {
    return worldForCategory(this.category);
  }

  get room() {
    return roomFor(this.category);
  }

  get mark() {
    return markFor(this.category);
  }

  /** Always the world's own page, even when standing in one of its rooms. */
  get worldUrl() {
    return this.category?.parentCategory?.url || this.category?.url;
  }

  /**
   * The world's rooms, not this category's — so in Commons › Science you can
   * still step sideways into Literature. A room has no children of its own.
   */
  get rooms() {
    if (!this.args.showRooms) {
      return [];
    }
    const top = this.category?.parentCategory || this.category;
    return top?.subcategories || [];
  }

  get showRules() {
    return typeof settings === "undefined"
      ? true
      : settings.enable_rules_button;
  }

  <template>
    {{#if this.world}}
      <div class="ba-worldhead ba-tier--{{this.world.tier}}">
        <span class="ba-worldhead__mark"><WorldMark @icon={{this.mark}} /></span>
        <a class="ba-worldhead__name" href={{this.worldUrl}}>
          {{this.world.name}}
        </a>
        {{#if this.room}}
          <a class="ba-worldhead__room" href={{this.category.url}}>
            {{this.room}}
          </a>
        {{/if}}
        {{#if this.showRules}}
          <button
            type="button"
            class="ba-worldhead__rules"
            {{on "click" openRules}}
          >
            <WorldMark @icon="book-open" />
            Rules
          </button>
        {{/if}}
      </div>

      {{#if this.rooms}}
        <div class="ba-rooms">
          {{#each this.rooms as |room|}}
            <a class="ba-room" href={{room.url}}>{{room.name}}</a>
          {{/each}}
        </div>
      {{/if}}
    {{/if}}
  </template>
}
