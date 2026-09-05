# AI Writing Detector — Grammar Patterns

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing#Language_and_grammar

## 1. Avoidance of basic copulatives ("is"/"are" phrases)

**Pattern:** LLM text replaces simple `"X is Y"` / `"X has Y"` with elaborate constructions.

### Common substitutions

| Simple (human) | AI substitution |
|----------------|-----------------|
| `is` | `serves as`, `stands as`, `marks`, `functions as`, `operates as`, `represents` |
| `is a` | `serves as a`, `stands as a`, `acts as a` |
| `has` | `boasts`, `features`, `maintains`, `offers` |
| `was` (career) | `began his career as`, `ventured into politics as`, `embarked on a career as` |
| `refers to` (in leads) | LLMs sometimes write `"The term X refers to..."` when `X` is the subject |

### Why LLMs do this

Studies show >10% decrease in `is`/`are` usage in 2023 academic writing. The pattern comes from training on marketing copy and "elevated" prose.

### Examples from Wikipedia

**Before:** "Gallery 825 on La Cienega Boulevard, which was purchased in 1958, is LAAA's exhibition arm for contemporary art. There are four individual gallery spaces..."

**After (AI-edited):** "Gallery 825 on La Cienega Boulevard serves as LAAA's exhibition space for contemporary art. The gallery features four separate spaces..."

**Signals:**
- `serves as` replacing `is`
- `features` replacing `there are`
- Loss of "arm" (the original active meaning)

### Detection weight

**High** when 2+ copulative substitutions appear in the same passage.

---

## 2. Negative parallelisms

LLMs overuse three specific negation-based parallel structures.

### Pattern 1: "Not just X, but also Y"

> "...not just a cultural hub, but also a thriving commercial center..."

### Pattern 2: "Not X, but Y"

> "It's not just about the technology, it's about the people..."

### Pattern 3: "X rather than Y" (reframe)

> "This is a question of execution rather than vision."

### When it's natural

Human writers use these too. They become AI tells when:
- Repeated 2+ times per paragraph
- Combined with other AI vocabulary
- Used in formulaic positions (intro of every section)

### Detection weight

**Medium** per occurrence. **High** if combined with other tells.

---

## 3. Rule of three

Three parallel elements presented where any two would suffice.

### Examples

- "innovation, inspiration, and integration"
- "streamline operations, reduce costs, and improve efficiency"
- "vision, strategy, and execution"
- "people, process, and technology"

### Detection cues

- All three elements are roughly the same length
- All three end with similar grammatical form
- The third element adds nothing the first two didn't
- Combined with AI vocabulary (e.g., "leverage", "streamline")

### When it's natural

Human writing uses rule of three too ("life, liberty, and the pursuit of happiness"). It's AI when **overused** (3+ instances per 500 words) or when applied to lists where it's padding rather than meaningful parallelism.

### Detection weight

**Medium**. Flag if 2+ rules-of-three appear in close proximity.

---

## 4. Lexical diversity / elegant variation

**Pattern:** Same concept restated with multiple synonyms in nearby sentences.

### Example

> "The city is a hub. It serves as a center. The metropolis functions as the heart of the region. As the capital, it represents the cultural core..."

All four sentences say the same thing (city is important). A human would write one sentence. AI overwrites because it was trained to "vary the word choice."

### Detection cues

- Same noun restated 3+ times with synonyms (city / metropolis / capital / hub)
- Same verb restated with synonyms (is / serves as / functions as / represents)
- Adjacent sentences that could be collapsed into one

### Detection weight

**High** when 3+ synonym chains appear in the same paragraph.

---

## 5. Didactic disclaimers (still present in 2025+)

Pattern: sentence that prefaces information with a meta-statement about its importance.

- "It's important to note that..."
- "It is worth mentioning..."
- "It should be noted that..."
- "One thing to consider is..."
- "Importantly, ..."
- "Notably, ..."

### Why it's AI

LLMs are trained to "be helpful" and often insert these to signal information importance. Human writers rarely do.

### When it's natural

Academic writing uses "Importantly" or "Notably" as legitimate emphasis markers. Flag when:
- 2+ in the same paragraph
- Combined with other AI tells
- The "important note" is actually obvious

### Detection weight

**Medium**.

---

## 6. Section summaries (LLM transitional habit)

Pattern: each new section starts with a sentence that summarizes what the section will say.

- "In this section, we will discuss..."
- "This section explores..."
- "Now let's look at..."
- "Below, we examine..."
- "First, let's understand..."

### Why it's AI

LLMs are trained to be pedagogical. They restate the structure before content. Humans don't do this in normal writing.

### Detection weight

**High** when 2+ sections begin this way in the same document.

---

## 7. Prompt refusal / As an AI (only in chat outputs)

Only present if text is a chat response, not third-party content:

- "As an AI..."
- "I cannot..."
- "I'm sorry, but..."
- "As a large language model..."
- "I don't have personal opinions..."

### Detection weight

**Definite AI** if present (these phrases only come from chatbots).

---

## Combining grammar patterns

Multiple grammar patterns in the same passage is a strong AI signal:

> "It's important to note that the museum **serves as** a **vibrant** cultural hub. **Not just** a collection of artifacts, **but also** a **pivotal** center for education, the museum **features** galleries that **showcase** the region's **rich tapestry** of history."

Triggers: didactic disclaimer + 2 copulatives + negation parallelism + 3 AI vocabulary words + significance puffery = overwhelming signal.