# AI Writing Detector — Style References

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing#Style

## 1. Title case in headings

**Pattern:** All words capitalized in headings, instead of sentence case.

### AI example

> ## The Early Life And Education Of The Founder

### Human example (sentence case)

> ## The early life and education of the founder

### Why it's AI

LLMs default to Title Case for headings because much of their training data (especially news and marketing) uses Title Case. Native English writers in non-marketing contexts use sentence case.

### When title case IS natural

- News headlines
- Book titles (per style guides)
- Marketing copy
- Academic titles of works being cited
- Proper nouns / organization names

### Detection cues

- Heading uses Title Case AND content has other AI tells
- Title Case in non-marketing context (Wikipedia article, blog post, technical doc, email)
- Consistent Title Case across multiple headings in same document

### Detection weight

**Medium**. Add weight if combined with other tells.

---

## 2. Overuse of boldface

**Pattern:** Heavy use of `**bold**` for emphasis on otherwise ordinary words.

### AI example

> "The building features a **distinctive** facade, **intricate** stonework, and a **vibrant** color palette. The **pivotal** moment in its history came in 1958 when..."

### Human example

> "The building has a distinctive facade with intricate stonework. The pivotal moment in its history came in 1958 when..."

### Detection cues

- More than 3 bolded phrases per 200 words
- Bolding common words ("and", "the", "is") that don't need emphasis
- Bolding for emphasis where italics would be more appropriate
- Bolding words that aren't being defined

### Detection weight

**High** if 4+ bolded phrases per 200 words.

---

## 3. Inline-header vertical lists

**Pattern:** List items formatted with bolded labels followed by colon and description, where the bolded label acts like a heading.

### AI example

> - **Customer service:** They offer 24/7 support.
> - **Pricing:** Competitive rates starting at $99/month.
> - **Features:** Includes all premium capabilities.
> - **Support:** Dedicated account manager.

### Human example

> We offer 24/7 customer support with a dedicated account manager. Pricing starts at $99/month and includes all premium features.

### Why it's AI

LLMs default to this format because their training data includes many bullet lists with bolded labels. But it's also used legitimately in product specs and feature comparisons.

### Detection cues

- 3+ inline-header list items in close proximity
- Bolded labels are generic (Customer service, Features, Benefits)
- The list could be rewritten as flowing prose without information loss
- Combined with AI vocabulary

### When it's natural

- Product feature comparisons
- Glossary entries
- FAQ items
- API parameter documentation

### Detection weight

**Medium**. Higher if combined with AI vocab.

---

## 4. Overuse of em dashes

**Pattern:** High density of em dashes (`—`), especially in formulaic positions.

### Statistics

- Human non-fiction prose: ~0.3% em dashes (about 1 per 350 words)
- LLM prose: often 1.5–3% (3–10 per 350 words)
- The threshold for suspicion: **>3 em dashes per 1000 words** in non-fiction prose

### Why LLMs overuse em dashes

LLMs were trained (sometimes illegally) on novels, where em dashes are common. They transfer that style to non-fiction contexts where it doesn't belong, and use them in formulaic "punched up" parallelisms.

### Formulaic positions (especially suspicious)

- "X — and Y — for Z" (double em dash around conjunction)
- "The result — a pivotal moment — was..." (parenthetical em dashes around significance claim)
- Lists with em dashes instead of colons or commas

### Example

> "The city — with its vibrant culture — serves as a testament to the region's rich history — and continues to play a pivotal role in..."

### When em dashes ARE natural

- The author's normal style (some writers consistently use em dashes)
- Long parenthetical asides that need strong separation
- Dialogue attribution in fiction
- Quoted speech

### Detection cues

- Em dash count >3 per 1000 words in non-fiction
- Em dashes around significance claims (`— a testament to —`, `— a pivotal moment —`)
- Em dashes replacing commas (where a comma would be more natural)
- Combined with AI vocabulary inside the em-dash clauses

### Detection weight

**High** when density >5 per 1000 words AND used in formulaic positions.

---

## 5. Emoji as formatting

**Pattern:** Emoji used to replace structural markdown rather than add meaning.

### AI example

> ✨ **Key Features**
> - 🔹 **Speed:** Fast processing
> - 🔹 **Reliability:** 99.9% uptime
> - 🎯 **Goal:** Customer satisfaction
> - ✅ **Result:** Proven success
> - 💡 **Tip:** Try it today

### Human example

> ## Key features
> - Fast processing
> - 99.9% uptime
> - Customer satisfaction focus
> - Proven results

### Why it's AI

LLMs trained on emoji-heavy social media content sometimes default to emoji bullets and section markers. Human technical writers don't do this in non-marketing docs.

### Detection cues

- Emoji used as bullets (✨ • 🔹) instead of `-` or `*`
- Multiple emoji per section (>3 different emojis in one document)
- Emoji without semantic meaning (decorative only)
- Combined with boldface and inline-headers

### When emoji IS natural

- Casual social media content
- Chat messages
- Marketing copy intentionally using emoji for energy
- Personal notes

### Detection weight

**Medium** per emoji in non-casual contexts.

---

## 6. Unusual use of tables

**Pattern:** Tables used where prose would be more natural, or tables with AI-padded cells.

### AI example

| Aspect | Description |
|--------|-------------|
| **Vision** | To be the leading provider of innovative solutions in the industry. |
| **Mission** | To deliver exceptional value to our customers through cutting-edge technology. |
| **Values** | Integrity, innovation, and excellence in everything we do. |

### Human example

> Our vision is to lead the industry in innovative solutions. Our mission is to deliver value through technology. Our values are integrity, innovation, and excellence.

### Detection cues

- Tables for 1- or 2-row content (over-formatting)
- Tables where each cell contains a full sentence with significance puffery
- Tables for content that's clearly prose (background, history)
- 3+ tables in a short document for non-comparison content

### When tables ARE natural

- Comparison of 3+ items across multiple attributes
- Numerical data presentation
- API/method signatures
- Pricing tiers

### Detection weight

**Medium** if 3+ tables for non-comparison content.

---

## 7. Curly quotation marks and apostrophes

**Pattern:** Curly typographic quotes (`"..."`, `'...'`) where straight ASCII quotes (`"..."`, `'...'`) would be standard.

### When it's AI

LLMs output unicode curly quotes by default (they were trained on professionally typeset text). When the output should use straight quotes (code, plain prose, plain-text data files), curly quotes are a tell.

### Detection cues

- Curly quotes in source code or code blocks
- Curly quotes in plain text files (.txt, .csv, .log)
- Curly quotes in URLs (breaks them!)
- Curly quotes in technical specs where straight is standard

### When curly quotes ARE natural

- Final published typeset documents
- Books, magazines, newspapers
- Any document that's gone through professional typography

### Detection weight

**Low** per occurrence. **High** if many curly quotes appear in code, data, or technical specs.

---

## 8. Skipped heading levels

**Pattern:** Document jumps from `#` (H1) to `###` (H3), missing H2. Or jumps from H2 to H4.

### Why it's AI

LLM output sometimes loses track of heading hierarchy when generating section after section. Humans writing with intent usually maintain the hierarchy.

### Detection cues

- H1 → H3 jump
- H2 → H4 jump
- Inconsistent heading levels across sections

### Detection weight

**Medium**.

---

## Combining style patterns

A document with multiple style tells is much more likely to be AI:

- Title case headings + boldface overuse + inline-header lists = strong signal
- High em dash density + significance puffery inside em-dashes = strong signal
- Emoji formatting + inline-header lists + AI vocab = strong signal

Single style tells in isolation are weaker — humans do each one sometimes. The combination is what matters.