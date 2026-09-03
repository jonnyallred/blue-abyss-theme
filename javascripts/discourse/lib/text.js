/**
 * A deliberately tiny rich-text reader for rule copy.
 *
 * Rule text may contain <b> and <em> and nothing else. Rather than trusting a
 * string to the DOM (which would mean importing whichever of htmlSafe /
 * trustHTML the running Discourse happens to export this month, and opening an
 * HTML injection surface on admin-editable text), we parse those two tags into
 * plain segments and let the template render them. No imports, no raw HTML.
 */
const TAG = /<(\/?)(b|em)>/g;

export function segments(input) {
  if (!input) {
    return [];
  }
  const out = [];
  let bold = 0;
  let italic = 0;
  let last = 0;
  let m;
  TAG.lastIndex = 0;

  const push = (text) => {
    if (text) {
      out.push({ text, bold: bold > 0, italic: italic > 0 });
    }
  };

  while ((m = TAG.exec(input)) !== null) {
    push(input.slice(last, m.index));
    const closing = m[1] === "/";
    if (m[2] === "b") {
      bold += closing ? -1 : 1;
    } else {
      italic += closing ? -1 : 1;
    }
    bold = Math.max(0, bold);
    italic = Math.max(0, italic);
    last = m.index + m[0].length;
  }
  push(input.slice(last));
  return out;
}
