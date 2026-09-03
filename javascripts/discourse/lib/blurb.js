/**
 * The one line under a world's name.
 *
 * Category descriptions are HTML, arrive pre-truncated with a literal
 * `&hellip;`, and — on this forum — carry a tail of admin notes ("Successor to
 * the old X; only clearly academic threads get promoted here") that members
 * have no use for. So: decode the entities, take the first sentence, and fall
 * back to the short remit in worlds.js when a category has no description at
 * all (International Affairs, Politics (Conventional), Meta and the Abyss).
 */
const DECODER =
  typeof document === "undefined" ? null : document.createElement("textarea");

function decode(input) {
  if (!input || !DECODER) {
    return input || "";
  }
  // A detached <textarea> decodes entities without parsing tags or running
  // anything — the standard trick, and safe on admin-authored text.
  DECODER.innerHTML = input;
  return DECODER.value;
}

export function firstSentence(input, limit = 200) {
  const text = decode(input).replace(/\s+/g, " ").trim();
  if (!text) {
    return "";
  }
  // A sentence end is .!? followed by a space and a capital — which leaves
  // "philosophy of mind/science, logic" and "e.g." alone.
  const match = text.match(/^.*?[.!?](?=\s+[A-Z“"(])/);
  let out = match ? match[0] : text;
  if (out.length > limit) {
    out = out.slice(0, limit).replace(/\s+\S*$/, "") + "…";
  }
  return out;
}

export function blurbFor(category, world) {
  const own = firstSentence(category?.description_text || category?.description);
  return own.length > 12 ? own : world?.blurb || "";
}
