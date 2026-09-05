# AI Writing Detector — Structural Patterns

Beyond vocabulary and grammar, LLMs produce distinctive document structures.

## 1. Inline-header vertical lists (covered in style.md)

Bolded label + colon + description list items. Most common AI list format.

---

## 2. Outline conclusions

Generic "Challenges" / "Future prospects" / "Opportunities" sections at the end. See content.md §6.

---

## 3. Lead paragraph formula

**Pattern:** Wikipedia-style leads that follow a strict template LLMs copy.

### AI lead template

> "[Title] is a [type] in [location], [country]. Established in [year], it [purpose]. [Notable fact 1]. [Notable fact 2]. [Notable fact 3]."

### Example (from real Wikipedia AI text)

> "The Festival is an annual cultural festival held in the city of Townsville, Australia. Established in 1985, it celebrates the region's heritage and artistic traditions. The festival features music, dance, and food from local artists. It attracts visitors from across the country and has become a significant cultural event in the region."

### Detection cues

- Rigid subject-is-location-established format
- Three "notable facts" each restating the previous one
- Lacks any specific facts (names, dates, numbers)
- Could be about any festival anywhere

### Detection weight

**High** when combined with other tells.

---

## 4. Wikipedia list/broad article titles treated as proper nouns

LLMs sometimes treat the article's own title as a specific proper noun. See content.md §7.

---

## 5. Section count and structure

### Suspicious patterns

- Very high section count for short article (10+ sections in 500 words)
- Sections of exactly equal length (LLM tends to balance)
- Each section follows identical internal pattern (intro sentence + 3 bullets + conclusion)
- The article follows a "perfect" outline that feels templated

### Detection cues

- Section structure too clean / symmetrical
- All sections ~same length (±10%)
- Each section starts the same way (e.g., "The X is...")
- Missing sections that would naturally be present (History, Reception, etc.)

### Detection weight

**Medium**. High if combined with templated internal structure.

---

## 6. Citation absence despite claims

**Pattern:** Specific-sounding claims with no citations.

### Example

> "Studies have shown that 78% of users prefer the new design."

No citation, no study name, no year. Just a number.

### Detection cues

- Specific statistics with no source
- "Studies show" / "Research indicates" without citation
- Quotes attributed to unnamed "experts"
- Numbers that sound precise but are unverifiable

### Detection weight

**Medium** per occurrence. **High** in combination with vague attribution.

---

## 7. Balanced-against-each-other false neutrality

**Pattern:** LLMs try so hard to be neutral that they manufacture fake balance.

### Example

> "Supporters argue the policy benefits the economy, while critics say it harms small businesses. The debate continues."

Both sides presented as equal, no actual evidence for either, conclusion is "the debate continues" (no information).

### Detection cues

- "Some say X, others say Y" structure with no specifics
- "The debate continues" / "opinions vary" / "it remains to be seen"
- False balance on settled facts
- Conclusion that adds no information

### Detection weight

**Medium**. Higher if combined with vague attribution.

---

## 8. Article count and length mismatches

**Pattern:** AI text often has the "right" length for its type but the wrong density.

### Examples

- A 500-word article about a complex topic (too short, no depth)
- A 5000-word article about a simple topic (padding)
- Every section approximately the same length
- Total word count matches a "target" the LLM was given (e.g., "write a 1000-word article")

### Detection cues

- Word count suspiciously matches a round number
- Section lengths too uniform
- Density inappropriate for topic complexity

### Detection weight

**Low**. Useful corroborating signal.

---

## 9. Hallucinated markup

**Pattern:** Non-existent templates, made-up parameters, malformed HTML/markdown.

### Examples (from real Wikipedia AI drafts)

```
{{Infobox ancient population
| name = Gangetic Hunter-Gatherer (GHG)
| image = [[File:GHG_reconstruction.png|250px]]
| descendants = Gangetic peoples, Indus Valley Civilisation, South Indian populations
| archaeological_sites = Bhimbetka, Sarai Nahar Rai, Mahadaha, Jhusi, Chirand
}}
```

- "Infobox ancient population" doesn't exist as a template
- The descendants/archaeological_sites parameters don't exist for any infobox

### Detection cues

- Made-up template names (especially plausible-sounding ones)
- Parameters that don't exist for known templates
- Marked-up text that wouldn't render correctly
- Hallucinated categories, file names, or external links

### Detection weight

**High** when present (very characteristic of AI).

---

## 10. Pre-placed maintenance templates

**Pattern:** AI generated drafts sometimes include their own review/decline templates.

### Examples

```
{{AfC submission|d}}
```

The `|d` parameter auto-declines the submission before any human review.

### Other examples

- `{{Short description=...}}` with wrong format
- `{{Use American English|date=September 2022}}` on a non-US topic
- `{{Use mdy dates|date=February 2025}}` on a topic where dmy is standard
- Maintenance tags (`{{orphan}}`, `{{uncategorized}}`) that wouldn't yet apply

### Detection cues

- Any pre-applied decline/review template on a new draft
- Maintenance templates inconsistent with the article's actual state
- Templates dated months/years in the past

### Detection weight

**High** when present.

---

## 11. Abrupt cut-offs

**Pattern:** Sentences ending mid-thought.

### Examples

> "Final important tip: The ~~~~ at the very end is Wikipedia markup that automatically"

Just stops. No period. No completion.

### Detection cues

- Last sentence missing its end
- Sentence ending in a strange place (mid-clause)
- Trailing "and" / "or" / "but" with no continuation
- Text just... stops

### Detection weight

**High** when present (suggests incomplete AI generation).

---

## 12. Repeated boilerplate

**Pattern:** Same sentence or paragraph appears multiple times with minor variations.

### Examples

> "The company has been featured in Forbes."

> "The company has been profiled by Forbes."

> "Forbes has featured the company."

Three different ways to say the same thing.

### Detection cues

- Same fact stated 3+ ways in close proximity
- Identical sentence structures
- Lists that repeat the same content in different words

### Detection weight

**Medium**. Especially in combination with attribution puffery.