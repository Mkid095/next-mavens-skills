# AI Writing Detector — Outdated / Historical Indicators

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing#Outdated_access-date_parameters

These indicators were reliable in the past but **no longer are** in 2025+. Including them for completeness but flag them as historical only.

## ⚠️ Do NOT rely on these for 2025+ text

These indicators were valid for content generated between November 2022 and roughly 2024. They have since been mitigated, either because:
- LLMs were updated to avoid them
- They became clichés that LLMs are specifically trained against
- The patterns now appear in human text too (copycat effect)

---

## 1. Didactic disclaimers (November 2022–2024)

**Status:** Largely mitigated by 2025. LLMs no longer default to "It is important to note that..."

### Phrases that were reliable 2022–2024

- "It's important to note that..."
- "It is worth mentioning..."
- "It should be noted that..."
- "One thing to consider is..."
- "Importantly, ..."
- "Notably, ..."

### Why they're less reliable now

- LLMs are explicitly trained to avoid these
- They still appear in academic / formal writing naturally
- Copycat human writers also use them now

### Detection weight in 2025+

**Low** if isolated. Still useful as a corroborating signal.

---

## 2. Section summaries

**Status:** Still present but less reliable.

### Patterns

- "In this section, we will discuss..."
- "This section explores..."
- "Now let's look at..."

### Why it's still around

- Pedagogical habit hard to remove
- Some users explicitly request this style

### Detection weight

**Medium**. Still useful.

---

## 3. Prompt refusal

**Status:** Still valid but only in chat outputs.

### Phrases

- "As an AI..."
- "I cannot..."
- "I'm sorry, but..."
- "As a large language model..."

### Why still reliable

- Only LLMs produce these phrases
- They're defensive behaviors still in current models

### Detection weight

**Definite AI** if present.

---

## 4. Abrupt cut-offs

**Status:** Still reliable.

### Why

- Token limits + incomplete generation
- Context-window overflows
- User-stopped generation

### Detection weight

**High** when present.

---

## 5. Outdated access-date parameters

**Status:** Highly reliable historical indicator.

### Pattern

Wikipedia citations with access-date parameters dated to the training cutoff of the LLM:

```
{{cite web |url=... |title=... |access-date=2024-01-15}}
```

If access-date is suspiciously close to the LLM's known training cutoff, it likely never actually accessed the URL.

### Known training cutoffs (rough)

- GPT-3.5: January 2022
- GPT-4: April 2024
- GPT-4o: October 2023
- Claude 3 Opus: August 2024
- Claude 3.5 Sonnet: April 2024
- Gemini 1.0: February 2024
- Gemini 1.5 Pro: September 2024

### Detection cues

- Access-date close to known cutoff
- Access-date in the future
- Access-date that doesn't make sense (date before article publication)

### Detection weight

**High** if matches known cutoff.

---

## 6. Specific phrase sets by era

### 2023 to mid-2024 (GPT-4 era)

Most distinctive ChatGPT-era tells. If text dates from this period:

- `additionally`, `boasts`, `bolstered`, `crucial`, `delve`, `emphasizing`, `enduring`, `fostering`, `garner`, `notably`, `pivotal`, `showcasing`, `testament`, `utilize`, `vibrant`

### Late 2024 to 2025

ChatGPT was updated and these tells declined. New tells emerged:

- `distinct`, `stark`, `intricate`, `bold`, `imposing`, `dynamic`, `prominent`

### 2025+

Vocabulary drift continues. Lean on **structural patterns** more than vocabulary:

- Em dash density
- Inline-header lists
- Outline conclusions
- Rule of three
- Puffery clusters

---

## Combining era-aware analysis

When checking text, try to determine its date:

1. **Explicit date** in the document itself (publication, draft date)
2. **Last-modified timestamps** in metadata
3. **Cite dates** in references
4. **Tone clues** (which AI era it matches)

Then apply the appropriate era's vocabulary list. Don't flag 2023 text for lacking 2025 tells; don't flag 2025 text for using words that were AI tells in 2023 but normal now.

---

## How to detect LLM era of unknown text

If you can't determine the date, look at which vocabulary cluster appears:

- Lots of `delve` / `tapestry` / `testament` / `vibrant` → likely 2023-era LLM or copycat human
- Lots of `distinct` / `stark` / `bold` / `imposing` → likely 2024–2025 LLM
- Lots of `crucial` / `notably` + copulatives → likely 2022–2024 LLM
- Mainly structural patterns with no strong vocab → could be 2025+ LLM or careful human

The presence of specific **2022-2024 ChatGPT tells** (`delve`, `testament to`, `stands as a testament`) in 2025+ text is itself a tell — either it's older AI text or a copycat human.