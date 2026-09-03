import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import OvertonWindow from "./overton-window";
import WorldMark from "./world-mark";

/**
 * The rules overlay. Three zones, in the same order in every world, so a
 * member learns the shape once and reads any world's law in five seconds.
 *
 * Hand-rolled rather than built on core's DModal: this keeps the component
 * free of `discourse/components/*` and `discourse/ui-kit/*` imports, whose
 * paths have moved between releases. Focus handling, Escape and scrim-click
 * are implemented here.
 */
export default class WorldRulesModal extends Component {
  @action
  onScrimClick(event) {
    if (event.target === event.currentTarget) {
      this.args.onClose();
    }
  }

  get protocols() {
    return (this.args.rules?.protocols || []).map((text, i) => ({
      n: String(i + 1).padStart(2, "0"),
      text,
    }));
  }

  get charterUrl() {
    const c = this.args.category;
    return c?.topic_url || c?.url || null;
  }

  <template>
    <div
      class="ba-rules-scrim"
      role="presentation"
      {{on "click" this.onScrimClick}}
    >
      <div
        class="ba-rules-modal ba-motif--{{@world.motif}}"
        role="dialog"
        aria-modal="true"
        aria-labelledby="ba-rules-title"
        tabindex="-1"
      >
        <div class="ba-rules-modal__head">
          <span class="ba-medallion"><WorldMark @icon={{@world.icon}} /></span>
          <div class="ba-rules-modal__title">
            <span class="ba-kicker">Rules of this world</span>
            <span id="ba-rules-title" class="ba-rules-modal__name">
              {{@world.name}}
            </span>
          </div>
          <button
            type="button"
            class="ba-rules-modal__close"
            aria-label="Close"
            {{on "click" @onClose}}
          >&times;</button>
        </div>

        <div class="ba-rules-modal__body">
          <section class="ba-block">
            <h4>The window</h4>
            <OvertonWindow @rules={{@rules}} />
          </section>

          {{#if this.protocols}}
            <section class="ba-block">
              <h4>Protocols</h4>
              <ol class="ba-list">
                {{#each this.protocols as |item|}}
                  <li>
                    <span class="ba-list__n">{{item.n}}</span>
                    <span>{{item.text}}</span>
                  </li>
                {{/each}}
              </ol>
            </section>
          {{/if}}

          {{#if @rules.tone}}
            <section class="ba-block">
              <h4>Tone</h4>
              <ul class="ba-list ba-list--tone">
                {{#each @rules.tone as |item|}}
                  <li><span class="ba-list__n">&middot;</span><span>{{item}}</span></li>
                {{/each}}
              </ul>
            </section>
          {{/if}}
        </div>

        <div class="ba-rules-modal__foot">
          {{#if this.charterUrl}}
            <a href={{this.charterUrl}}>Full charter &rarr;</a>
          {{/if}}
          <span class="ba-rules-modal__hint">
            Shown once per world. Reopen any time with the Rules button, or
            press
            <kbd>g</kbd>
            then
            <kbd>r</kbd>.
          </span>
        </div>
      </div>
    </div>
  </template>
}
