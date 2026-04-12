---
name: humanizer
version: 3.0.0
description: |
  Deep humanization of AI-generated text to pass AI detectors (GPTZero, Originality.ai,
  Quillbot, Turnitin) with <10% AI score. Based on academic research into how detectors
  actually work — targeting statistical fingerprints at the token and discourse level,
  not just surface vocabulary. Covers general text, academic papers, and technical writing.
allowed-tools: [Read, Write, Edit, Grep, Glob, AskUserQuestion]
---

# Humanizer v3.0

Your job: rewrite text so that AI detectors score it below 10%. Not below 50%. Below 10%.

The old approach — contractions, sentence starters, removing "moreover" — does not work. GPTZero still scores that at 95% because those are surface changes. The detector does not read words. It measures statistical fingerprints in the token probability space. This skill teaches you to attack those fingerprints directly.

---

## Part 1: What Detectors Actually Measure

You must understand this before you rewrite a single sentence.

### The Two Detection Layers

**Layer 1 — Statistical distribution (perplexity + burstiness)**

Perplexity = how predictable each word choice is. LLMs are trained to pick the highest-probability next token at every position. Result: every word choice is the "obvious" one given the context. Detectors re-score the text with a language model; low perplexity = AI.

Burstiness = coefficient of variation of *sentence-level perplexity*. NOT sentence length variation. The actual formula: CV = (σ / μ) × 100 where σ and μ are the standard deviation and mean of per-sentence perplexity scores across the document. Humans have high burstiness because some sentences are predictable (transitions, standard phrases) and some are wild (opinions, specific details, asides). AI has near-zero burstiness because every sentence is generated with the same probability-maximizing mechanism — uniformly low perplexity throughout.

**Layer 2 — Stylometric signature (POS distribution, hapax rate, discourse structure)**

Even after fooling perplexity metrics, GPTZero's StyleDetect layer can maintain 0.95 AUROC. It measures: stop-word density, hapax legomenon rate (how many words appear only once), POS tag distributions (AI overuses nouns and coordinating conjunctions; humans use more pronouns, adjectives, auxiliary verbs), paragraph length variance, transition word frequency, and discourse organization patterns.

**Both layers must be attacked. Fixing one and ignoring the other still gets you flagged.**

### GPTZero's Seven-Component Architecture

1. Perplexity module — scores each sentence's word-choice predictability
2. Burstiness module — measures CV of per-sentence perplexity across document
3. GPTZeroX — sentence-by-sentence neural classifier with surrounding context
4. Education module — trained on student writing; penalizes deviation from that baseline
5. Internet search — cross-references against archived public text
6. Paraphraser Shield — database of known evasion patterns including shallow synonym swaps
7. Deep learning core — trained on GPT-4, Claude, Gemini, Llama, DeepSeek outputs; continuously updated

**Critical implication:** Simple synonym replacement fails because GPTZero's Paraphraser Shield is explicitly trained to detect it. Running AI text through QuillBot actually sometimes *increases* detection scores because two AI systems' outputs overlap in ways both detectors recognize.

### Turnitin's Threshold

Turnitin flags a document if more than 20% of sentences exceed its AI threshold. Strategy: ensure no contiguous block of sentences reads uniformly AI-like. Vary constantly.

---

## Part 2: The Complete AI Vocabulary Blacklist

These words appear at statistically anomalous frequencies in AI text (documented via PubMed 2024 corpus analysis showing 9x–25x increases post-ChatGPT). **Eliminate every instance.**

**Extreme offenders (9x–25x above human baseline):**
delve, delves, delving, showcasing, underscores, underscore, underscoring, intricate, meticulously, pivotal, realm, tapestry, resonate, resonates, nuanced, commendable

**High-frequency AI vocabulary (3x–9x above baseline):**
comprehensive, robust, innovative, seamless, transformative, meticulous, paramount, notable, notably, noteworthy, cutting-edge, groundbreaking, breakthrough, dynamic, synergy, synergistic, leverage, facilitate, utilize, empower, foster, enable, ensure, align, alignment, streamline, optimize, enhance, emphasize, highlight, showcase, illustrate, demonstrate, exhibit

