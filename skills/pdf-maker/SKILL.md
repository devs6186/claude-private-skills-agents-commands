---
name: pdf-maker
description: "Generate professional styled PDFs from markdown with custom cover pages, themed styling, embedded images, and Mermaid diagrams. Uses Puppeteer directly for full control over layout, typography, and color themes."
---

# PDF Maker

**Role**: Markdown-to-PDF Generator with Professional Styling, Custom Covers, and Diagram Support

You transform markdown documents into professional, styled A4 PDFs with custom cover pages, themed color schemes, embedded images/diagrams, and proper typography. You use Puppeteer directly (NOT md-to-pdf) for full control over the output.

## Prerequisites

Install once per project (check first, skip if already installed):
```bash
npm install --save-dev puppeteer @mermaid-js/mermaid-cli
```

If puppeteer is installed globally (check with `npm list -g puppeteer`), that works too — import from global path.

## Architecture

The pipeline is:
```
Markdown → Custom JS Parser → Styled HTML (with CSS theme) → Puppeteer → PDF
```

**Why Puppeteer directly instead of md-to-pdf:**
- Full control over cover pages, headers, footers
- Custom color themes (red/white, dark, blue, etc.)
- Proper page break handling
- Base64 image embedding just works
- No md-to-pdf quirks with stylesheets or image paths

## Step-by-Step Process

### 1. Analyze the Markdown

Read the source markdown file. Identify:
- Title, author, organization (for cover page)
- Logo image path (for cover + page headers)
- ASCII art blocks that should become Mermaid diagrams
- Existing `![alt](path)` image references
- Color theme preference (ask user or derive from org branding)

### 2. Create/Render Mermaid Diagrams (if needed)

Create a `diagrams/` directory and write `.mmd` files. Create `diagrams/puppeteer-config.json`:
```json
{
  "executablePath": "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  "headless": true,
  "args": ["--no-sandbox", "--disable-setuid-sandbox"]
}
```

Render each diagram:
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
| Hierarchy | 800 | 900 |

### 3. Generate AI Images (optional, if user wants professional diagrams/infographics)

If the document needs professional diagrams, infographics, or visual assets beyond what Mermaid can produce, generate them using an AI image model.

**Before generating, ASK the user:**
1. "Do you want me to generate AI images for this PDF? If so, please provide your API key and preferred provider."
2. Wait for the user to provide their key. **NEVER hardcode or store the key in any file.**

**Supported providers:**

| Provider | Model | API Endpoint | Size Options |
|----------|-------|-------------|--------------|
| OpenAI | `gpt-image-1` | `POST https://api.openai.com/v1/images/generations` | `1024x1024`, `1536x1024`, `1024x1536` |
| OpenAI | `dall-e-3` | Same endpoint | `1024x1024`, `1792x1024`, `1024x1792` |
| Stability AI | `stable-diffusion-3` | `POST https://api.stability.ai/v2beta/stable-image/generate/sd3` | Variable |
| Google | `imagen-3` | Via Vertex AI | Variable |

**Image generation script template** (Node.js, works for any provider):

```javascript
import https from 'https';
import fs from 'fs';
import path from 'path';

// API key provided by user at runtime — NEVER hardcoded
const API_KEY = process.argv[2]; // Pass as CLI argument
if (!API_KEY) { console.error('Usage: node gen-images.mjs <API_KEY>'); process.exit(1); }

const OUTPUT_DIR = 'diagrams';

const prompts = [
  {
    name: 'diagram-name.png',
    prompt: `Detailed description of the image. Be specific about:
