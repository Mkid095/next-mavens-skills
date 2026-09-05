---
name: human-writing
description: Generates content that does not sound like AI. Use when the user asks for any kind of content (about-us page, landing copy, blog post, docs, emails, captions, reports, descriptions, etc.) and wants it to read as naturally human-written. Loads the Wikipedia Signs of AI Writing taxonomy as guardrails and applies them while doing whatever task the user requested. Trigger phrases: "human-writing", "/human-writing", "write this like a human", "don't make it sound like AI", "make it not sound like AI".
disable-model-invocation: true
allowed-tools: Read Write Bash(powershell *)
---

# Human Writing — Apply the Wikipedia "Signs of AI Writing" taxonomy to whatever content the user asks for.

## How this skill works

Like ANPAS: this skill is invoked, loads its rules, and the AI agent then does whatever task the user asked for. The skill does not change the task — it changes **how** the agent writes.

Example: the user says "create an about-us page for our SaaS". Without this skill, the agent might write something like:

> "We are a vibrant team of innovators dedicated to fostering excellence and delivering cutting-edge solutions. Our journey stands as a testament to our commitment..."

With this skill invoked, the agent writes:

> "We've been building [product] since 2019. It started because [founder] couldn't find anything that did [problem] well. Today, [X] people use it daily, mostly small business owners in Kenya and Nigeria."

Same task. Different output. The second version reads as human because it has specifics, hedging, contractions, and no banned vocabulary.

---

## Workflow

### 1. Load the anti-AI taxonomy

Read in order:
- `~/.claude/skills/ai-writing-detector/SKILL.md` — the detection-side taxonomy
- `~/.claude/skills/ai-writing-detector/references/vocabulary.md` — banned words + allowed substitutes
- `~/.claude/skills/ai-writing-detector/references/grammar.md` — copulatives, negations, rule of three
- `~/.claude/skills/ai-writing-detector/references/style.md` — title case, bold, em dashes, emoji, tables, quotes
- `~/.claude/skills/ai-writing-detector/references/content.md` — puffery, attribution, superficial analysis, promotion
- `~/.claude/skills/ai-writing-detector/references/structural.md` — leads, outlines, hallucinated markup
- `~/.claude/skills/ai-writing-detector/references/ineffective.md` — false-positive guards

If the `ai-writing-detector` skill is missing, fall back to the inline cheat sheet in this file (see "Quick Reference" below).

### 2. Do whatever the user asked

The user's prompt is the task. Do that task. Apply the anti-AI rules as you write.

The task can be:
- Write a page (about, landing, pricing, features, contact, FAQ, docs)
- Write copy (tagline, headline, subheadline, CTA, social caption, email)
- Write a blog post / article / essay
- Write a report / proposal / pitch
- Write documentation / README / API docs
- Describe something (product, feature, person, place)
- Translate or rephrase existing content
- Any other writing task

The skill does NOT do:
- Image generation
- Code generation (use proper coding skills)
- Data analysis

### 3. Self-check before declaring done

After writing, scan the draft against the rules. Fix anything that fails:

| Category | What to verify |
|----------|----------------|
| Vocabulary | No banned words (delve, tapestry, testament, pivotal, leverage, utilize, facilitate, foster, bolster, vibrant, bustling, nestled, distinct, stark, prominent, multifaceted, robust, holistic, paradigm, synergy, seamless, streamline, ever-evolving, etc.) |
| Grammar | No copulatives replacing is/are (serves as, stands as, boasts, features, maintains, offers). No chained negation parallelisms. No formulaic rule-of-three. |
| Style | Sentence-case headings. Limited boldface. Em dashes ≤1 per 300 words. No emoji as bullets. Curly quotes only where appropriate. |
| Content | No significance puffery. No canned attribution ("active social media presence"). No superficial analysis. No vague attribution. Specifics present (dates, names, numbers). |
| Structural | No rigid lead formula. No "Challenges and Future Prospects" generic sections. No false balance. No hallucinated specifics. |

If anything fails, rewrite that sentence. Then re-check.

### 4. Report back

Tell the user what was written and where. If they asked for a file, write to that file. If they asked for content in chat, output the content directly.

Don't run the verification script automatically. The user can ask for verification with `--verify` if they want it (see Invocation below).

---

## Invocation

| Input | Action |
|-------|--------|
| `/human-writing` (no prompt) | Ask user what to write |
| `/human-writing <anything>` | Apply anti-AI rules to whatever the user asked |

That's it. No flags. No required parameters. The user just describes the task.

If the user wants verification after the fact:
- Run: `powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\ai-writing-detector\scripts\ai-vocab-scan.ps1" -FilePath <draft>`
- Report the score honestly

