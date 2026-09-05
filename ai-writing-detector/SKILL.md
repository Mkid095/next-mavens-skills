---
name: ai-writing-detector
description: Detects signs of AI-generated writing in user-provided text using the Wikipedia Signs of AI Writing taxonomy (vocabulary, grammar patterns, style, formatting, content structure, outdated/historical signs). Use when user asks to check text for AI writing, scan for AI tells, review a draft for AI patterns, "is this AI", or paste content for analysis. Quotes matched phrases with location, suggests human rewrites, produces a confidence score.
disable-model-invocation: true
allowed-tools: Read Write
---

# AI Writing Detector

Detects AI-generated writing using the Wikipedia Signs of AI Writing taxonomy.

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing (WikiProject AI Cleanup, ~87 sections, continuously maintained).

---

## Invocation

| Input | Action |
|-------|--------|
| `/ai-writing-detector` (no text) | Ask user to paste text or specify a file |
| `/ai-writing-detector <pasted text>` | Scan the inline text |
| `/ai-writing-detector file:<path>` | Scan the file at `<path>` (relative to cwd or absolute) |
| `/ai-writing-detector --strict` | Lower threshold, flag weaker matches |
| `/ai-writing-detector --lenient` | Only flag obvious patterns, ignore borderline |
| `/ai-writing-detector --rewrite` | After detection, suggest human rewrites for each match |
| `/ai-writing-detector --score-only` | Just produce the overall score, no per-match breakdown |

Default: scan inline text with rewrite suggestions.

---

## Detection Workflow

### 1. Load reference files (always read first)

```
~/.claude/skills/ai-writing-detector/references/
├── vocabulary.md     ← overused AI words + copulatives
├── grammar.md        ← parallelism, rule of three, negation patterns
├── style.md          ← title case, boldface, em dashes, emoji, tables, quotes
├── content.md        ← significance puffery, attribution puffery, superficial analysis, promotional tone
├── structural.md     ← inline-header lists, outline conclusions, lead paragraphs, lists-as-proper-nouns
├── outdated.md       ← historical (2022–2024) indicators no longer reliable
└── ineffective.md    ← signals that look like AI but aren't reliable
```

If any reference file is missing, fall back to the embedded taxonomy in this SKILL.md (see "Embedded Cheat Sheet" below).

### 2. Load the text

- If `--file:` given → read file
- If text provided inline → use it directly
- If neither → ask user to paste the text

### 3. Run category scans in order

For each category, search the text and produce matches:

| # | Category | What to look for |
|---|----------|------------------|
| A | **Vocabulary** | AI-tell words (delve, tapestry, testament, pivotal, foster, bolster, crucial, intricate, landscape, vibrant, testament, enduring, leverage, garner, robust, etc.) |
| B | **Copulatives** | "serves as / stands as / marks / functions as / operates as / represents / boasts / features / maintains / offers" replacing simple "is / are / has" |
| C | **Negation patterns** | "Not just X, but also Y" / "Not X, but Y" / "X rather than Y" |
| D | **Rule of three** | Three parallel elements in lists, headings, or sentence structures (e.g., "innovation, inspiration, and integration") |
| E | **Lexical variation** | Restating the same concept with synonyms in nearby sentences |
| F | **Significance puffery** | "stands as a testament", "pivotal moment", "broader trends", "lasting legacy", "enduring impact" |
| G | **Attribution puffery** | "featured in", "profiled in", "widely recognized", "active social media presence", "independent coverage" |
| H | **Superficial analysis** | Generic claims without specific evidence ("plays a vital role", "contributed to the broader landscape") |
| I | **Promotional tone** | Marketing-speak, "vibrant", "nestled", "bustling", "stunning", "must-visit" |
| J | **Vague attribution** | "experts say", "many believe", "industry reports suggest", unnamed sources |
| K | **Outline conclusions** | Generic "challenges and future prospects" sections, listy wrap-ups |
| L | **Title case** | Section headings in Title Case (Capitalize Every Word) rather than sentence case |
| M | **Boldface overuse** | Multiple bolded phrases per paragraph, especially for emphasis on otherwise ordinary words |
| N | **Inline headers** | List items formatted as bold inline headers (e.g., "**Customer service:** They offer...") |
| O | **Em dashes** | High density of em dashes (—), especially in formulaic positions; counts >3 per 1000 words is suspicious |
| P | **Emoji as formatting** | Emoji used to replace structure (✨ bullet, 🔹 sub-bullet, 🎯 emphasis) instead of markdown |
| Q | **Curly quotes** | Curly quotation marks ("…") instead of straight ASCII ("…") where the latter would be standard |
| R | **Skipped heading levels** | H1 → H3, missing H2 |
| S | **Didactic disclaimers** | "It's important to note...", "It is worth mentioning...", "It should be noted that..." |
| T | **Section summaries** | Restating earlier content at start of new section ("In this section, we will discuss...") |
| U | **Prompt refusal** | "I cannot...", "As an AI...", "I'm sorry but..." |
| V | **Abrupt cut-offs** | Mid-sentence truncation, missing words, dangling clauses |
| W | **Non-existent templates/markup** | Made-up Wikipedia/coding markup (`{{Infobox ...}}` with wrong params, malformed markdown) |