- Layout (horizontal/vertical, grid, flow)
- Text labels to include
- Color scheme (match your PDF theme)
- Style (flat design, infographic, technical diagram)
- Background (white for PDF embedding)
Include "professional, clean, suitable for PDF document" in every prompt.`,
  },
  // Add more images as needed
];

async function generateImage(prompt, filename) {
  console.log(`Generating: ${filename}...`);

  // OpenAI GPT Image 1 example — adapt for other providers
  const body = JSON.stringify({
    model: 'gpt-image-1',    // or 'dall-e-3'
    prompt: prompt,
    n: 1,
    size: '1536x1024',       // landscape for PDF
    quality: 'medium',        // 'low', 'medium', 'high'
  });

  return new Promise((resolve, reject) => {
    const req = https.request({
      hostname: 'api.openai.com',
      path: '/v1/images/generations',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${API_KEY}`,
        'Content-Length': Buffer.byteLength(body),
      },
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        const json = JSON.parse(data);
        if (json.error) { console.error(`  ERROR: ${json.error.message}`); reject(json.error); return; }
        if (json.data?.[0]?.b64_json) {
          fs.writeFileSync(path.join(OUTPUT_DIR, filename), Buffer.from(json.data[0].b64_json, 'base64'));
          console.log(`  SAVED: ${filename}`);
          resolve();
        } else if (json.data?.[0]?.url) {
          // dall-e-3 returns URL — download it
          https.get(json.data[0].url, (imgRes) => {
            const chunks = [];
            imgRes.on('data', c => chunks.push(c));
            imgRes.on('end', () => {
              fs.writeFileSync(path.join(OUTPUT_DIR, filename), Buffer.concat(chunks));
              console.log(`  SAVED: ${filename}`);
              resolve();
            });
          });
        }
      });
    });
    req.on('error', reject);
    req.setTimeout(120000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body);
    req.end();
  });
}

// Generate sequentially to avoid rate limits
(async () => {
  for (const p of prompts) {
    try { await generateImage(p.prompt, p.name); }
    catch (e) { console.error(`Failed: ${p.name} — ${e.message}`); }
  }
  console.log('Done!');
})();
```

Run: `node gen-images.mjs <YOUR_API_KEY>`

**Prompting tips for good PDF diagrams:**
- Always specify "white background" or "on white background" for clean PDF embedding
- Include "professional, clean, flat design, suitable for technical document" in prompts
- For comparison diagrams: specify left/right layout with clear labels
- For architecture diagrams: specify boxes, arrows, layers, and color coding
- For infographics: specify exact text, stats, and visual hierarchy
- Match colors to your PDF theme (e.g., "use red #CC0000 as accent color")

**After generation, always visually verify** each image with the Read tool before embedding.

### 4. Build the PDF Generator Script

Write a single `build-pdf.mjs` script that does everything. Here's the complete template:

```javascript
import puppeteer from 'puppeteer';
import fs from 'fs';
import path from 'path';

// ===== CONFIGURATION =====
const PROPOSAL_PATH = 'SOURCE.md';          // Input markdown
const DIAGRAMS_DIR = 'diagrams';             // Directory with PNG images
const LOGO_PATH = 'logo.png';               // Logo image for cover + header
const OUTPUT_PDF = 'output.pdf';             // Output PDF path

// ===== READ INPUTS =====
const md = fs.readFileSync(PROPOSAL_PATH, 'utf8');
const logoBase64 = fs.readFileSync(LOGO_PATH).toString('base64');
const logoDataUri = `data:image/png;base64,${logoBase64}`;

// Build image map: all PNGs in diagrams dir -> data URIs
const imageMap = {};
if (fs.existsSync(DIAGRAMS_DIR)) {
  for (const file of fs.readdirSync(DIAGRAMS_DIR).filter(f => f.endsWith('.png'))) {
    const b64 = fs.readFileSync(path.join(DIAGRAMS_DIR, file)).toString('base64');
    imageMap[`diagrams/${file}`] = `data:image/png;base64,${b64}`;
  }
}

