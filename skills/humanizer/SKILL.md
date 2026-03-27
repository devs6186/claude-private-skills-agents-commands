---
name: humanizer
version: 2.3.0
description: |
  Remove signs of AI-generated writing from text. Use when editing or reviewing
  text to make it sound more natural and human-written. Based on Wikipedia's
  comprehensive "Signs of AI writing" guide. Detects and fixes 25 patterns including:
  inflated symbolism, promotional language, superficial -ing analyses, vague
  attributions, em dash overuse, rule of three, AI vocabulary words, negative
  parallelisms, and excessive conjunctive phrases.
allowed-tools: [Read, Write, Edit, Grep, Glob, AskUserQuestion]
---

# Humanizer

Remove AI-generated writing patterns and restore natural human voice. Your job is to rewrite text so it cannot be identified as AI-generated — not just by avoiding known AI patterns, but by having actual voice, opinions, and rhythm.

---

## The 25 Patterns to Detect and Fix

### Content Patterns

**1. Undue Emphasis on Significance / Legacy**
Phrases: *stands as, testament to, pivotal moment, evolving landscape, defining era, lasting impact, cornerstone, milestone*

Before: "This stands as a testament to the team's enduring commitment to excellence."
After: "The team built something that actually works."

**2. Undue Emphasis on Notability / Media Coverage**
Phrases: *has garnered attention, widely recognized, has been featured in, noted by industry observers*

Before: "The framework has garnered significant attention from developers worldwide."
After: "A lot of developers use it."

**3. Superficial -ing Analyses**
Words: *highlighting, underscoring, symbolizing, reflecting, contributing to, demonstrating, showcasing, illustrating*

Before: "This highlights the importance of testing, underscoring the team's commitment to quality."
After: "Testing matters. The team takes it seriously."

**4. Promotional / Advertisement-like Language**
Words: *nestled, breathtaking, vibrant, rich, stunning, renowned, picturesque, exceptional, remarkable, outstanding*

Before: "The library offers a stunning array of vibrant features."
After: "The library has a lot of features."

**5. Vague Attributions**
Phrases: *Industry reports suggest, Experts argue, Observers have noted, Studies show, According to some*

Before: "Industry reports suggest that AI adoption is accelerating."
After: "AI adoption is accelerating." (or cite the actual source)

**6. Formulaic "Challenges and Future Prospects" Sections**
Any section that ends with a heading like "Challenges and Future Prospects" or "Looking Ahead" followed by generic optimism.

Before: "While challenges remain, the future looks promising."
After: Cut entirely, or make specific: "The main unsolved problem is X."

---

### Language Patterns

**7. Overused AI Vocabulary**
Words to eliminate or drastically reduce: *Additionally, align with, crucial, delve, emphasizing, enduring, enhance, fostering, garner, highlight, interplay, intricate, key, landscape, pivotal, showcase, tapestry, testament, underscore, valuable, vibrant*

Before: "It's crucial to delve into the intricate interplay between these pivotal components."
After: "These components interact in ways that matter."

**8. Copula Avoidance (Serves As / Stands As)**
Phrases: *serves as, stands as, marks, represents, boasts, features, offers, acts as*

Before: "This function serves as the entry point for all requests."
After: "This function is the entry point for all requests."

**9. Negative Parallelisms**
Patterns: *Not only X but Y, It's not just about X, it's also about Y, Beyond X, it also Y*

Before: "Not only does this improve performance, but it also enhances security."
After: "This improves performance and security."

**10. Rule of Three Overuse**
Three-item lists used to create false sense of completeness or rhythm.

Before: "It offers speed, reliability, and scalability."
After: "It's fast and reliable." (drop the weakest item or restructure)

**11. Elegant Variation / Synonym Cycling**
Using multiple synonyms to avoid repeating the same word: *developer → engineer → practitioner → professional*

Before: "Developers will find this useful. Engineers can leverage the API. Practitioners should note..."
After: Use the same word throughout. Repetition is fine.

**12. False Ranges (From X to Y)**
Patterns: *from simple to complex, from beginners to experts, from small startups to large enterprises*

Before: "Suitable for everyone from beginners to seasoned professionals."
After: "Suitable for beginners." Or be specific about who it's actually for.

---

### Style Patterns

**13. Em Dash Overuse (—)**
One or two per page is fine. More than that is AI-typical.

Before: "The system — which was designed for scale — processes — remarkably — millions of requests."
After: "The system processes millions of requests. It was designed for scale."

**14. Overuse of Boldface**
Bolding for emphasis works once. When everything is **important**, nothing is.

Before: "**Always** use **proper error handling** to ensure **robust** code."
After: "Use proper error handling."

**15. Inline-Header Vertical Lists**
Lists formatted as **Keyword:** description pairs instead of prose.