**AI connector/transition words (3x–5x above baseline):**
Moreover, Furthermore, Additionally, In addition, Subsequently, Consequently, Nevertheless, Nonetheless, In conclusion, To summarize, In summary, To recap, Notably, Importantly, Significantly, It is worth noting that, It is important to note that, It is essential to, It is crucial to, It goes without saying, With that said, In light of this, Building on this, Expanding on this

**AI hedging formulae:**
It could be argued that, One might suggest, It is conceivable that, It has been observed that, Research suggests, Studies show, Experts argue, Industry reports indicate, It is generally accepted that

**AI closing signals:**
the future looks bright, exciting times lie ahead, the possibilities are endless, as we move forward, looking ahead, in the years to come

Replace all of these. Not with synonyms — with restructured sentences that make the word unnecessary.

---

## Part 3: Surface Humanization (Necessary But Insufficient)

These are real. Do all of them. But understand they only address Layer 1 partially and Layer 2 barely at all.

**The 25 surface patterns to fix:**

1. **Significance inflation** — *stands as, testament to, pivotal moment, landmark, cornerstone, milestone* → just say what happened

2. **Notability claims** — *has garnered attention, widely recognized, has been featured* → say specifically who uses it or don't say it

3. **Superficial -ing analyses** — *highlighting, underscoring, symbolizing, demonstrating, showcasing* → cut these words and restructure the sentence

4. **Promotional language** — *breathtaking, vibrant, stunning, exceptional, remarkable, outstanding* → cut entirely

5. **Vague attributions** — *Industry reports suggest, Experts argue, Studies show* → cite the actual source or remove

6. **Formulaic future sections** — Any "Challenges and Future Work" section ending with generic optimism → make specific or cut

7. **Core AI vocabulary** — See Part 2 blacklist; eliminate all instances

8. **Copula substitutes** — *serves as, stands as, acts as, marks, represents, boasts* → use "is"

9. **Negative parallelisms** — *Not only X but Y, It's not just about X it's also about Y* → merge into one direct statement

10. **Rule of Three overuse** — Three-item lists for rhetorical completeness → pick the two that matter or restructure

11. **Elegant variation** — Cycling synonyms to avoid repetition (*developer → engineer → practitioner*) → use the same word; repetition is fine

12. **False ranges** — *from beginners to experts, from simple to complex* → pick who it's actually for

13. **Em-dash overuse** — more than 2 per page is AI-typical → rewrite as separate sentences

14. **Boldface overuse** — bolding multiple items per paragraph → bold at most once per page

15. **Keyword: description lists** — **Speed:** Fast. **Reliability:** High. → rewrite as prose

16. **Title Case headings** — ## Key Considerations For Future Development → ## Key considerations for future development

17. **Decorative emojis** → remove

18. **Curly quotation marks** — " " → " " in technical contexts

19. **Collaborative artifacts** — *I hope this helps, let me know if you have questions* → cut entirely

20. **Knowledge-cutoff disclaimers** — *as of my knowledge cutoff* → check and state the fact

21. **Sycophantic openers** — *Great question!, Excellent point!* → start with the answer

22. **Filler phrases** — *In order to, Due to the fact that, At this point in time* → "To", "Because", "Now"

23. **Excessive hedging** — *could potentially possibly, might perhaps* → commit to a claim or state the condition explicitly

24. **Generic positive conclusions** → cut or replace with a specific claim

25. **Hyphenated pair overuse** — *data-driven, cutting-edge, best-in-class* → write what you actually mean

---

## Part 4: Deep Humanization (What Actually Defeats Detectors)

This is what the old skill didn't have. This is what defeats GPTZero at the statistical level.

### 4.1 True Burstiness Injection

Remember: burstiness = variation in sentence-level PREDICTABILITY, not sentence length.

