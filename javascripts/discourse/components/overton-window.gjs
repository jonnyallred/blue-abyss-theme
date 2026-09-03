import Component from "@glimmer/component";
import { segments } from "../lib/text";

/**
 * The Overton window, drawn as a window: an axis with the permitted band or
 * bands lit and everything outside them hatched out. Axis, poles and the
 * number of bands are per-world configuration, which is what lets Politics
 * (Critical) say "two bands, dark centre" — a thing prose struggles with.
 */
export default class OvertonWindow extends Component {
  get bands() {
    return (this.args.rules?.windows || []).map(([start, end]) => ({
      start,
      width: Math.max(0, end - start),
    }));
  }

  get standard() {
    return segments(this.args.rules?.standard);
  }

  get axis() {
    const a = this.args.rules?.axis || [];
    return a[0] || a[1] ? { left: a[0], right: a[1] } : null;
  }

  <template>
    <div class="ba-ov">
      <p class="ba-ov__standard">
        {{#each this.standard as |seg|}}
          {{#if seg.bold}}<b>{{seg.text}}</b>
          {{else if seg.italic}}<em>{{seg.text}}</em>
          {{else}}{{seg.text}}{{/if}}
        {{/each}}
      </p>

      <div class="ba-ov__track">
        {{#each this.bands as |band|}}
          <span
            class="ba-ov__band"
            style="left:{{band.start}}%;width:{{band.width}}%"
          ></span>
        {{/each}}
      </div>

      {{#if this.axis}}
        <div class="ba-ov__axis">
          <span>{{this.axis.left}}</span>
          <span>{{this.axis.right}}</span>
        </div>
      {{/if}}
    </div>
  </template>
}
