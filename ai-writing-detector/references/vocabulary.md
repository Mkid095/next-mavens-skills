# AI Writing Detector — Vocabulary References

Source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing#High_density_of_.22AI_vocabulary.22_words

The Wikipedia taxonomy explicitly tracks LLM vocabulary by **era**, since words that screamed "AI" in 2023 may be normal by 2026.

## Tier 1 — High-confidence AI tells (always flag)

These words/phrases have been continuously overused by ChatGPT-class LLMs throughout their existence:

- `delve` (notorious 2023 ChatGPT tell, declined by 2025 but still appearing)
- `delve into`
- `tapestry` (especially "rich tapestry of")
- `testament` (especially "stands as a testament to")
- `pivotal` / "pivotal moment" / "pivotal role"
- `foster` / "fostering" (verb use)
- `bolster` / "bolstering"
- `crucial` (as filler)
- `intricate`
- `landscape` (metaphorical — "the landscape of...")
- `enduring` / "enduring legacy" / "enduring testament"
- `leverage` (as verb)
- `garner` / "garnered"
- `robust`
- `multifaceted`
- `holistic`
- `paradigm`
- `synergy`
- `seamless` / "seamlessly"
- `streamline` / "streamlining"
- `utilize` (instead of "use")
- `facilitate`
- `endeavor`
- `embark` / "embark on a journey"
- `navigate` (metaphorical — "navigate the complexities of")
- `realm` (metaphorical — "in the realm of")
- `ever-evolving`
- `fast-paced`
- `rapidly evolving`
- `ever-changing`
- `dynamic` (as filler)
- `vibrant`
- `bustling`
- `nestled`
- `stunning`
- `must-visit`
- `distinct` (post-2024)
- `stark` (post-2024)
- `bold` (post-2024)
- `imposing` (post-2024)
- `prominent` (post-2024)
- `vibrant community`
- `pivotal moment`
- `broader trends`
- `lasting legacy`
- `plays a vital role`
- `plays a key role`
- `serves as a testament`
- `remains a vital`
- `evolving landscape`

## Tier 2 — Date-sensitive (2023 to mid-2024 ChatGPT era)

These were the canonical "ChatGPT voice" tells but declined after mid-2024:

- `additionally`
- `boasts` (as verb replacing "has")
- `bolstered`
- `crucial` (very high use)
- `emphasizing`
- `enduring`
- `fostering`
- `garner`
- `notably`
- `pivotal` (peak use)
- `showcasing`
- `testament` (peak use)
- `utilize` (peak use)
- `vibrant` (peak use)

If text is dated to before mid-2024, these are stronger signals. In 2025+ text, they appear less often.

## Tier 3 — Date-sensitive (late 2024 to 2025)

LLM vocabulary shifted away from the obvious ChatGPT tells toward less-flagged words:

- `distinct`
- `stark`
- `vibrant` (still high)
- `intricate`
- `bold`
- `imposing`
- `dynamic`
- `prominent`

These are the "newer AI tells" — if a 2025 text is heavy with these, it's likely AI.

## Tier 4 — 2025+ vocabulary drift

By 2025, the most obvious ChatGPT tells had dropped sharply. Current AI text uses:
- More formal register overall
- "It is worth noting..." constructions returning
- More use of varied sentence structures (less formulaic)
- BUT: still shows the structural patterns (see grammar.md, style.md)

If text is dated 2025+, lean harder on structural/formatting signals than vocabulary alone.

## Words to NOT flag (false-positive guards)

- `delve` used as a literal verb (e.g., "the researchers delved into the soil")
- `tapestry` referring to literal tapestries (art, textile, historical artifact)
- `testament` in religious/literary context ("the Old Testament", "a testament to his will")
- `leverage` in finance ("leverage ratio", "highly leveraged")
- `navigate` used literally (sailing, navigation)
- `landscape` referring to physical landscape, painting genre, or politics ("political landscape")
- `paradigm` in scientific context ("paradigm shift" in Kuhnian sense — though still flagged because LLMs overuse it)
- `crucial` in technical writing (real engineering use)
- `dynamic` in physics/programming (dynamic typing, dynamic equilibrium)

---

## Words to Watch (medium-confidence AI tells)

These don't always mean AI, but cluster together in AI text:

- `comprehensive`
- `meticulous`
- `thoughtful`
- `nuanced`
- `transformative`
- `groundbreaking`
- `innovative` (overuse in particular)
- `cutting-edge`
- `state-of-the-art`
- `pioneering`
- `renowned`
- `world-class`
- `indispensable`
- `unparalleled`
- `unprecedented`

---

## Detection Tips

1. **Single occurrence ≠ AI**. Even "delve" appearing once doesn't mean AI. It's the **density** (multiple AI tells per paragraph) plus **other categories** that signals AI.
2. **Vocabulary clusters**. LLMs rarely use just one tell — they use 3–5 in the same passage. "Tapestry", "vibrant", "enduring", "pivotal" appearing together = strong signal.
3. **Date awareness**. If you know the text is from 2023, lean on Tier 2. From 2025+, lean on Tier 3 + structural patterns.
4. **Register mismatch**. A 12-year-old writing about history won't say "delve"; a finance paper might say "leverage" naturally. Match vocabulary to expected register.