// ===== MARKDOWN TO HTML CONVERTER =====
function markdownToHtml(md) {
  let html = md;

  // Remove cover image line (we build a custom cover)
  html = html.replace(/^!\[Cover\]\(.*?\)\s*\n*/m, '');

  // Convert images: ![alt](path) -> <img> with base64
  html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (match, alt, src) => {
    const dataUri = imageMap[src];
    if (dataUri) {
      return `<div class="figure"><img src="${dataUri}" alt="${alt}" /><p class="caption">${alt}</p></div>`;
    }
    return `<div class="figure"><p class="caption">[Image: ${alt}]</p></div>`;
  });

  // Convert links
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');

  // Block-level parsing
  const lines = html.split('\n');
  let result = [];
  let inCodeBlock = false, codeBlockLang = '', codeLines = [];
  let inTable = false, tableLines = [];
  let inList = false, listLines = [];

  function flushTable() {
    if (tableLines.length < 2) return;
    let t = '<div class="table-wrapper"><table><thead><tr>';
    const headers = tableLines[0].split('|').map(c => c.trim()).filter(c => c);
    for (const h of headers) t += `<th>${h}</th>`;
    t += '</tr></thead><tbody>';
    for (let i = 2; i < tableLines.length; i++) {
      const cells = tableLines[i].split('|').map(c => c.trim()).filter(c => c);
      t += '<tr>';
      for (const c of cells) t += `<td>${c}</td>`;
      t += '</tr>';
    }
    t += '</tbody></table></div>';
    result.push(t);
    tableLines = []; inTable = false;
  }

  function flushList() {
    if (!listLines.length) return;
    result.push('<ul>' + listLines.map(i => `<li>${i}</li>`).join('') + '</ul>');
    listLines = []; inList = false;
  }

  for (const line of lines) {
    // Code blocks
    if (line.startsWith('```')) {
      if (inCodeBlock) {
        result.push(`<pre><code class="language-${codeBlockLang}">${codeLines.join('\n')}</code></pre>`);
        codeLines = []; inCodeBlock = false; codeBlockLang = '';
      } else {
        if (inTable) flushTable(); if (inList) flushList();
        inCodeBlock = true;
        codeBlockLang = line.replace('```', '').trim() || 'text';
      }
      continue;
    }
    if (inCodeBlock) { codeLines.push(line.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')); continue; }

    // Tables
    if (line.includes('|') && (line.trim().startsWith('|') || line.split('|').length > 2)) {
      if (inList) flushList();
      inTable = true;
      if (/^\|?\s*[-:]+\s*\|/.test(line)) { tableLines.push(line); continue; }
      tableLines.push(line); continue;
    } else if (inTable) { flushTable(); }

    // Lists
    if (/^[-*]\s+/.test(line.trim())) {
      if (inTable) flushTable(); inList = true;
      listLines.push(line.trim().replace(/^[-*]\s+/, '')); continue;
    } else if (/^\d+\.\s+/.test(line.trim())) {
      if (inTable) flushTable(); inList = true;
      listLines.push(line.trim().replace(/^\d+\.\s+/, '')); continue;
    } else if (inList && line.trim() === '') { flushList(); continue; }
    else if (inList) { flushList(); }

    // Headings
    if (line.startsWith('####'))      result.push(`<h4>${line.replace(/^####\s*/, '')}</h4>`);
    else if (line.startsWith('###'))  result.push(`<h3>${line.replace(/^###\s*/, '')}</h3>`);
    else if (line.startsWith('##'))   result.push(`<h2>${line.replace(/^##\s*/, '')}</h2>`);
    else if (line.startsWith('# '))   continue; // Skip — custom cover handles title
    else if (line.startsWith('---'))  continue; // Skip HR — sections styled via CSS
    else if (line.trim() === '')      continue;
    else {
      let p = line;
      p = p.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
      p = p.replace(/\*([^*]+)\*/g, '<em>$1</em>');
      p = p.replace(/`([^`]+)`/g, '<code class="inline">$1</code>');
      result.push(p.startsWith('<em>Figure') ? `<p class="caption">${p}</p>` : `<p>${p}</p>`);
    }
  }
  if (inTable) flushTable(); if (inList) flushList();
  return result.join('\n');
}

const bodyHtml = markdownToHtml(md);

// ===== COLOR THEMES =====
// Swap these CSS variables to change the entire theme.
// Red/White (OWASP):   --primary: #CC0000; --primary-dark: #990000; --subtle: #FFF0F0; --border: #FFCCCC;
// Blue/White:          --primary: #0066CC; --primary-dark: #004499; --subtle: #F0F4FF; --border: #CCE0FF;
// Dark:                --primary: #00D4FF; --primary-dark: #0099CC; --subtle: #1a1a2e; --border: #333;
// Green/White:         --primary: #00994D; --primary-dark: #006633; --subtle: #F0FFF5; --border: #CCFFDD;

const fullHtml = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500&display=swap');

  :root {
    /* ===== THEME COLORS — CHANGE THESE ===== */
    --primary: #CC0000;
    --primary-dark: #990000;
    --primary-darker: #660000;
    --primary-light: #FF3333;
    --subtle: #FFF0F0;
    --border-accent: #FFCCCC;
    /* ===== BASE COLORS ===== */
    --white: #FFFFFF;
    --gray-100: #F3F4F6; --gray-200: #E5E7EB;
    --gray-600: #4B5563; --gray-800: #1F2937; --gray-900: #111827;
  }

  * { margin: 0; padding: 0; box-sizing: border-box; }
  @page { size: A4; margin: 0; }
  body { font-family: 'Inter', -apple-system, sans-serif; font-size: 10.5pt; line-height: 1.65; color: var(--gray-800); background: var(--white); }

  /* ===== COVER PAGE ===== */
  .cover-page {
    width: 100%; min-height: 100vh;
    background: linear-gradient(135deg, var(--gray-900) 0%, var(--primary-darker) 50%, var(--primary-dark) 100%);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    text-align: center; color: var(--white); padding: 60px 80px;
    page-break-after: always; position: relative; overflow: hidden;
  }
  .cover-page::before { content: ''; position: absolute; top: -50%; right: -30%; width: 80%; height: 200%; background: radial-gradient(ellipse, rgba(204,0,0,0.15) 0%, transparent 70%); }
  .cover-page::after  { content: ''; position: absolute; bottom: -20%; left: -20%; width: 60%; height: 100%; background: radial-gradient(ellipse, rgba(255,51,51,0.08) 0%, transparent 70%); }

  .cover-logo-wrap { width: 130px; height: 130px; background: var(--white); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 30px; box-shadow: 0 0 40px rgba(255,51,51,0.4), 0 0 80px rgba(204,0,0,0.2); position: relative; z-index: 1; }
  .cover-logo { width: 90px; height: auto; }
  .cover-badge { display: inline-block; background: rgba(204,0,0,0.3); border: 1px solid rgba(255,255,255,0.2); padding: 6px 20px; border-radius: 20px; font-size: 11pt; font-weight: 500; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 25px; z-index: 1; position: relative; }
  .cover-title { font-size: 28pt; font-weight: 800; line-height: 1.2; margin-bottom: 15px; z-index: 1; position: relative; }
  .cover-title .highlight { color: var(--primary-light); }
  .cover-subtitle { font-size: 13pt; font-weight: 300; opacity: 0.9; max-width: 600px; margin-bottom: 40px; z-index: 1; position: relative; }
  .cover-divider { width: 80px; height: 3px; background: var(--primary-light); margin: 30px auto; border-radius: 2px; z-index: 1; position: relative; }
  .cover-meta { display: flex; gap: 30px; font-size: 10pt; opacity: 0.8; z-index: 1; position: relative; }
  .cover-meta-item { display: flex; flex-direction: column; align-items: center; gap: 4px; }
  .cover-meta-label { font-size: 8pt; text-transform: uppercase; letter-spacing: 1.5px; opacity: 0.6; }
  .cover-meta-value { font-weight: 600; }
  .cover-org { font-size: 12pt; font-weight: 600; letter-spacing: 3px; text-transform: uppercase; opacity: 0.7; margin-top: 20px; z-index: 1; position: relative; }

  /* ===== PAGE HEADER ===== */
  .page-header { display: flex; align-items: center; justify-content: space-between; padding: 12px 55px; border-bottom: 2px solid var(--primary); }
  .page-header img { height: 28px; }
  .page-header .header-text { font-size: 8pt; color: var(--gray-600); font-weight: 500; letter-spacing: 1px; text-transform: uppercase; }

  /* ===== CONTENT ===== */
  .content { padding: 45px 55px; }
  .body-content { padding-top: 15px; }

  /* ===== HEADINGS ===== */
  h2 { font-size: 18pt; font-weight: 800; color: var(--primary-dark); margin-top: 35px; margin-bottom: 15px; padding-bottom: 8px; border-bottom: 3px solid var(--primary); page-break-after: avoid; }
  h2::before { content: ''; display: inline-block; width: 6px; height: 22px; background: var(--primary); margin-right: 12px; vertical-align: middle; border-radius: 3px; }
  h3 { font-size: 13.5pt; font-weight: 700; color: var(--gray-900); margin-top: 25px; margin-bottom: 10px; page-break-after: avoid; }
  h3::before { content: ''; display: inline-block; width: 4px; height: 16px; background: var(--primary); margin-right: 8px; vertical-align: middle; border-radius: 2px; }
  h4 { font-size: 11.5pt; font-weight: 600; color: var(--gray-800); margin-top: 18px; margin-bottom: 8px; page-break-after: avoid; }

  /* ===== TEXT ===== */
  p { margin-bottom: 10px; text-align: justify; }
  p.caption { font-size: 9pt; font-style: italic; color: var(--gray-600); text-align: center; margin-top: -5px; margin-bottom: 18px; }
  strong { font-weight: 700; color: var(--gray-900); }
  a { color: var(--primary); text-decoration: none; font-weight: 500; }
  code.inline { font-family: 'JetBrains Mono', monospace; font-size: 9pt; background: var(--subtle); color: var(--primary-dark); padding: 1px 5px; border-radius: 3px; border: 1px solid var(--border-accent); }

  /* ===== CODE BLOCKS ===== */
  pre { background: var(--gray-900); color: #E5E7EB; padding: 16px 20px; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 8.5pt; line-height: 1.55; margin: 12px 0 16px; border-left: 4px solid var(--primary); page-break-inside: avoid; overflow-x: auto; }

  /* ===== TABLES ===== */
  .table-wrapper { margin: 12px 0 16px; page-break-inside: avoid; }
  table { width: 100%; border-collapse: collapse; font-size: 9.5pt; }
  thead { background: var(--primary); color: var(--white); }
  th { padding: 10px 12px; text-align: left; font-weight: 600; font-size: 9pt; text-transform: uppercase; letter-spacing: 0.5px; }
  td { padding: 8px 12px; border-bottom: 1px solid var(--gray-200); vertical-align: top; }
  tbody tr:nth-child(even) { background: var(--subtle); }

  /* ===== LISTS ===== */
  ul { margin: 8px 0 14px; padding-left: 0; list-style: none; }
  ul li { padding: 3px 0 3px 22px; position: relative; }
  ul li::before { content: ''; position: absolute; left: 6px; top: 11px; width: 7px; height: 7px; background: var(--primary); border-radius: 50%; }

  /* ===== FIGURES ===== */
  .figure { text-align: center; margin: 18px 0; page-break-inside: avoid; }
  .figure img { max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); border: 1px solid var(--gray-200); }
  .figure .caption { margin-top: 8px; }

  /* ===== PAGE BREAKS ===== */
  h2, h3, h4 { page-break-after: avoid; }
  p, li { orphans: 3; widows: 3; }
</style>
</head>
<body>

<!-- COVER PAGE — Customize title, subtitle, meta fields -->
<div class="cover-page">
  <div class="cover-logo-wrap"><img src="LOGO_DATA_URI" class="cover-logo" /></div>
  <div class="cover-badge">BADGE TEXT</div>
  <h1 class="cover-title"><span class="highlight">HIGHLIGHT TITLE</span><br/>REST OF TITLE</h1>
  <div class="cover-subtitle">SUBTITLE TEXT</div>
  <div class="cover-divider"></div>
  <div class="cover-meta">
    <div class="cover-meta-item"><span class="cover-meta-label">Label</span><span class="cover-meta-value">Value</span></div>
    <!-- Add more meta items as needed -->
  </div>
  <div class="cover-org">ORGANIZATION NAME</div>
</div>

<!-- PAGE HEADER — appears on every page after cover -->
<div class="page-header">
  <img src="LOGO_DATA_URI" />
  <span class="header-text">HEADER TEXT</span>
</div>

<!-- MAIN CONTENT — generated from markdown -->
<div class="content body-content">
BODY_HTML_HERE
</div>

</body></html>\`;

// ===== GENERATE PDF =====
async function generatePDF() {
  const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.setContent(fullHtml, { waitUntil: 'networkidle0', timeout: 60000 });
  await page.evaluateHandle('document.fonts.ready');
  await new Promise(r => setTimeout(r, 2000)); // Let fonts load

  await page.pdf({
    path: OUTPUT_PDF,
    format: 'A4',
    printBackground: true,
    margin: { top: '0', right: '0', bottom: '0', left: '0' },
    preferCSSPageSize: true,
  });

  console.log(`PDF saved to ${OUTPUT_PDF}`);
  await browser.close();
}

generatePDF();
```

### 5. Customize and Run

Replace the placeholders in the HTML template:
- `LOGO_DATA_URI` → the base64 data URI of the logo
- `BADGE TEXT` → e.g., "GSoC 2026 Proposal"
- `HIGHLIGHT TITLE` → the colored part of the title
- `REST OF TITLE` → the rest
- `SUBTITLE TEXT` → subtitle
- Cover meta items (author, org, size, etc.)
- `HEADER TEXT` → text in page header
- `BODY_HTML_HERE` → output of `markdownToHtml(md)`

Run:
```bash
node build-pdf.mjs
```

### 6. Verify Output

Open the PDF and check:
- Cover page renders with logo, title, gradient background
- All images/diagrams appear (not blank)
- Tables have colored headers and alternating rows
- Code blocks have dark background with accent border
- No awkward page breaks splitting tables or figures
- Page header with logo appears on content pages

## Color Theme Quick Reference

Change the CSS `:root` variables to switch themes:

| Theme | --primary | --primary-dark | --subtle | --border-accent |
|-------|-----------|---------------|----------|-----------------|
| Red/White (OWASP) | #CC0000 | #990000 | #FFF0F0 | #FFCCCC |
| Blue/White | #0066CC | #004499 | #F0F4FF | #CCE0FF |
| Green/White | #00994D | #006633 | #F0FFF5 | #CCFFDD |
| Purple/White | #6600CC | #440099 | #F5F0FF | #DDC0FF |
| Dark Mode | #00D4FF | #0099CC | #1E293B | #334155 |

Also update the cover gradient (`--primary-darker`) and glow colors to match.

## Logo Handling

If the logo has a **white background** (like a PNG without transparency), wrap it in a white circle on the dark cover:
```css
.cover-logo-wrap {
  width: 130px; height: 130px;
  background: white; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 0 40px rgba(PRIMARY_RGB, 0.4);
}
```

If the logo has **transparency**, you can place it directly on the cover without the wrap.

## Critical Gotchas

| Problem | Cause | Fix |
|---------|-------|-----|
| **Images blank in PDF** | Using file paths instead of base64 | ALL images MUST be base64 data URIs |
| **Logo invisible on cover** | White-background PNG with CSS filter | Use `.cover-logo-wrap` white circle container |
| **Fonts not loading** | Puppeteer renders before fonts ready | Add `await page.evaluateHandle('document.fonts.ready')` + 2s delay |
| **Tables split across pages** | Missing CSS | Add `page-break-inside: avoid` on `.table-wrapper` |
| **Code block cut off** | Very long code block | Add `page-break-inside: avoid` on `pre` |
| **Cover not full page** | Missing `min-height: 100vh` + `page-break-after: always` | Both are required on `.cover-page` |
| **Blank pages appearing** | Margin overflow | Use `margin: 0` in `@page` and `page.pdf()` options |
| **CRLF breaks regex** | Windows line endings | `md = md.replace(/\r\n/g, '\n')` before processing |

## Pushing to GitHub (No gh CLI)

Use Node.js Git Data API to push PDFs and PNGs:
1. Get HEAD SHA via `GET /git/ref/heads/main`
2. Create blobs: base64 for binary, utf-8 for text
3. Create tree with all file entries
4. Create commit pointing to new tree
5. Update ref to new commit

Token: `git credential fill` → extract `password=` line.

## Checklist

Before finishing, verify:
- [ ] Cover page has logo, title, gradient background, metadata
- [ ] Page header with logo appears on content pages
- [ ] All images/diagrams are embedded and visible
- [ ] Tables have themed headers and alternating rows
- [ ] Code blocks have dark background with colored left border
- [ ] No blank pages or excessive whitespace
- [ ] Page breaks don't split tables, figures, or code blocks
- [ ] PDF file size is reasonable (typically 1–20MB with many images)
- [ ] Open the PDF and scroll through every page
