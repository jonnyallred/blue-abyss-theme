import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { openRules } from "../lib/rules-bus";
import { rulesFor } from "../lib/rules";
import { worldForCategory } from "../lib/worlds";
import WorldMark from "./world-mark";

/**
 * One line above the composer, naming the world and its single most important
 * rule. The highest-leverage placement in the whole design: it arrives at the
 * moment someone is about to write, not on a landing page they saw once.
 */
export default class ComposerRuleNudge extends Component {
  get world() {
    return worldForCategory(this.args.model?.category);
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

  <template>
    {{#if this.rules}}
      <div class="ba-nudge ba-tier--{{this.world.tier}}">
        <span class="ba-nudge__mark"><WorldMark @icon={{this.world.icon}} /></span>
        <span class="ba-nudge__text">
          In
          <b>{{this.world.name}}</b>
          &mdash;
          {{this.rules.short}}.
        </span>
        <span class="ba-nudge__spacer"></span>
        <button type="button" class="ba-nudge__link" {{on "click" openRules}}>
          All rules
        </button>
      </div>
    {{/if}}
  </template>
}
