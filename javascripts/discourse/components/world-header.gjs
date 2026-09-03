import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { blurbFor } from "../lib/blurb";
import { openRules } from "../lib/rules-bus";
import { markFor, roomFor, worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * The world, named. One component, two densities.
 *
 * `@full` — category pages. The world is the whole reason the page exists, so
 * it gets the room to say so: mark in a medallion, the world at 2.35rem, its
 * remit, its live counts, and its rooms, closed with a hairline before the
 * list starts. Flat throughout — the gradient and texture that made the old
 * masthead read as an overlay are not coming back.
 *
 * Otherwise — topic pages. One line above the title, which then steps down to
 * second voice.
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

  get blurb() {
    return blurbFor(this.category, this.world);
  }

  /** Always the world's own page, even when standing in one of its rooms. */
  get worldUrl() {
    return this.category?.parentCategory?.url || this.category?.url;
  }

  /** Containers hold no topics of their own — sum the rooms. */
  get counts() {
    const c = this.category;
    if (!c) {
      return null;
    }
    const kids = c.subcategories || [];
    const topics =
      (c.topic_count || 0) + kids.reduce((n, k) => n + (k.topic_count || 0), 0);
    const posts =
      (c.post_count || 0) + kids.reduce((n, k) => n + (k.post_count || 0), 0);
    return {
      topics: topics.toLocaleString(),
      posts: posts.toLocaleString(),
      rooms: kids.length,
    };
  }

  /**
   * The world's rooms, not this category's — so in Commons › Science you can
   * still step sideways into Literature. A room has no children of its own.
   */
  get rooms() {
    if (!this.args.full) {
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
      {{#if @full}}
        <div class="ba-worldblock">
          <div class="ba-worldhead ba-worldhead--full ba-tier--{{this.world.tier}}">
            <span class="ba-worldhead__medallion">
              <WorldMark @icon={{this.mark}} />
            </span>

            <div class="ba-worldhead__body">
              <div class="ba-worldhead__kicker">
                World
                {{#if this.room}}
                  <span class="ba-worldhead__kicker-room">
                    &rsaquo;
                    {{this.room}}
                  </span>
                {{/if}}
              </div>

              <a class="ba-worldhead__name" href={{this.worldUrl}}>
                {{this.world.name}}
              </a>

              {{#if this.blurb}}
                <p class="ba-worldhead__blurb">{{this.blurb}}</p>
              {{/if}}

              {{#if this.counts}}
                <div class="ba-worldhead__stats">
                  <span><b>{{this.counts.topics}}</b> topics</span>
                  <span><b>{{this.counts.posts}}</b> posts</span>
                  {{#if this.counts.rooms}}
                    <span><b>{{this.counts.rooms}}</b> rooms</span>
                  {{/if}}
                </div>
              {{/if}}
            </div>

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
        </div>
      {{else}}
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
      {{/if}}
    {{/if}}
  </template>
}