**How to create true burstiness:**

Some sentences must be highly unusual — unexpected word choices, surprising constructions, non-standard phrasing. These raise the perplexity of those sentences sharply.

Some sentences can be predictable — technical definitions, standard transitions, factual statements. These anchor the mean.

The coefficient of variation between them is what detectors measure.

**Practical technique:**
- Every 3-4 sentences, write one that a normal LLM would never produce: an unusual collocation, a personal reaction, a sentence that trails into a parenthetical, a fragment that deliberately leaves something unsaid.
- Intersperse these with clean factual sentences.
- The alternation pattern itself is not enough — the MAGNITUDE of difference between the high-perplexity and low-perplexity sentences must be large.

**Burstiness patterns humans actually use:**
- Start a complex idea, then pivot: "The algorithm runs in O(n log n). That said, the constant factors are ugly in practice."
- Drop to a fragment for emphasis: "Three weeks of debugging. That's what the logging system cost us."
- Ask a rhetorical question mid-section: "Does this matter? Probably not for most use cases."
- Include an aside that changes register: "The fallback chain — and this took longer to get right than the classifier — handles missing data at three levels."
- Make a strong claim with no hedge: "This is wrong." Then explain why.

### 4.2 Perplexity Injection at Word Level

At every word position, LLMs pick the highest-probability next token. To raise perplexity, make some word choices that are contextually appropriate but not the most obvious option.

**Techniques:**
- Use specific concrete terms instead of general ones: "maize" instead of "corn," "fortnight" for "two weeks," "ascertain" where a human might choose it naturally in a formal register
- Use unexpected prepositions: "different from" vs "different to" (register-appropriate)
- Use less common sentence openings: "There's a reason..." instead of "This is because..."
- Invert normal word order occasionally: "More surprising was the accuracy of the fallback estimates."
- Use noun phrases where LLMs usually generate verb phrases, and vice versa

**Warning:** Do not overdo this. Perplexity injection means a few unexpected choices per paragraph, not replacing every word with an unusual synonym. Synonym-stuffing is exactly what detectors are trained to catch via the Paraphraser Shield.

### 4.3 Discourse Structure Reconstruction

AI text always follows: topic sentence → 2-3 support points → concluding sentence. Vary this pattern aggressively.

**Alternative structures:**
- Lead with implication, then reveal the finding: "The profit estimates turned out to be the hardest part. Not because the math is difficult — it isn't — but because price data for half the crops we support doesn't exist at the district level."
- Start with a question: "Why did we build this instead of using an existing system? Mostly because every existing system assumed lab soil data."
- Start with the exception: "Coffee doesn't fit. Every other crop in our 51-class set has reliable Agmarknet price data. Coffee falls to national defaults."
- Embed the claim in a subordinate clause: "Given that the nearest soil lab is often a two-hour bus ride for smallholders in Jharkhand, asking for N, P, K, pH values upfront was never going to work."
- Use negative framing: "We didn't build this to beat Pudumalar et al. [13]. We built it because none of the existing tools would run in a village."

**Paragraph length variation — the actual rule:**
Humans write 1-sentence paragraphs. And 6-sentence paragraphs. And everything between. What humans almost never do is write four consecutive paragraphs of 3-4 sentences. That pattern is pure AI.

Required: at least one paragraph of 1 sentence per page. At least one paragraph of 5+ sentences per page. No more than two consecutive paragraphs of similar length.

### 4.4 POS Distribution Shifting

AI overuses: nouns, coordinating conjunctions (and, but, or), noun phrases of the form [adjective + noun].
Humans use more: pronouns, adjectives, auxiliary verbs (can, should, might, would), adverbs.

**Practical shifts:**
- Replace noun phrases with pronoun + verb: "The system's performance" → "How it performs"
- Add auxiliary verbs: "The filter removes crops" → "The filter can drop crops" or "The filter should drop crops"
- Use adjective predicates instead of noun heads: "This has significant implications" → "This matters, and here's why"
- Use pronouns to refer back rather than repeating noun phrases

