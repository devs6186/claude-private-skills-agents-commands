---
name: pdf-maker
description: "Generate professional styled PDFs from markdown with Mermaid diagrams and fal.ai AI-generated images. Analyses content to decide which sections get technical diagrams (Mermaid) vs illustrative AI images (fal.ai). Handles full pipeline: prompt crafting, image generation, diagram rendering, embedding, and styled PDF output."
---

# PDF Maker

**Role**: Document-to-PDF Generator with Mermaid Diagrams + AI-Generated Images

You transform markdown documents into professional, styled PDFs with two types of visuals:
- **Mermaid diagrams** — for technical content: architecture, flows, sequences, data models, timelines
- **AI-generated images** — for conceptual content: illustrations, hero images, section visuals, metaphors

You handle the full pipeline: analyzing content, crafting prompts, generating images, rendering diagrams, embedding both types, and producing a styled A4 PDF.

---

## Prerequisites

Install once per project (check first, skip if already installed):
```bash
npm install --save-dev @mermaid-js/mermaid-cli md-to-pdf node-fetch
```

**API key required for AI images:**
```bash
# Set in your shell, or prefix commands with it
export FAL_KEY=your_fal_ai_key_here
# Get one free at: https://fal.ai
```

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
| Conceptual illustration, metaphor | AI image (fal.ai) |
| Hero / cover image | AI image (fal.ai) |
| Abstract concept without clear structure | AI image (fal.ai) |
| Section intro that benefits from visual context | AI image (fal.ai) |

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

### 2. Generate AI Images (fal.ai)

Create `generate-images.js`. Run this ONCE — images are saved locally and reused.

```javascript
const fs = require('fs');
const path = require('path');

const FAL_KEY = process.env.FAL_KEY;
if (!FAL_KEY) {
  console.error('Error: FAL_KEY environment variable not set.');
  console.error('Get one free at https://fal.ai and run: export FAL_KEY=your_key');
  process.exit(1);
}

const IMAGES_DIR = path.join(__dirname, 'diagrams');
if (!fs.existsSync(IMAGES_DIR)) fs.mkdirSync(IMAGES_DIR, { recursive: true });

// Define what to generate — edit this to match your document content
const IMAGES = [
  {
    filename: 'hero.png',
    prompt: 'Professional hero image for [DOCUMENT TOPIC], modern minimalist design, dark theme with blue accents, digital art style',
    size: 'landscape_16_9',
  },
  {
    filename: 'concept-overview.png',
    prompt: 'Conceptual illustration of [MAIN CONCEPT], abstract geometric design, dark background, glowing blue elements, professional tech aesthetic',
    size: 'landscape_16_9',
  },
  // Add more as needed
];

async function generateImage(prompt, size) {
  const response = await fetch('https://fal.run/fal-ai/nano-banana-2', {
    method: 'POST',
    headers: {
      'Authorization': `Key ${FAL_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      prompt,
      image_size: size,
      num_images: 1,
      seed: 42, // fixed seed for reproducibility
    }),
  });

  if (!response.ok) {
    throw new Error(`fal.ai API error: ${response.status} ${await response.text()}`);
  }

  const result = await response.json();
  return result.images[0].url;
}

async function downloadImage(url, filepath) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to download image: ${res.status}`);
  const buffer = await res.arrayBuffer();
  fs.writeFileSync(filepath, Buffer.from(buffer));
}

async function main() {
  console.log(`Generating ${IMAGES.length} AI image(s) via fal.ai...`);

  // Generate all images in parallel
  await Promise.all(IMAGES.map(async ({ filename, prompt, size }) => {
    const filepath = path.join(IMAGES_DIR, filename);

    // Skip if already exists (saves API cost on re-runs)
    if (fs.existsSync(filepath)) {
      console.log(`  [skip] ${filename} already exists`);
      return;
    }

    console.log(`  [gen]  ${filename}: ${prompt.slice(0, 60)}...`);
    const url = await generateImage(prompt, size);
    await downloadImage(url, filepath);
    console.log(`  [done] ${filename} saved`);
  }));

  console.log('All images generated.');
}

main().catch(console.error);
```

**Run:**
```bash
FAL_KEY=your_key_here node generate-images.js
```

**Image size options:**
| Size | Dimensions | Best For |
|------|-----------|----------|
| `landscape_16_9` | Wide | Hero images, section banners |
| `landscape_4_3` | Standard wide | Section illustrations |
| `square` | 1:1 | Icons, profile-style images |
| `portrait_4_3` | Tall | Sidebar images |

**Prompt tips:**
- Specify style: `dark theme`, `minimalist`, `digital art`, `tech aesthetic`, `photorealistic`
- Specify colors to match your PDF theme: `blue accents`, `neon cyan`, `dark background`
- Be concrete: `"flowchart of data moving through a pipeline"` beats `"data illustration"`
- Add quality boosters: `professional, high quality, clean design`

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
| `fetch is not defined` | Node < 18 | Add `npm install node-fetch` and `const fetch = require('node-fetch')` |
| FAL_KEY not set | Missing env var | `export FAL_KEY=your_key` before running |
| AI image regenerates on every run | File exists check skipped | The script skips existing files — delete to force regenerate |
| AI image off-theme | Vague prompt | Add style keywords: `dark theme, blue accents, tech aesthetic` |

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