---

## Quick Reference (fallback if ai-writing-detector skill missing)

### Banned vocabulary (always)

`delve, tapestry, testament, pivotal, leverage, utilize, facilitate, foster, bolster, vibrant, bustling, nestled, stunning, must-visit, distinct, stark, bold, imposing, prominent, multifaceted, robust, holistic, paradigm, synergy, seamless, streamline, ever-evolving, fast-paced, rapidly evolving, ever-changing, dynamic, intricate, lasting legacy, plays a vital role, plays a key role, stands as a testament, rich tapestry, broader trends, broader landscape, evolving landscape, active social media presence`

### Allowed substitutes

| Banned | Use instead |
|--------|-------------|
| `delve into` | `look at`, `examine` |
| `leverage` | `use` |
| `utilize` | `use` |
| `facilitate` | `help` |
| `in order to` | `to` |
| `pivotal moment` | `important time`, `the year when` |
| `stands as a testament` | `shows`, `proves` |
| `tapestry` | `mix`, `combination` |
| `foster` | `encourage`, `support` |
| `vibrant` | `busy`, `active` |

### Banned grammar

- `serves as a` / `stands as a` / `functions as` / `boasts` / `features` / `maintains` / `offers` — replacing `is`/`are`/`has`
- Chained `not just X, but also Y` patterns
- Formulaic `X, Y, and Z` triples

### Banned style

- Title Case In Headings (use Sentence case)
- Bold for ordinary emphasis
- Inline-header lists (`- **Label:** description`)
- Em dash density >1 per 300 words
- Emoji as bullets (✨ 🔹 🎯)
- Curly quotes in code/data

### Banned content

- Significance without specifics
- "Featured in X, Y, Z" without specific articles
- "Maintains an active social media presence"
- "Experts say" without names
- "Challenges and future prospects" generic sections
- Promotional adjectives in non-marketing (vibrant, bustling, nestled, must-visit)

### Required

- Specific dates, names, numbers
- First person when appropriate
- Contractions in informal prose
- Vary sentence length deliberately
- Acknowledge uncertainty ("I don't know", "but maybe")
- Active voice for instructions

---



### No AI visual vocabulary in UI

ANPAS rule applies: **no AI-tell icons in any UI element**. These are the visual cues that scream "AI-generated website". Sparkle is the most recognizable — users immediately associate it with ChatGPT/Claude/Copilot output. Use Lucide icons or no icon.

**Forbidden standalone icons:**
- ✨ Sparkles (any variation)
- 🪄 Magic Wand
- ⚡ Lightning Bolt (when decorative, not action)
- ✦ Single Star / 4-point star
- ✨✨ Multiple Sparkles
- 🧠 Brain
- 🤖 Robot
- 🪐 Orb / Sphere
- ❤️ Heartbeat / 〰️ Pulse (as "AI active" indicator)
- 🖊️✨ Sparkly Pencil
- 🔍✨ Search + Sparkle
- 🎨✨ Image + Sparkle
- 🌐 Neural / Network nodes
- ◉ Glowing core / orb
- 🔥 Flame
- 🎯 Target (as AI-decoration)

**Forbidden visual styles (the "AI-generated website" look):**
- Purple / violet / indigo gradient backgrounds
- Blue-purple / pink-purple / cyan-purple gradients
- Glassmorphism cards (`rounded-2xl` + blur + semi-transparent)
- Pulsing glow, floating particles, shimmer effects
- Aurora backgrounds, blurred blobs

**Allowed approach (Google/AWS/Red Hat pattern):**
- Use **Lucide icons** for actual functionality
- Reserve ✨ **only for true AI features** — not decoration
- For "AI enhances X" patterns, use the standard icon with a small inline sparkle
- Define a fixed icon taxonomy — don't sprinkle AI icons everywhere

If a "new" or "special" indicator is needed, use a badge, label, or styling — not a sparkle icon.

## Honesty Section

This skill reduces AI tells significantly. It does not guarantee undetectable output:
- Wikipedia's own taxonomy is descriptive, not prescriptive
- Vocabulary shifts over time
- AI prompted with these rules can still produce subtle structural tells
- A piece can pass the detector and still be obviously AI to a careful human reader

The skill produces content that passes casual scanning and most automated detectors. For high-stakes contexts (academic submission, journalism, official publication), additional human review by an editor who hasn't seen the prompt is recommended.

Avoiding AI tells is not the same as good writing. Most AI tells are bad writing in general (superficial analysis, vague attribution, false balance). Avoiding them tends to improve quality. The goal is content that is specific, honest, varied, and useful — which happens to also not look like AI.