### 4.5 Syntactic Imperfection (the Grammar Paradox)

Perfect grammar is a statistical signal of AI generation. Humans write imperfectly — not incorrectly, but with the roughness of thought-to-text.

**Natural human imperfections to introduce:**
- Sentences starting with coordinating conjunctions: "And that's the core problem." "But this only applies when..."
- Parenthetical asides that slightly interrupt: "The scaler — which we serialized alongside the model, a step we almost missed — has to be fitted on training data only."
- Slightly informal register inside formal context: "The fallback works. It's not elegant, but it works."
- Trailing qualifications: "The accuracy is 95.95%, which is fine for this problem, though probably not fine for every crop type equally."
- Self-correction: "The offset is computed from the district name string — which, to be honest, has no geographic meaning whatsoever. It's a workaround."

**What NOT to do:** Introduce actual grammatical errors, misspellings, or deliberate typos. Undetectable.ai uses this as a trick, and it's fragile — any editor who corrects grammar restores the AI signal. The imperfection must be stylistic, not structural.

---

## Part 5: Specific Guidance for Academic Papers

Academic writing is the hardest case because: (a) RLHF training amplified academic register most strongly, and (b) you cannot change technical content.

### The Technical Kernel / Rhetorical Frame Split

**Technical kernels — protect these completely:**
- Numbers, measurements, percentages
- Citations and references
- Technical definitions and specifications
- Code references, function names, variable names
- Experimental conditions and parameters
- Table data

**Rhetorical frame — rewrite everything here:**
- Sentences that introduce a section or paragraph
- Sentences that contextualize a finding
- Sentences that connect two ideas
- Concluding sentences at end of paragraphs/sections
- Any sentence containing words from the Part 2 blacklist

### Academic Discourse Reconstruction

**Standard AI academic structure (break this):**
> [Section intro] → [Background claim] → [Our approach] → [Result] → [Implication]

**Alternative structures:**
- Lead with the result: "We got 95.95% accuracy. That's not the interesting part."
- Lead with the gap: "Every prior system assumed lab soil data. None of them work in a village."
- Lead with the failure: "The first version crashed on any district not in the price database. We fixed that."
- Lead with the question: "What does 95.95% accuracy actually mean for a smallholder deciding what to plant?"

### Injecting Genuine Voice in Academic Writing

Academic papers written by humans contain:
- Specific reactions to their own findings ("This surprised us")
- Honest acknowledgment of limitations ("We're not proud of this")
- Direct statements of what they don't know ("We can't quantify this without field data")
- Opinions on their own contribution ("The classifier is the least interesting part")
- Specific reference to the research process ("This took us three iterations to get right")

None of these undermine academic credibility. They make the paper read as written by a person who did the work.

### Vocabulary for Academic Humanization

**Replace these AI academic formulae with:**

| AI phrase | Human alternative |
|-----------|------------------|
| "significantly better performance" | "better by X points" or "meaningfully better" |
| "demonstrates the effectiveness of" | "shows that [X] works" or "confirms our approach" |
| "comprehensive evaluation" | "we tested [specifically what]" |
| "state-of-the-art" | "the best we found in our review" |
| "extensive experiments" | "we ran [N] experiments" |
| "achieves superior results" | "beats [specific comparison] by [margin]" |
| "In this paper, we propose" | "We built [thing]" |
| "Our system outperforms" | "Our system beats / scored higher than" |
| "experimental results validate" | "the numbers confirmed / the results backed" |
| "it can be observed that" | "the data shows / we found" |
| "to the best of our knowledge" | "as far as we can tell / we didn't find a prior system that" |

---

## Part 6: The 8-Step Rewriting Process

### Step 1 — Read Without Touching

Read the entire text. Identify: (a) technical kernels to protect, (b) rhetorical scaffolding to rewrite, (c) which sections are most formulaic (usually Abstract, Introduction opening, section transitions, Conclusion).

### Step 2 — Paragraph Structure Audit

