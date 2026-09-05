# AI Writing Detector — Content Patterns

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing#Content

## 1. Undue emphasis on significance, legacy, and broader trends

**Pattern:** Claims of importance, legacy, or trend-membership that aren't supported by the cited sources.

### Common phrases

- "stands as a testament to"
- "pivotal moment in"
- "represents a significant turning point"
- "reflects broader trends in"
- "contributes to the broader landscape of"
- "leaves a lasting legacy"
- "enduring testament"
- "rich history spanning centuries"
- "important part of the region's heritage"

### Examples from Wikipedia

> "An enduring testament to the influence of Italian colonial rule in Somalia is the widespread adoption of pasta and lasagne in the local culinary landscape..."

> "Additionally, Somali merchants played a pivotal role in the global coffee trade, being one of the first to export coffee beans."

Both sentences claim historical significance without citing a specific source or evidence.

### Detection cues

- Importance claim without specific source
- Phrase structure: "stands as a testament", "pivotal moment", "broader trends"
- Multiple significance claims in same article (especially in lead/conclusion)
- Claim that everything is "important", "vital", "key", "significant"

### Detection weight

**High** per occurrence. Especially damaging in lead paragraphs.

---

## 2. Canned emphasis on notability, attribution, and media coverage

**Pattern:** LLMs, when asked to write a Wikipedia-style article, echo the wording of notability guidelines, listing media coverage to "prove" importance.

### Common phrases

- "featured in [publication]"
- "profiled in [outlet]"
- "widely recognized as..."
- "covered by [X], [Y], and [Z]"
- "maintains an active social media presence"
- "independent coverage in [list of publications]"
- "trade publications"
- "regional media outlets"
- "music/business/tech outlets"
- "written by a leading expert"

### Why it's AI

Human-written press releases cite sources, but LLMs specifically echo the *exact wording* of Wikipedia's notability guidelines (e.g., "independent coverage"). The phrase "maintains an active social media presence" is **particularly idiosyncratic to AI text** and relatively uncommon before ~2024.

### Examples

> "The subject has been profiled in multiple high-quality, independent, and widely-read outlets, including The Australian, SBS News, 7News..."

> "She spoke about AI on CNN, and was featured in Vogue, Wired, Toronto Star, and other media."

> "Its significance is documented in archived school event programs and regional press coverage, including the Mesabi Daily News, which regularly reviewed performances held there."

### Detection cues

- The phrase "active social media presence" (very strong AI tell)
- Listing media outlets to establish notability
- Using "trade publications" / "regional media" / "independent coverage" as if reciting Wikipedia's notability guideline
- Multiple media outlets listed with no specific article cited

### Detection weight

**High** per occurrence. Very characteristic of AI text.

---

## 3. Superficial analyses

**Pattern:** Generic claims that sound analytical but contain no actual analysis.

### Common phrases

- "plays a vital role in"
- "contributes to the broader landscape"
- "has become increasingly important"
- "reflects the changing dynamics of"
- "is a key part of the ecosystem"
- "has emerged as a significant player"
- "represents an important step forward"

### Examples

> "The initiative plays a vital role in fostering innovation and driving economic growth in the region, contributing to the broader landscape of community development."

This sentence has zero content. It says "initiative is important for the area" without saying what the initiative is, what it does, or what specifically changed.

### Detection cues

- Importance claim without specific facts
- Generic verbs (plays, contributes, reflects, represents)
- No concrete nouns (what specifically? what data?)
- Could apply to literally anything

### Detection weight

**High** when 3+ superficial analyses appear in same article.

---

## 4. Promotional and advertisement-like language

**Pattern:** Marketing/real-estate language in non-commercial contexts.

### Common words

