import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { currentWorld } from "../lib/current-world";
import { openRules } from "../lib/rules-bus";
import { markFor } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * The masthead, collapsed, on a topic page: pinned under the header, naming
 * the world you are reading in.
 *
 * Mounted from the global `above-main-container` outlet and positioned fixed,
 * because the topic-page outlets do not render on a deep link into the middle
 * of a thread — see lib/current-world.js. It ships its own in-flow spacer
 * rather than patching padding onto #main-outlet, so pages with no world (and
 * every non-topic route) are untouched.
 */
export default class WorldIdentityBar extends Component {
  get show() {
    return currentWorld.isTopic && !!currentWorld.world;
  }

  get world() {
    return currentWorld.world;
  }

  get room() {
    return currentWorld.room;
  }

  get mark() {
    return markFor(currentWorld.category);
  }

  get showRules() {
    return typeof settings === "undefined"
      ? true
      : settings.enable_rules_button;
  }

  <template>
    {{#if this.show}}
      <div class="ba-idbar-spacer"></div>
      <div class="ba-idbar ba-tier--{{this.world.tier}}">
        <span class="ba-idbar__mark"><WorldMark @icon={{this.mark}} /></span>
        <span class="ba-idbar__name">{{this.world.name}}</span>
        {{#if this.room}}
          <span class="ba-idbar__room">&rsaquo; {{this.room}}</span>
        {{/if}}
        <span class="ba-idbar__spacer"></span>
        {{#if this.showRules}}
          <button
            type="button"
            class="ba-idbar__rules"
            {{on "click" openRules}}
          >
            <WorldMark @icon="book-open" />
            Rules
          </button>
        {{/if}}
      </div>
    {{/if}}
  </template>
}