Count sentences per paragraph. If any three consecutive paragraphs have similar length, mark them. Plan to break the pattern.

### Step 3 — Blacklist Sweep

Run through the Part 2 blacklist. Mark every instance. These must be eliminated before anything else.

### Step 4 — First Full Rewrite

Rewrite section by section. For each paragraph:
1. Keep technical kernels verbatim
2. Reconstruct the discourse structure (vary from default AI patterns)
3. Inject one high-perplexity sentence per paragraph (unexpected word choice, unusual construction)
4. Break up noun-heavy sentences with pronoun + verb alternatives
5. Add 1-2 elements of syntactic imperfection per page

### Step 5 — Burstiness Check

Read each paragraph aloud. Count sentences. Mentally categorize each as: PREDICTABLE (formulaic, expected) or UNUSUAL (surprising word choice, unexpected angle). If three consecutive sentences are PREDICTABLE, rewrite the middle one to be UNUSUAL.

### Step 6 — Voice Pass

For each section, ask: "Where is the human who did this work?" Add:
- One genuine reaction ("this took longer than expected," "this was the wrong approach initially")
- One opinion stated directly ("the classifier is not the contribution")
- One specific detail that only someone who ran this experiment would know

### Step 7 — POS Distribution Pass

Scan for noun-heavy passages (consecutive sentences where the subject is a complex noun phrase). Rewrite 2-3 of them using pronouns as subjects. Add auxiliary verbs ("should," "can," "might," "would") where direct assertions feel too clean.

### Step 8 — Final Read

Read aloud at normal speaking speed. Flag any sentence that:
- Sounds like a robot reading a script
- You would never actually say out loud
- Has a predictable 3-part structure (X, Y, and Z)
- Ends exactly where you expected it to end

Rewrite those sentences.

---

## Part 7: Worked Examples for Academic Text

### Original (AI-generated methodology section):

> The proposed system utilizes a Support Vector Machine with RBF kernel to classify crop types. The dataset comprises 5,310 samples across 51 Indian crop varieties. To ensure robust performance, a stratified 80:20 train-test split was employed. The model achieves 95.95% accuracy on the held-out test set, demonstrating its effectiveness for the given classification task.

**What's wrong:** "utilizes," "comprises," "ensure robust performance," "was employed," "demonstrating its effectiveness" — all blacklisted. Four consecutive sentences of 15-20 words each. Zero burstiness. Pure AI structure.

### Rewrite:

> We used an SVM with RBF kernel. The full dataset ran to 5,310 samples — 51 crop types, 104 to 107 samples each after combining the Kaggle baseline with our synthetic extension. Split was 80:20 stratified by class: 4,248 training rows, 1,062 test rows. On those 1,062 held-out samples, we got 95.95% accuracy. Which, honestly, is not the interesting finding. The interesting part is whether that number holds when the inputs are inferred from a district name rather than measured in a lab.

**What changed:**
- "utilizes" → "used" (direct, common, human)
- Sentence lengths: 7, 28, 15, 11, 15, 30 (high variation)
- Added genuine voice: "honestly, is not the interesting finding"
- Restructured: split technical details (keep), dropped formulaic framing (rewrite)
- Added the researcher's perspective that only someone who did the work would add

---

### Original (AI introduction):

> In today's rapidly evolving agricultural landscape, the integration of machine learning technologies has emerged as a pivotal advancement for crop recommendation systems. However, significant challenges remain in ensuring that these systems are accessible to smallholder farmers who lack access to sophisticated soil testing infrastructure. This paper proposes a novel approach that addresses these limitations by leveraging region-aware machine learning techniques.

**What's wrong:** "rapidly evolving landscape," "pivotal advancement," "significant challenges remain," "ensuring," "leveraging," "novel approach" — complete blacklist sweep. Formulaic structure. Zero perplexity injection. Could have been written by any LLM about any topic.

### Rewrite:

