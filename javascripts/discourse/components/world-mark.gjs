import Component from "@glimmer/component";

/**
 * A world's mark. Renders the Font Awesome glyph Discourse already ships in
 * its SVG sprite, referenced the same way core's own icon helper does.
 * Every glyph used here is registered by the `world_icons` theme setting —
 * Discourse adds the values of any setting whose name contains "_icon" to the
 * sprite, which is why that setting exists.
 */
export default class WorldMark extends Component {
  get href() {
    return `#${this.args.icon || "circle"}`;
  }

  <template>
    <svg
      class="ba-mark"
      xmlns="http://www.w3.org/2000/svg"
      aria-hidden="true"
      focusable="false"
    ><use href={{this.href}} /></svg>
  </template>
}