### 4. Score each match

Each match gets a weight:
- **High confidence** (score 2): exact AI-tell phrase, e.g. "tapestry of", "stands as a testament", "leverage"
- **Medium confidence** (score 1): structural pattern, e.g. rule-of-three, em dash density, boldface overuse
- **Low confidence** (score 0.5): borderline case, e.g. single negation pattern in otherwise normal text

### 5. Produce report

Output structure (see "Output Format" below):
- Score (0–100, normalized by word count)
- Per-category match list with quoted phrase + location
- If `--rewrite`: for each match, suggest a human rewrite
- Final verdict: "Likely AI" / "Possibly AI" / "Mostly human"

### 6. Verdict thresholds

| Score (per 1000 words) | Verdict |
|------------------------|---------|
| < 5 | **Mostly human** — patterns within normal range |
| 5–15 | **Possibly AI** — some signals, could be human stylistic choice |
| 15–30 | **Likely AI** — multiple categories triggered, manual review warranted |
| 30+ | **Almost certainly AI** — characteristic AI signature |

Adjust thresholds for `--strict` (×0.7) or `--lenient` (×1.5).

---

## Output Format

```markdown
## AI Writing Detection Report

**Verdict:** Likely AI
**Score:** 23.4 / 1000 words (medium-high)
**Word count:** 412 words

### Matches Found

#### [Category F] Significance Puffery (3 matches, score 6)
1. **"stands as a testament to"** — line 4: "...the building **stands as a testament to** the city's vibrant history..."
2. **"pivotal moment"** — line 12: "...marked a **pivotal moment** in the development of..."
3. **"broader trends"** — line 18: "...reflects **broader trends** in the industry..."

#### [Category O] Em Dash Density (1 match, score 2)
- 7 em dashes in 412 words (1.7%) — above the 0.3% threshold typical of human prose

#### [Category C] Negation Pattern (1 match, score 1)
1. **"Not just X, but also Y"** — line 22: "...**not just a cultural hub, but also a** thriving commercial center..."

### Suggested Rewrites

| Original | Suggested Human Rewrite |
|----------|--------------------------|
| "stands as a testament to the city's vibrant history" | "the building has been part of the city's history for over 100 years" |
| "pivotal moment in the development of" | "important time for" or "the year when..." |
| "broader trends in the industry" | "what was happening elsewhere in the industry at the time" |
```

---

## Embedded Cheat Sheet (fallback if reference files missing)

### A. Vocabulary (high-confidence AI tells)

**Always flag these words if they appear in non-quoted text:**
`delve, delve into, tapestry, vibrant, testament, pivotal, foster, bolster, crucial, intricate, landscape (metaphorical), enduring, leverage (verb), garner, robust, multifaceted, holistic, paradigm, synergy, seamless, streamline, utilize, facilitate, endeavor, embark, embark on a journey, navigate (metaphorical), realm (metaphorical), in the realm of, ever-evolving, fast-paced, rapidly evolving, ever-changing, dynamic, vibrant, bustling, nestled, stunning, must-visit`

**Date-sensitive (2023 to mid-2024):** `additionally, boasts, bolstered, crucial, emphasizing, enduring, fostering, garner, notably, pivotal, showcasing, testament, utilize, vibrant`

**Date-sensitive (late 2024 to 2025):** `distinct, stark, vibrant, intricate, bold, imposing, dynamic, prominent`

**Date-sensitive (2025+):** The above list has shifted; consult `references/vocabulary.md` for current

### B. Copulatives (replacing "is/are/has")

`"serves as a" / "stands as a" / "marks a" / "functions as" / "operates as" / "represents a"` replacing `"is a" / "is the"`

`"boasts" / "features" / "maintains" / "offers"` replacing `"has"`

`"refers to"` in lead sentences replacing `"is"`

### C. Negation patterns

- "Not just X, but also Y"
- "Not only X, but Y"
- "It's not just about X, it's about Y"
- "X rather than Y" (as a sentence reframe)
- "More than just X, [subject] is Y"

### D. Rule of three (when formulaic)