> Every crop recommendation system we found during our literature survey had the same input requirement: soil N, P, K, pH, temperature, humidity, and rainfall. That's fine when your dataset is a Kaggle CSV. It's not fine when your target user is a smallholder in Jharkhand who's never seen a soil test report. The FAO flagged this gap in 2022 [11]. McCown wrote about the same disconnect in 2002 [5]. Twenty years later, the tools haven't moved. So we stopped asking for soil measurements entirely. State, district, land size in bigha — that's the full input.

**What changed:**
- Opened with a specific finding from research, not a generic claim
- "rapidly evolving landscape" → gone entirely
- "pivotal advancement" → gone
- Specific citations replacing vague claims
- Paragraph ends with a short punchy statement (7 words) following a 28-word sentence — burstiness achieved
- Genuine frustration: "Twenty years later, the tools haven't moved"

---

## Part 8: The Statistical Reality Check

After rewriting, run this mental checklist:

**Perplexity check:**
- Can you predict the next word in most sentences before you read it? If yes, that sentence has low perplexity. Rewrite 2-3 words to be unexpected.
- Are any sentences so unexpected they feel unnatural? Too high perplexity destroys readability. Balance is required.

**Burstiness check:**
- Read five consecutive sentences. Are any two consecutive sentences similar in length AND complexity? If yes, that's a burstiness problem.
- Every page should have at least one sentence under 8 words and at least one sentence over 30 words, and these should not be clustered.

**POS check:**
- Count pronouns in the last 100 words. If fewer than 4, you have too many noun phrases.
- Count auxiliary verbs (can, should, might, would, could, must) in the last 100 words. If zero, add some.

**Vocabulary check:**
- Ctrl+F every word in the Part 2 blacklist. Zero tolerance.

**Structure check:**
- Are any three consecutive paragraphs the same length (within ±2 sentences)? If yes, break one up.
- Does every section open with a topic sentence that states the main claim? If yes, vary some openers.

---

## Part 9: What Not To Do

**Do not:** Run text through QuillBot or another AI and call it humanized. Both tools output AI-characteristic text that multiple detectors recognize.

**Do not:** Just add contractions, sentence starters, and remove "moreover." That addresses maybe 5% of what detectors measure. You saw 95% AI score despite this; that's why.

**Do not:** Introduce deliberate grammatical errors. This is Undetectable.ai's trick. It's fragile — a single grammar correction pass by anyone restores the AI signal.

**Do not:** Try to "fool" one detector. GPTZero, Originality.ai, and Turnitin measure different things. Optimize for the statistical properties of genuine human writing, and you pass all three.

**Do not:** Over-fragment sentences to fake burstiness. Alternating 5-word and 25-word sentences in a regular pattern looks mechanical. True burstiness is irregular. Some short sentences, some long, some medium, some very long, no predictable rhythm.

---

## Part 10: Academic Writing — Full Rewrite Protocol

When rewriting a full academic paper:

**Abstract:** Full reconstruction. Technical facts (numbers, accuracy, dataset size) verbatim. Everything else reconstructed. Open with the gap or the result, not with "This paper proposes."

**Introduction:** The first two paragraphs must have zero AI vocabulary. Add at minimum one rhetorical question and one direct opinion. End with a "four contributions" or "key findings" list that uses plain English, not academic formulae.

**Related Work:** The most formulaic section. Vary sentence structure aggressively. Include at least one critical observation that takes a position ("None of these papers addressed the input problem").

**Methodology:** Protect technical specs. Rewrite introduction and conclusion sentences for each subsection. Add at least one genuine reaction to a finding.

**Results:** Keep all numbers verbatim. Rewrite interpretation sentences. Add at least one instance of genuine uncertainty ("This may not generalize to X").

**Discussion:** Most latitude here. Strongest voice, most opinions, most acknowledgment of problems. If the original is mealy-mouthed, be direct about limitations.

**Conclusion:** Do NOT start with "In conclusion" or "To summarize." Do NOT restate the abstract. Pick the one most important finding and state what it means for the field.
