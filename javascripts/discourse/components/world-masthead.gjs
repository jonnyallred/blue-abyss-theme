import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { blurbFor } from "../lib/blurb";
import { currentWorld } from "../lib/current-world";
import { openRules } from "../lib/rules-bus";
import { markFor, roomFor, worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * The banner at the top of a world. Medallion, name in the world's typeface,
 * remit, live counts, its rooms, and the way into the rules.
 *
 * Deliberately does NOT reimplement "New Topic" or "Following" — those are
 * core controls that live in the list header and stay there. The masthead
 * adds identity, not duplicates.
 */
export default class WorldMasthead extends Component {
  get world() {
    return worldForCategory(this.args.category);
  }

  get room() {
    return roomFor(this.args.category);
  }

  /** The category's own icon wins; worlds.js is only the fallback. */
  get mark() {
    return markFor(this.args.category);
  }

  get blurb() {
    return blurbFor(this.args.category, this.world);
  }

  get showRules() {
    return typeof settings === "undefined"
      ? true
      : settings.enable_rules_button;
  }

  /** Containers (Commons, the Abyss) hold no topics of their own — sum the rooms. */
  get counts() {
    const c = this.args.category;
    if (!c) {
      return null;
    }
    const kids = c.subcategories || [];
    const topics =
      (c.topic_count || 0) +
      kids.reduce((n, k) => n + (k.topic_count || 0), 0);
    const posts =
      (c.post_count || 0) + kids.reduce((n, k) => n + (k.post_count || 0), 0);
    return {
      topics: topics.toLocaleString(),
      posts: posts.toLocaleString(),
      rooms: kids.length,
    };
  }

  /**
   * The world's rooms, not this category's — so standing in Commons > Science
   * you can still step sideways into Literature. A room has no children of
   * its own, so reading them off the current category showed nothing.
   */
  get rooms() {
    const top = currentWorld.topCategory || this.args.category;
    return top?.subcategories || [];
  }

  <template>
    {{#if this.world}}
      <div
        class="ba-masthead ba-tier--{{this.world.tier}} ba-motif--{{this.world.motif}}"
      >
        <span class="ba-medallion"><WorldMark @icon={{this.mark}} /></span>

        <div class="ba-masthead__body">
          <div class="ba-kicker">
            World
            {{#if this.room}}<span class="ba-kicker__room">&rsaquo;
                {{this.room}}</span>{{/if}}
          </div>
          <h1 class="ba-masthead__name">{{this.world.name}}</h1>
          {{#if this.blurb}}
            <p class="ba-masthead__blurb">{{this.blurb}}</p>
          {{/if}}
          {{#if this.counts}}
            <div class="ba-stats">
              <span><b>{{this.counts.topics}}</b> topics</span>
              <span><b>{{this.counts.posts}}</b> posts</span>
              {{#if this.counts.rooms}}
                <span><b>{{this.counts.rooms}}</b> rooms</span>
              {{/if}}
            </div>
          {{/if}}
        </div>

        {{#if this.showRules}}
          <div class="ba-masthead__actions">
            <button type="button" class="ba-btn" {{on "click" openRules}}>
              <WorldMark @icon="book-open" />
              Rules
            </button>
          </div>
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