- `vibrant` (community, culture, atmosphere)
- `nestled` (in the hills, by the river)
- `bustling` (with activity)
- `stunning` (views, architecture)
- `must-visit` (destination)
- `renowned` (chef, restaurant, hotel)
- `world-class` (facilities, service)
- `state-of-the-art`
- `cutting-edge`
- `picturesque`
- `charming`
- `exquisite`
- `breathtaking`
- `idyllic`
- `lively`
- `dynamic`
- `thriving`
- `flourishing`

### Examples

> "...where camel meat and milk are considered a delicacy and serve as cherished and fundamental elements in the rich tapestry of Somali cuisine."

This reads like a tourism brochure, not an encyclopedia article.

### Detection cues

- Real estate / tourism adjectives
- Combined with food/culture descriptions
- 3+ promotional adjectives per paragraph
- No specific facts (just vibes)

### When promotional language IS natural

- Marketing copy / advertising
- Travel guides (purposefully promotional)
- Restaurant reviews
- Hotel descriptions

### Detection weight

**Medium** per adjective. **High** if multiple in non-promotional context.

---

## 5. Vague attributions and overgeneralization of opinions

**Pattern:** Citing unnamed or vague sources for claims.

### Common phrases

- "experts say"
- "many believe"
- "industry reports suggest"
- "some researchers argue"
- "it is widely believed"
- "critics have noted"
- "observers point out"
- "studies show" (without citation)
- "according to sources"

### Examples

> "Many experts believe the new policy will have a lasting impact on the industry, though some critics have raised concerns about its implementation."

No expert named. No critic named. No study cited. Just vague consensus.

### Detection cues

- "Many" / "some" / "experts" without names
- Plural "researchers" / "critics" without specifics
- "Studies show" with no citation
- The attributed opinion is generic or uncontroversial

### Detection weight

**Medium** per occurrence. **High** if 3+ vague attributions in same document.

---

## 6. Outline-like conclusions about challenges and future prospects

**Pattern:** Generic "Challenges" and "Future" sections that just list topics without substance.

### Common structure

> ## Challenges
> - Funding constraints
> - Regulatory hurdles
> - Competition from larger firms
>
> ## Future prospects
> - Expansion into new markets
> - Adoption of new technologies
> - Strategic partnerships

### Why it's AI

LLMs, when asked to "write an article", produce this template-style conclusion because it satisfies the structural requirement of having such sections. Humans writing with intent produce actual analysis.

### Detection cues

- Generic challenge lists (could apply to anything)
- Generic future prospect lists
- No specific risks or opportunities named
- Bullets instead of analysis
- These sections appearing at the end of every AI-generated article

### Detection weight

**High** when this pattern appears. Very characteristic of AI.

---

## 7. Leads treating Wikipedia lists or broad article titles as proper nouns

**Pattern:** When writing a Wikipedia-style article, LLMs sometimes treat the article title as if it were a literal proper noun.

### Examples

> "The Festival (not to be confused with other festivals)..."

> "Throughout history, the Bridge has served as..."

The article isn't *the* festival or *the* bridge specifically; LLMs use the article title as if it referred to one specific thing.

### Detection cues

- Article title treated as the subject
- Unnecessary "The" capitalization
- Apologetic clarifications about which thing is meant

### Detection weight

**Low**. Mainly seen in AI attempts at Wikipedia-style articles.

---

## 8. "Featured in" / "Recognized by" / "Awarded" lists

**Pattern:** Long lists of minor awards, mentions, or features that don't establish notability.

### Examples

> "Awards and recognition:
> - Featured in Forbes 30 Under 30 (2019)
> - Profiled in Wired
> - Mentioned in The New York Times
> - Active social media presence
> - Keynote speaker at [conference]
> - Quoted in [publication]"

These are padded with low-bar mentions to look impressive.

### Detection cues

- Awards/recognition section in non-academic content
- Multiple "Featured in" mentions
- The list could be condensed to 1–2 substantive items
- Mixed with "active social media presence"

### Detection weight

**Medium**. Combined with attribution puffery → high.