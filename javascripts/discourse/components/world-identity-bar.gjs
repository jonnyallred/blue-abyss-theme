import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { openRules } from "../lib/rules-bus";
import { markFor, roomFor, worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * The masthead, collapsed, on a topic page: 34px, sticky under the header.
 * This is the piece that has to hold at reply 3,000 of a megathread — which
 * is most of Politics (Conventional).
 */
export default class WorldIdentityBar extends Component {
  get category() {
    return this.args.topic?.category;
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

  <template>
    {{#if this.world}}
      <div class="ba-idbar ba-tier--{{this.world.tier}}">
        <span class="ba-idbar__mark"><WorldMark @icon={{this.mark}} /></span>
        <span class="ba-idbar__name">{{this.world.name}}</span>
        {{#if this.room}}
          <span class="ba-idbar__room">&rsaquo; {{this.room}}</span>
        {{/if}}
        <span class="ba-idbar__spacer"></span>
        <button type="button" class="ba-idbar__rules" {{on "click" openRules}}>
          <WorldMark @icon="book-open" />
          Rules
        </button>
      </div>
    {{/if}}
  </template>
}
