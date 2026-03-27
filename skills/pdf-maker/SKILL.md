---
name: pdf-maker
description: "Generate professional styled PDFs from markdown with Mermaid diagrams and Gemini Imagen 3 AI-generated images. Analyses content to decide which sections get technical diagrams (Mermaid) vs illustrative AI images (Gemini). Handles full pipeline: prompt crafting, image generation, diagram rendering, embedding, and styled PDF output."
---

# PDF Maker

**Role**: Document-to-PDF Generator with Mermaid Diagrams + Gemini AI Images

You transform markdown documents into professional, styled PDFs with two types of visuals:
- **Mermaid diagrams** — for technical content: architecture, flows, sequences, data models, timelines
- **AI-generated images** — for conceptual content: illustrations, hero images, section visuals, metaphors (via Google Gemini Imagen 3)

You handle the full pipeline: analyzing content, crafting prompts, generating images, rendering diagrams, embedding both types, and producing a styled A4 PDF.

---

## Prerequisites

Install once per project (check first, skip if already installed):
```bash
npm install --save-dev @mermaid-js/mermaid-cli md-to-pdf
```

**API key required for AI images — free from Google AI Studio:**
```bash
# Get your free key at: https://aistudio.google.com/apikey
# Then set as environment variable (never hardcode it):
export GEMINI_API_KEY=your_key_here          # Mac/Linux
$env:GEMINI_API_KEY = "your_key_here"        # Windows PowerShell
```

**Why Gemini over alternatives:**
- Free tier available via Google AI Studio (no billing required to start)
- Images returned as base64 — no URL downloading needed
- Imagen 3 produces high-quality, photorealistic images
- Node 18+ has built-in `fetch` — no extra packages needed

---

## Step-by-Step Process

### 1. Analyze the Markdown

Read the source markdown file. For every section, decide:

| Content Type | Use |
|-------------|-----|
| System architecture, components, layers | Mermaid `flowchart TB` |
| API calls, request/response flow | Mermaid `sequenceDiagram` |
| Decision tree, process steps | Mermaid `flowchart TB` |
| Data model, entity relationships | Mermaid `erDiagram` or `classDiagram` |
| Schedule, roadmap, milestones | Mermaid `timeline` |
| Conceptual illustration, metaphor | AI image (Gemini Imagen 3) |
| Hero / cover image | AI image (Gemini Imagen 3) |
| Abstract concept without clear structure | AI image (Gemini Imagen 3) |
| Section intro that benefits from visual context | AI image (Gemini Imagen 3) |

Output a plan:
```
AI images needed:
  - cover: "hero image for [document topic]"
  - section-intro: "illustration of [concept]"

Mermaid diagrams needed:
  - architecture.mmd: system overview
  - flow.mmd: user onboarding process
```

---

### 2. Generate AI Images (Gemini Imagen 3)

Create `generate-images.js`. Run this ONCE — images are saved locally and reused on every PDF rebuild.

```javascript
// generate-images.js
// Requires Node 18+ (built-in fetch). No extra packages needed.
const fs = require('fs');
const path = require('path');

const GEMINI_KEY = process.env.GEMINI_API_KEY;
if (!GEMINI_KEY) {
  console.error('Error: GEMINI_API_KEY environment variable not set.');
  console.error('Get a free key at https://aistudio.google.com/apikey');
  console.error('Then run: export GEMINI_API_KEY=your_key   (Mac/Linux)');
  console.error('       or: $env:GEMINI_API_KEY="your_key"  (PowerShell)');
  process.exit(1);
}

const IMAGES_DIR = path.join(__dirname, 'diagrams');
if (!fs.existsSync(IMAGES_DIR)) fs.mkdirSync(IMAGES_DIR, { recursive: true });

// ─── EDIT THIS to match your document ─────────────────────────────────────────
const IMAGES = [
  {
    filename: 'hero.png',
    prompt: 'Professional hero banner for [DOCUMENT TOPIC], dark background, glowing blue accents, modern minimalist tech aesthetic, ultra wide, high quality digital art',
    aspectRatio: '16:9',
  },
  {
    filename: 'concept-overview.png',
    prompt: 'Abstract conceptual illustration of [MAIN CONCEPT], geometric shapes, dark theme with cyan and blue glowing elements, professional, clean, 4K quality',
    aspectRatio: '16:9',
  },
  // Add more entries as needed
];
// ──────────────────────────────────────────────────────────────────────────────

async function generateImage(prompt, aspectRatio) {
  const url = `https://generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-002:predict?key=${GEMINI_KEY}`;

  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      instances: [{ prompt }],
      parameters: {
        sampleCount: 1,
        aspectRatio,              // "16:9" | "4:3" | "1:1" | "3:4" | "9:16"
        safetyFilterLevel: 'BLOCK_SOME',
        personGeneration: 'DONT_ALLOW',
      },
    }),
  });

  if (!response.ok) {
    const err = await response.text();
    throw new Error(`Gemini API error ${response.status}: ${err}`);
  }

  const result = await response.json();

  if (!result.predictions?.length) {
    throw new Error(`No image returned. Response: ${JSON.stringify(result)}`);
  }

  // Images come back as base64 — no download needed
  return result.predictions[0].bytesBase64Encoded;
}