Three parallel elements presented in lists where any two would suffice, e.g., "innovation, inspiration, and integration"; "streamline operations, reduce costs, and improve efficiency"

### E. Lexical variation

Same concept restated with multiple synonyms in nearby sentences: "The city is a hub. It serves as a center. The metropolis functions as the heart of..."

### F. Significance puffery

`"stands as a testament" / "pivotal moment" / "broader trends" / "lasting legacy" / "enduring impact" / "rich history" / "rich tapestry" / "evolving landscape" / "plays a vital role" / "plays a key role"`

### G. Attribution puffery

`"featured in" / "profiled in" / "widely recognized" / "active social media presence" / "maintains an active social media presence" / "independent coverage" / "regional media" / "trade publications" / "high-quality outlets"`

### H. Superficial analysis

Generic claims without evidence: `"plays a vital role" / "contributed to the broader landscape" / "has become increasingly important"`

### I. Promotional tone

Marketing language outside commercial contexts: `"vibrant" / "nestled" / "bustling" / "stunning" / "must-visit" / "renowned" / "world-class" / "state-of-the-art" / "cutting-edge"`

### K. Outline conclusions

Sections like "Challenges and Future Prospects", "Conclusion" with bullet lists that summarize without adding new info.

### L. Title case

Headings like "The Early Life And Education" instead of "The early life and education"

### M. Boldface overuse

>3 bolded phrases per 200 words, especially for emphasis on common words

### N. Inline headers in lists

`"- **Customer service:** They offer..."` where the list item is a bolded label followed by a colon and description (rather than a real heading)

### O. Em dash density

>3 em dashes per 1000 words in non-fiction prose is suspicious. >5 is a strong signal.

### P. Emoji as formatting

`✨ • 🔹 • 🎯 • ✅ • 📌 • 💡` used as bullet points or section markers instead of markdown

### P-Bonus. AI visual vocabulary (UI scope only)

The Wikipedia Signs of AI Writing page is text-focused. But there's a parallel **AI visual vocabulary** that applies to UI:
- ✨ Sparkles, 🪄 Wand, 🧠 Brain, 🤖 Robot, 🪐 Orb, ❤️ Heartbeat, 🌐 Neural nodes
- Purple/violet gradient backgrounds, glassmorphism, pulsing glow/shimmer

UI generated by AI tends to overuse these. See the `anpas` skill's "No AI visual vocabulary" rule for the canonical list. If you're scanning a UI description and the user mentions these icons or styles, flag it.

### Q. Curly quotes

`"..." '...'` instead of `"..." '...'` in code, plain prose, or anywhere straight quotes would be standard

### S. Didactic disclaimers

`"It's important to note..." / "It is worth mentioning..." / "It should be noted that..." / "One thing to consider is..."`

### T. Section summaries

`"In this section, we will discuss..." / "This section explores..." / "Now let's look at..."`

### U. Prompt refusal / As an AI

`"As an AI..." / "I cannot..." / "I'm sorry but..." / "I'm an AI assistant..."`

### V. Abrupt cut-offs

Sentences ending mid-thought: "Final important tip: The ~~~~ at the very end is..." (Wikipedia typo, but the pattern is real)

### W. Non-existent templates/markup

Made-up infobox params, hallucinated markdown, malformed HTML

---

## Verification Checklist

Before declaring done:
- [ ] Read all reference files (or used embedded cheat sheet)
- [ ] Scanned all 23 categories (A–W)
- [ ] Each match quoted with location (line number or paragraph)
- [ ] Score normalized per 1000 words
- [ ] Verdict threshold applied correctly
- [ ] If `--rewrite`, suggested human rewrites for every match
- [ ] Report includes word count
- [ ] No false positives flagged (e.g., "leverage" in finance context, "tapestry" as a literal noun)

---

## Important Limitations

**Honesty section:**

- This is a **detection aid**, not a definitive judge. Wikipedia's own page says: "this list is descriptive, not prescriptive; it consists of observations, not rules" and "Not all text featuring these indicators is AI-generated."
- AI vocabulary shifts over time. Words that screamed "AI" in 2024 may be normal in 2026 (e.g., "delve" dropped sharply after early 2024).
- Human writers can mimic AI patterns (especially if they've been reading AI output). Conversely, AI prompted to "write like a human" can avoid obvious tells.
- **Cultural / domain differences**: Academic writing naturally uses more Latinate vocabulary. Marketing copy naturally uses promotional language. Apply context before flagging.
- **Em dashes in particular**: human writers do use em dashes; what matters is *density* and *position* (LLMs overuse them in formulaic "punched up" parallelisms).
- The verdict is a **starting point for review**, not an accusation. Always pair the report with: "this is a heuristic; the user should make the final call."