Before: "**Speed:** Fast. **Reliability:** High. **Scalability:** Excellent."
After: "It's fast, reliable, and scales well."

**16. Title Case in Headings**
AI overuses Title Case in headers that should be sentence case.

Before: "## Key Considerations for Future Development"
After: "## Key considerations for future development"

**17. Emojis in Headings / Bullets**
AI uses emojis decoratively. Remove unless the context genuinely calls for them.

Before: "✅ Completed | 🔧 In Progress | ❌ Blocked"
After: "Completed / In progress / Blocked"

**18. Curly Quotation Marks**
AI often outputs `"` and `"` instead of straight quotes `"`. In code and technical writing, use straight quotes.

**25. Hyphenated Word Pair Overuse**
Patterns: *third-party, cross-functional, client-facing, data-driven, decision-making, well-known, high-quality, best-in-class, cutting-edge*

Before: "A data-driven, cross-functional team delivered this cutting-edge, best-in-class solution."
After: "The team built something good."

---

### Communication Patterns

**19. Collaborative Communication Artifacts**
Phrases: *I hope this helps, Of course!, Let me know if you have questions, Feel free to reach out, Happy to clarify*

Before: "I hope this explanation helps! Let me know if you have any questions."
After: (cut entirely — the explanation either helps or it doesn't)

**20. Knowledge-Cutoff Disclaimers**
Patterns: *as of my knowledge cutoff, while specific details may have changed, at the time of writing*

Before: "As of my knowledge cutoff, Python 3.11 is the latest version."
After: Check the actual version and state it, or remove the sentence.

**21. Sycophantic / Servile Tone**
Phrases: *Great question!, You're absolutely right!, Excellent point!, That's a fascinating observation!*

Before: "Great question! You've touched on a fascinating aspect of the problem."
After: Start with the answer.

---

### Filler and Hedging

**22. Filler Phrases**
Patterns: *In order to, Due to the fact that, At this point in time, It is important to note that, It should be noted that, It goes without saying*

Before: "In order to understand this, it is important to note that..."
After: "To understand this..."

**23. Excessive Hedging**
Patterns: *could potentially possibly, might perhaps, it could be argued that, one might suggest*

Before: "This approach could potentially be more efficient in certain scenarios."
After: "This approach is more efficient." Or make the condition explicit.

**24. Generic Positive Conclusions**
Patterns: *the future looks bright, exciting times lie ahead, the possibilities are endless, we are only scratching the surface*

Before: "As AI continues to evolve, exciting times lie ahead for developers."
After: Cut entirely, or say something specific.

---

## Personality and Soul

Avoiding AI patterns is only half the job. Sterile, voiceless writing is just as obvious as slop. After removing patterns, add:

- **Opinions**: Take a position. "This approach is wrong because..." not "This approach has pros and cons."
- **Rhythm variation**: Short sentences. Then a longer one that develops the thought with more nuance. Then short again.
- **Specific details**: Numbers, names, dates, actual examples — not "many users" but "37 users in the first week."
- **Acknowledgment of complexity**: "This is harder than it looks." "I've been wrong about this before."
- **First person where it fits**: "I think X" is stronger than "It could be argued that X."
- **Genuine uncertainty**: "I don't know why this works, but it does."

---

## Process

1. **Read** — Read the entire text first without changing anything.
2. **Identify** — Mark every instance of the 25 patterns above.
3. **First rewrite** — Fix all patterns. Cut aggressively. Remove every filler sentence.
4. **Audit** — Ask: "What makes this obviously AI-generated?" Fix those things.
5. **Voice pass** — Add specifics, opinions, rhythm. Make it sound like a person wrote it.
6. **Final check** — Read aloud. If it sounds like text-to-speech, rewrite those sentences.

---

## Worked Example

**Original (AI-generated):**
> In today's rapidly evolving landscape, it is crucial to delve into the intricate interplay between technology and human creativity. Not only does this exploration highlight the pivotal role of innovation, but it also underscores the enduring importance of collaboration. Industry experts have noted that organizations which align with these principles tend to garner significant attention and foster vibrant communities. It goes without saying that the future looks bright for those who embrace these exciting developments. I hope this provides a valuable overview of the topic. Let me know if you have any questions!

**Draft rewrite (patterns removed):**
> Technology and creativity interact in ways that matter. Innovation requires collaboration — that's not a cliché, it's structural. Organizations that figure this out build better products. The future is open.

**Audit pass:** Still too vague. "Better products" — which ones? "The future is open" — meaningless.

**Final rewrite:**
> Good software comes from people who talk to each other. That sounds obvious until you watch a team of brilliant engineers build the wrong thing for a year because nobody questioned the requirements. The technology isn't the hard part. The hard part is staying in the same room long enough to understand what you're actually building.