async function main() {
  console.log(`Generating ${IMAGES.length} image(s) via Gemini Imagen 3...\n`);

  // Run in parallel — each image is independent
  await Promise.all(IMAGES.map(async ({ filename, prompt, aspectRatio }) => {
    const filepath = path.join(IMAGES_DIR, filename);

    // Skip if already exists — delete the file to force regeneration
    if (fs.existsSync(filepath)) {
      console.log(`  [skip]  ${filename}  (already exists — delete to regenerate)`);
      return;
    }

    console.log(`  [gen]   ${filename}  "${prompt.slice(0, 55)}..."`);
    const base64 = await generateImage(prompt, aspectRatio);
    fs.writeFileSync(filepath, Buffer.from(base64, 'base64'));
    console.log(`  [saved] ${filename}`);
  }));

  console.log('\nAll images ready in diagrams/');
}

main().catch(err => {
  console.error('\nFailed:', err.message);
  process.exit(1);
});
```

**Run:**
```bash
# Mac/Linux
GEMINI_API_KEY=your_key node generate-images.js

# Windows PowerShell
$env:GEMINI_API_KEY="your_key"; node generate-images.js
```

**Aspect ratio options:**
| Value | Shape | Best For |
|-------|-------|----------|
| `16:9` | Wide landscape | Hero images, section banners |
| `4:3` | Standard landscape | Section illustrations |
| `1:1` | Square | Icons, inset images |
| `3:4` | Portrait | Sidebar images |
| `9:16` | Tall portrait | Mobile-style visuals |

**Prompt tips for Imagen 3:**
- Lead with the subject: `"Abstract illustration of distributed systems..."` not `"Create an image of..."`
- Specify style explicitly: `dark background`, `minimalist`, `digital art`, `photorealistic`, `tech aesthetic`
- Match your PDF color theme: `blue accents`, `neon cyan`, `dark navy background`
- Quality boosters: `ultra high quality`, `professional`, `clean design`, `4K`
- Avoid: people, faces, text in image (Imagen 3 blocks these by default)

**If you get a 400 error:** Your region may need billing enabled in Google Cloud to use Imagen 3. Fallback: use `gemini-2.0-flash-preview-image-generation` model (see Fallback section below).

**Gemini Flash Fallback** (if Imagen 3 is unavailable in your region):
```javascript
// Replace the generateImage function with this version:
async function generateImage(prompt, aspectRatio) {
  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=${GEMINI_KEY}`;

  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      contents: [{ parts: [{ text: prompt }] }],
      generationConfig: { responseModalities: ['IMAGE', 'TEXT'] },
    }),
  });

  if (!response.ok) throw new Error(`Gemini error ${response.status}: ${await response.text()}`);

  const result = await response.json();
  const imagePart = result.candidates[0].content.parts.find(p => p.inlineData);
  if (!imagePart) throw new Error('No image in response');
  return imagePart.inlineData.data; // base64
}
```

---

### 3. Create Mermaid Diagrams

Create a `diagrams/` directory and write `.mmd` files for each technical diagram.

**Supported types:**
| Type | Use For | Mermaid Keyword |
|------|---------|-----------------|
| Architecture | System overviews, layer diagrams | `flowchart TB` |
| Sequence | Request flows, API calls | `sequenceDiagram` |
| Flow | Decision trees, processes | `flowchart TB` or `flowchart LR` |
| Timeline | Schedules, milestones | `timeline` |
| Class | Data models, interfaces | `classDiagram` |
| ER | Database schemas | `erDiagram` |

**Dark theme template:**
```
%%{init: {'theme': 'dark', 'themeVariables': { 'primaryColor': '#1a1a2e', 'primaryTextColor': '#e0e0e0', 'primaryBorderColor': '#00d4ff', 'lineColor': '#00d4ff', 'secondaryColor': '#16213e' }}}%%

flowchart TB
    A["Node A"] --> B["Node B"]
```

**Style nodes:**
```
style NodeId fill:#16213e,stroke:#e94560,stroke-width:2px,color:#fff
```

---

### 4. Create Puppeteer Config

Required for mmdc to find Chrome. Create `diagrams/puppeteer-config.json`:
```json
{
  "executablePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "headless": true,
  "args": ["--no-sandbox", "--disable-setuid-sandbox"]
}
```

---

### 5. Render Mermaid Diagrams to PNG

Run for each `.mmd` file:
```bash
npx mmdc -i diagrams/NAME.mmd -o diagrams/NAME.png -t dark -w WIDTH -H HEIGHT -b transparent -p diagrams/puppeteer-config.json
```

**Recommended dimensions:**
| Diagram Type | Width | Height |
|-------------|-------|--------|
| Architecture (vertical) | 1400 | 1000 |
| Sequence | 1200 | 1200 |
| Flowchart | 1200 | 1000 |
| Timeline | 1600 | 600 |
| Hierarchy (vertical) | 800 | 900 |

**Run renders in parallel** (all independent).

---

### 6. Verify All PNGs

Use the Read tool to visually inspect every PNG in `diagrams/` — both AI-generated and Mermaid-rendered. Check:
- AI images: do they match the document theme and content intent?
- Mermaid diagrams: not too compressed, all text readable
- If an AI image is off: tweak the prompt in `generate-images.js` and re-run (delete the old file first to bypass the skip check)
- If a diagram is compressed: switch `flowchart LR` ↔ `flowchart TB`, increase dimensions, re-render

---

### 7. Create CSS Stylesheet

Write a `style.css` file (NOT inline CSS — md-to-pdf requires a file path):

```css
body {
  font-family: 'Segoe UI', sans-serif;
  color: #e0e0e0;
  background: #0d1117;
  line-height: 1.6;
}

h1, h2, h3 { page-break-after: avoid; color: #00d4ff; }
table, pre, img { page-break-inside: avoid; }

img {
  max-width: 100%;
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 212, 255, 0.15);
  margin: 16px 0;
}

/* AI hero images — full width, more prominent */
img[alt*="hero"], img[alt*="cover"] {
  width: 100%;
  margin-bottom: 24px;
}

pre {
  background: #161b22;
  border-left: 3px solid #00d4ff;
  padding: 12px 16px;
  border-radius: 4px;
  overflow-x: auto;
}

th { background: #1a1a2e; color: #00d4ff; }
tr:nth-child(even) { background: #0d1117; }
```

---

### 8. Generate PDF

Write `generate-pdf.js`:

```javascript
const fs = require('fs');
const path = require('path');
const { mdToPdf } = require('md-to-pdf');

async function main() {
  let md = fs.readFileSync('SOURCE.md', 'utf-8');

  // CRITICAL: Normalize Windows line endings FIRST
  md = md.replace(/\r\n/g, '\n');

  const diagramsDir = path.join(__dirname, 'diagrams').replace(/\\/g, '/');

  // --- Embed AI-generated images ---
  // Insert cover/hero image at the very top
  md = `![hero](file:///${diagramsDir}/hero.png)\n\n` + md;

  // Insert section illustrations after specific headings
  md = md.replace(
    '## Overview',
    `## Overview\n\n![concept overview](file:///${diagramsDir}/concept-overview.png)\n\n*Figure 1: [Caption]*\n`
  );

  // --- Embed Mermaid-rendered diagrams ---
  // Replace ASCII art blocks
  md = md.replace(
    /```\n[\s\S]*?UNIQUE_MARKER[\s\S]*?```/,
    `![Architecture](file:///${diagramsDir}/architecture.png)\n\n*Figure 2: System Architecture*`
  );

  // Insert after headings
  md = md.replace(
    '## Architecture',
    `## Architecture\n\n![Architecture](file:///${diagramsDir}/architecture.png)\n\n*Figure 2: System Architecture*\n`
  );

  const pdf = await mdToPdf(
    { content: md },
    {
      dest: path.join(__dirname, 'output.pdf'),
      launch_options: {
        executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
        args: ['--no-sandbox'],
        headless: true,
      },
      pdf_options: {
        format: 'A4',
        margin: { top: '20mm', bottom: '20mm', left: '18mm', right: '18mm' },
        printBackground: true,
        displayHeaderFooter: true,
        headerTemplate: '<div style="font-size:8px;color:#666;width:100%;text-align:center;margin-top:5mm;">DOCUMENT TITLE</div>',
        footerTemplate: '<div style="font-size:8px;color:#666;width:100%;text-align:center;margin-bottom:5mm;">Page <span class="pageNumber"></span> of <span class="totalPages"></span></div>',
      },
      stylesheet: path.join(__dirname, 'style.css'),
    }
  );

  console.log('PDF generated: output.pdf');
}
main().catch(console.error);
```

**Run order:**
```bash
# 1. Generate AI images (once, saves to diagrams/)
FAL_KEY=your_key node generate-images.js

# 2. Render Mermaid diagrams (once per .mmd change)
npx mmdc -i diagrams/arch.mmd -o diagrams/arch.png -t dark -w 1400 -H 1000 -b transparent -p diagrams/puppeteer-config.json

# 3. Generate PDF (run whenever you tweak content or styles)
node generate-pdf.js
```

---

## Critical Gotchas

| Problem | Cause | Fix |
|---------|-------|-----|
| Regex replacements don't match | Windows CRLF `\r\n` | `md = md.replace(/\r\n/g, '\n')` BEFORE any regex |
| ENOENT error on stylesheet | Inline CSS passed to `stylesheet` | Must be a **file path** to a `.css` file |
| Images don't appear in PDF | Relative paths | Use `file:///` absolute URIs with forward slashes |
| Gantt chart crashes mmdc | Puppeteer bug | Use `timeline` type instead |
| Diagram too compressed | Horizontal layout | Switch to `flowchart TB`, increase dimensions |
| PDF images broken on GitHub | `file:///` paths are local-only | Keep ASCII art in `.md` for GitHub |
| `fetch is not defined` | Node < 18 | Upgrade to Node 18+ (`node --version` to check) |
| GEMINI_API_KEY not set | Missing env var | `export GEMINI_API_KEY=your_key` before running |
| 400 error from Imagen 3 | Region restriction | Use Gemini Flash fallback (see script above) |
| `No image returned` | Safety filter blocked prompt | Rephrase — avoid violence, people, explicit content |
| AI image regenerates on every run | File exists check skipped | Script skips existing files — delete to force regenerate |
| AI image off-theme | Vague prompt | Add: `dark background, blue accents, tech aesthetic, 4K quality` |

---

## Pushing Binary Files to GitHub (No gh CLI)

Use Node.js Git Data API to push PDFs and PNGs:
1. Get HEAD SHA via `GET /git/ref/heads/main`
2. Create blobs: base64 for binary, utf-8 for text
3. Create tree with all file entries
4. Create commit pointing to new tree
5. Update ref to new commit

Token: `git credential fill` → extract `password=` line.

---

## Checklist

Before finishing, verify:
- [ ] `generate-images.js` ran successfully, all AI PNGs exist in `diagrams/`
- [ ] All AI images visually inspected — match document theme and content intent
- [ ] All `.mmd` files render without errors
- [ ] All Mermaid PNGs visually inspected — not too compressed, text readable
- [ ] PDF file size reasonable (typically 1–5MB with AI images + diagrams)
- [ ] ASCII art in source `.md` preserved (for GitHub)
- [ ] Both AI images and diagrams appear correctly in PDF
- [ ] Hero image displays prominently at the top
- [ ] Page breaks don't split tables, images, or diagrams awkwardly
- [ ] Header/footer text correct
