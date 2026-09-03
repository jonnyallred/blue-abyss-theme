import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { openRules } from "../lib/rules-bus";
import { markFor, roomFor, worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * The world, named above the topic title.
 *
 * Replaces v9.4's floating identity bar, which was fixed and full-width and
 * therefore sat on top of the sidebar and clipped the New Topic button — an
 * overlay smeared across the chrome rather than a piece of the page. This is
 * in flow, above the title, and inverts the native hierarchy: the world reads
 * first and large, the topic second.
 *
 * Mounted at `topic-above-post-stream`, which is exactly where `#topic-title`
 * lives — the two render together or not at all, so there is no case where a
 * title appears with no world above it. Deep links, where neither renders, are
 * covered by restyling Discourse's own sticky header instead (common.scss).
 */
export default class WorldTopicHeader extends Component {
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

  get worldUrl() {
    const c = this.category;
    return c?.parentCategory?.url || c?.url;
  }

  get showRules() {
    return typeof settings === "undefined"
      ? true
      : settings.enable_rules_button;
  }

  <template>
    {{#if this.world}}
      <div class="ba-topichead ba-tier--{{this.world.tier}}">
        <span class="ba-topichead__mark"><WorldMark @icon={{this.mark}} /></span>
        <a class="ba-topichead__name" href={{this.worldUrl}}>
          {{this.world.name}}
        </a>
        {{#if this.room}}
          <a class="ba-topichead__room" href={{this.category.url}}>
            {{this.room}}
          </a>
        {{/if}}
        {{#if this.showRules}}
          <button
            type="button"
            class="ba-topichead__rules"
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
