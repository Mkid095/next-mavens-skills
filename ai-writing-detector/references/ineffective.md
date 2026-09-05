# AI Writing Detector — Ineffective Indicators

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing#Ineffective_indicators

These are indicators that **seem like** they should reveal AI text but **don't actually correlate** with AI generation. Listing them so the detector doesn't flag them.

---

## Things that look like AI but aren't reliable

### 1. Generic writing quality

**Myth:** "Well-structured writing must be AI."

**Reality:** AI text often has structure, but so does well-written human text. Bad writing doesn't mean human; good writing doesn't mean AI.

**Don't flag:** general writing quality, organization, or grammar level.

---

### 2. Lack of typos

**Myth:** "Human text has typos, AI doesn't."

**Reality:** 
- Professional human writers edit their work
- LLMs hallucinate misspellings of technical terms
- AI text frequently has subtle errors humans don't make (wrong dates, broken citations)

**Don't flag:** absence of typos alone.

---

### 3. Formal or professional tone

**Myth:** "Formal tone = AI."

**Reality:** Many professional contexts require formal writing. Academic writing, legal documents, technical docs — all naturally formal.

**Don't flag:** formal tone, professional vocabulary, or technical register.

---

### 4. Perfect grammar

**Myth:** "Perfect grammar means AI."

**Reality:** Native English speakers with good education write with perfect grammar. Also, AI frequently produces subtle grammatical errors that humans don't (e.g., wrong verb tense for context, mismatched plurals).

**Don't flag:** perfect grammar alone.

---

### 5. Use of em dashes (alone)

**Myth:** "Em dashes = AI."

**Reality:** Human writers use em dashes too. Some authors consistently prefer them. What matters is **density and position** (formulaic parallel structures), not presence.

**Don't flag:** occasional em dashes.

---

### 6. Use of bold/italics

**Myth:** "Bold/italics = AI."

**Reality:** Standard emphasis. Don't flag.

---

### 7. Lists and bullet points

**Myth:** "Lists = AI."

**Reality:** Lists are natural in many contexts (specs, instructions, comparisons).

**Don't flag:** lists in general. Flag only specific AI-style inline-header lists (bolded label + colon).

---

### 8. The word "however"

**Myth:** "However = AI."

**Reality:** Standard English word. Used by everyone.

**Don't flag.**

---

### 9. The phrase "in conclusion"

**Myth:** "In conclusion = AI."

**Reality:** Standard transition. Don't flag.

---

### 10. Repetitive sentence structure

**Myth:** "Repetitive sentences = AI."

**Reality:** Some human writers (especially non-native speakers) write repetitively. Repetition alone doesn't tell you anything.

**Don't flag:** repetition alone.

---

### 11. Long paragraphs

**Myth:** "Long paragraphs = AI."

**Reality:** Academic writing, legal writing, and technical docs naturally have long paragraphs. Some AI text has short paragraphs (LLMs vary).

**Don't flag:** paragraph length.

---

### 12. Use of transitions

**Myth:** "Smooth transitions = AI."

**Reality:** Good writing has transitions. Human writers can write smooth transitions.

**Don't flag:** transitions like "Furthermore", "Moreover", "Additionally" alone (though "Additionally" was a 2023 ChatGPT tell when combined with other patterns).

---

### 13. Numbered/structured steps

**Myth:** "Numbered steps = AI."

**Reality:** Tutorials, instructions, and procedures are naturally numbered.

**Don't flag.**

---

### 14. Headers and subheaders

**Myth:** "Many headers = AI."

**Reality:** Long documents need structure. Long human-written documents also have headers.

**Don't flag:** header presence. Flag only specific style issues (Title case, skipped levels).

---

## Summary: what NOT to use as a signal

| Looks like AI | But is unreliable because... |
|---------------|------------------------------|
| Good structure | Humans also write structured docs |
| Perfect grammar | Educated humans write well |
| Formal tone | Professional contexts require it |
| Lists | Natural for specs/instructions |
| Em dashes (occasional) | Humans use them too |
| Bold/italics | Standard emphasis |
| Transitions | Standard English |
| Long paragraphs | Natural for academic/technical |
| Many headers | Long docs need structure |
| Numbered steps | Natural for procedures |

**The actual signals** are specific patterns: vocabulary clusters, copulatives replacing is/are, structural formula (rule of three, negation parallelisms), formatting habits (inline-header lists, emoji bullets, Title case), attribution patterns ("active social media presence", listing media to prove notability), and content patterns (puffery, vague attributions, superficial analyses).

**It's the combination of signals, not any single one, that indicates AI.**

---

## The hardest cases

### Human mimicking AI

Some human writers now unconsciously mimic AI patterns because they've been reading AI text. Detection is harder for these.

### AI prompted to "write like a human"

Modern LLMs can avoid obvious tells if prompted. Detection relies on structural patterns and subtle vocabulary choices.

### Non-native English speakers

Some "AI tells" (e.g., overuse of `is/are` avoidance) are actually common in well-edited non-native English. Context matters.

### Translated text

Text translated from another language through an LLM may have different patterns than original LLM output. Look for translation artifacts (consistent word choice for technical terms that wouldn't match) rather than the usual vocabulary.

---

## What to report when detection is uncertain

If signals are mixed or weak, the report should say:

> "Detection result: **Inconclusive**. Some patterns suggest AI (cite them), others suggest human (cite them). The user should review with context I don't have access to."

Don't manufacture a verdict when signals are mixed. Honesty > false confidence.