/**
 * Blue Abyss — the law of each world.
 * ---------------------------------------------------------------------------
 * FIRST DRAFT. This text is written to show the shape and to be argued with,
 * not to be adopted as-is. Edit it here (git history, review, rollback) or
 * override any part of it live from Admin > Customize > Themes > Blue Abyss >
 * Settings > "rules override" without a deploy — see README.
 *
 * Shape of an entry:
 *   standard   one sentence. The rule of the room. HTML <b>/<em> allowed.
 *   short      four or five words. Appears above the composer.
 *   axis       [left pole, right pole]. Empty strings hide the axis labels.
 *   windows    one or more [start, end] pairs, 0-100, drawn lit on the axis.
 *   protocols  numbered mechanics of discussion.
 *   tone       unnumbered, about manner rather than content.
 */

export const RULES = {
  philosophy: {
    standard:
      "Any position is in bounds here. <b>Any position asserted without an argument is not.</b>",
    short: "Argument, not assertion",
    axis: ["Assertion", "Argument"],
    windows: [[32, 100]],
    protocols: [
      "Steelman before you strike — state the strongest version of the view you are about to reject, and get agreement that you have stated it.",
      "Define your terms once, at the top, and hold them for the rest of the thread.",
      "Bring the primary source when you invoke a philosopher. Summaries of summaries end threads.",
      "Three consecutive replies to the same person is the limit. Let a third voice in.",
    ],
    tone: [
      "Charity is the house style. Assume the strongest reading first.",
      "“You’ve changed my mind” is the highest-status thing anyone says here.",
      "Nobody is required to have a position. “I’m still working it out” is a complete contribution.",
    ],
  },

  "religious-studies": {
    standard:
      "The <b>study</b> of religion. Testimony and teardowns both sit outside the frame — the Abyss is where those belong.",
    short: "Study, not witness",
    axis: ["Devotional witness", "Debunking"],
    windows: [[24, 76]],
    protocols: [
      "Cite the text, the tradition, or the scholarship. “I heard that” is not a source.",
      "Describe a belief the way its adherents would recognise before you evaluate it.",
      "Ask before you assume anyone’s tradition, and take the answer at face value.",
      "Three consecutive replies to one person, maximum.",
    ],
    tone: [
      "Write as though a believer and a former believer are both reading. They are.",
      "Curiosity outranks conclusion here.",
    ],
  },

  "international-politics": {
    standard:
      "Positions a foreign ministry could brief. <b>US party politics belongs next door.</b>",
    short: "Foreign desk, not home desk",
    axis: ["Domestic electoral politics", "Advocacy for atrocity"],
    windows: [[19, 86]],
    protocols: [
      "Name your source’s nationality and funding when it changes the reading.",
      "Separate what happened from what should have happened, and say which one you are doing.",
      "Casualty, displacement and economic figures get a source and a date.",
      "Three replies, then let the thread breathe.",
    ],
    tone: [
      "Nobody in this room is a proxy for their government.",
      "Ongoing wars have people reading who are closer to them than you are.",
    ],
  },

  "mainstream-politics": {
    standard:
      "<b>The op-ed test.</b> If the <em>New York Times</em> would run it as an opinion piece, it is in window here. If it wouldn’t, Politics (Critical) is one click away and wants it.",
    short: "The op-ed test",
    axis: ["Left of what the Times prints", "Right of what the Times prints"],
    windows: [[31, 69]],
    protocols: [
      "Three consecutive replies to the same person, maximum. The fourth is a private message.",
      "Link the claim, not the headline — and quote the sentence you are relying on.",
      "A prediction gets a date and a resolution condition, or it is not a prediction.",
      "One argument per thread. If it is a new argument, it is a new thread.",
    ],
    tone: [
      "Argue with the position that was written, not the one you expected.",
      "Nobody here votes the way you think they do.",
      "Concede the small points out loud. It costs nothing and it is how threads stay alive.",
    ],
  },

  "politics-critical": {
    standard:
      "The <b>inverse</b> of the room next door: positions the op-ed page will not run, from either direction. <b>The centre is already well covered.</b>",
    short: "Outside the op-ed page",
    axis: ["Left of what the Times prints", "Right of what the Times prints"],
    windows: [
      [4, 33],
      [67, 96],
    ],
    protocols: [
      "Say which mainstream premise you are rejecting, up front, before you build on it.",
      "Heterodoxy is not a licence to skip the evidence. Unusual claims still get sources.",
      "One voice, one argument — a position does not win here by weight of numbers.",
      "Three replies, then yield the floor.",
    ],
    tone: [
      "Heterodoxy is the entry fee, not the argument.",
      "Everyone here is somebody else’s fringe.",
    ],
  },

  law: {
    standard:
      "Argue from the doctrine outward. <b>Policy preference is admissible — it just isn’t the argument.</b>",
    short: "Doctrine outward",
    axis: ["How I’d like it to be", "What the doctrine says"],
    windows: [[36, 100]],
    protocols: [
      "Cite a case, a statute or a scholar, and name the jurisdiction.",
      "Distinguish holding from dicta, and majority from concurrence.",
      "Say when you are describing the law and when you are criticising it.",
      "Three replies, then let it rest.",
    ],
    tone: [
      "No true crime, and no live personal legal problems. Those are Law (BA), in the Abyss.",
      "Non-lawyers are welcome here and should not be made to feel otherwise.",
    ],
  },

  economics: {
    standard:
      "A number, a model or a mechanism. <b>Personal finance and market chatter live in the Abyss.</b>",
    short: "Model, number or mechanism",
    axis: ["Vibes", "Model or data"],
    windows: [[40, 100]],
    protocols: [
      "State your assumptions before your conclusion.",
      "Give magnitudes, not just directions — “bigger” is not an answer.",
      "Say whether you are making a positive or a normative claim.",
      "Three replies, then yield.",
    ],
    tone: ["“I don’t know” is a complete answer here.", "No stock tips."],
  },

  commons: {
    standard:
      "<b>Almost everything is in window.</b> The only things that aren’t: turning a low-stakes thread into a proxy war, and turning it into homework.",
    short: "Low stakes, on purpose",
    axis: ["Too effortful to be fun", "Too heated to be casual"],
    windows: [[14, 86]],
    protocols: [
      "Take the fight to the room that is for it. Every argument has a better address than this one.",
      "Spoilers behind a blur, for anything less than a year old.",
      "Recommendations always welcome. Rankings are a trap, but an enjoyable one.",
    ],
    tone: [
      "This is the room where nobody has to be right.",
      "Enthusiasm is not embarrassing here.",
    ],
  },

  "blue-abyss": {
    standard:
      "<b>There is no window here.</b> This is the room the other windows exist to protect. What is said in the Abyss stays behind the door.",
    short: "Behind the door",
    axis: ["", ""],
    windows: [[2, 98]],
    protocols: [
      "Nothing from this world gets quoted, screenshotted or paraphrased outside it.",
      "Names, jobs and family details stay inside.",
      "If you would have to explain it to a stranger, you are in the right room.",
      "Anyone may ask for a post of theirs to be removed, and it will be, without discussion.",
    ],
    tone: [
      "Years of context are assumed here — and freely given to anyone who asks for it.",
      "Say the hard thing. Then stay for the reply.",
    ],
  },

  meta: {
    standard:
      "The machine room — <b>proposals, complaints and changelogs</b>, about the forum rather than about the world.",
    short: "About the forum, not the world",
    axis: ["Argument about a topic", "Argument about the forum"],
    windows: [[50, 100]],
    protocols: [
      "Bug reports get a URL, a browser, and what you expected instead.",
      "Disagree with the decision, not the person who made it.",
      "Feature requests are welcome even when the answer is no.",
    ],
    tone: ["Bluntness is fine here. It is the one room built for it."],
  },

  staff: {
    standard:
      "Not a public room. <b>Everything written here is a draft</b>, including decisions.",
    short: "Everything here is a draft",
    axis: ["Decided", "Thinking out loud"],
    windows: [[2, 98]],
    protocols: [
      "Decisions get written up in Meta before they take effect.",
      "Name a member only when the thread is actually about them.",
    ],
    tone: ["Say the uncomfortable version first."],
  },
};

/** Bump when the text changes materially — every member sees their worlds once more. */
export const RULES_VERSION = 1;

/** Merge the admin-editable JSON override (theme setting) over the defaults. */
export function rulesFor(slug, overrideJson) {
  const base = RULES[slug];
  if (!base) {
    return null;
  }
  if (!overrideJson) {
    return base;
  }
  let parsed;
  try {
    parsed = JSON.parse(overrideJson);
  } catch {
    // eslint-disable-next-line no-console
    console.warn("[blue-abyss] rules override is not valid JSON — ignoring it.");
    return base;
  }
  return parsed[slug] ? { ...base, ...parsed[slug] } : base;
}
