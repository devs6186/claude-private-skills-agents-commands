#!/usr/bin/env node
/**
 * mem-bridge.js — Injects claude-mem memories into Copilot and Codex global files.
 * Run this at session start or on a schedule.
 * Usage: node mem-bridge.js [--copilot] [--codex] [--all]
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');

const WORKER_URL = 'http://localhost:37777';
const HOME = os.homedir();

const COPILOT_FILE = path.join(HOME, '.github', 'copilot-instructions.md');
const CODEX_AGENTS_FILE = path.join(HOME, '.codex', 'AGENTS.md');

const MEMORY_START = '<!-- claude-mem:start -->';
const MEMORY_END = '<!-- claude-mem:end -->';

function httpGet(url) {
  return new Promise((resolve, reject) => {
    http.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try { resolve(JSON.parse(data)); }
        catch { resolve(null); }
      });
    }).on('error', reject);
  });
}

async function fetchMemory() {
  try {
    // Check worker is up
    const health = await httpGet(`${WORKER_URL}/api/health`);
    if (!health || health.status !== 'ok') {
      console.log('[mem-bridge] Worker not running, skipping.');
      return null;
    }

    // Get recent observations summary (last 10)
    const obs = await httpGet(`${WORKER_URL}/api/observations?limit=10&orderBy=date_desc`);
    if (!obs || !obs.observations || obs.observations.length === 0) {
      console.log('[mem-bridge] No observations yet.');
      return null;
    }

    const lines = obs.observations.map(o => {
      const time = new Date(o.timestamp).toLocaleDateString();
      const project = o.project ? ` [${o.project}]` : '';
      return `- ${time}${project}: ${o.title}`;
    });

    return lines.join('\n');
  } catch (e) {
    console.log('[mem-bridge] Worker unavailable:', e.message);
    return null;
  }
}

function injectMemory(filePath, memoryText, label) {
  if (!fs.existsSync(filePath)) {
    console.log(`[mem-bridge] ${label} file not found: ${filePath}`);
    return;
  }

  let content = fs.readFileSync(filePath, 'utf8');

  const block = `${MEMORY_START}\n## Recent Memory (claude-mem auto-injected)\n\n${memoryText}\n\n*Updated: ${new Date().toISOString()}*\n${MEMORY_END}`;

  if (content.includes(MEMORY_START)) {
    // Replace existing block
    const regex = new RegExp(`${MEMORY_START}[\\s\\S]*?${MEMORY_END}`, 'g');
    content = content.replace(regex, block);
  } else {
    // Append at end
    content = content.trimEnd() + '\n\n' + block + '\n';
  }

  fs.writeFileSync(filePath, content, 'utf8');
  console.log(`[mem-bridge] Injected memory into ${label}`);
}

async function main() {
  const args = process.argv.slice(2);
  const doCopilot = args.includes('--copilot') || args.includes('--all') || args.length === 0;
  const doCodex = args.includes('--codex') || args.includes('--all') || args.length === 0;

  const memory = await fetchMemory();
  if (!memory) return;

  if (doCopilot) injectMemory(COPILOT_FILE, memory, 'Copilot');
  if (doCodex) injectMemory(CODEX_AGENTS_FILE, memory, 'Codex AGENTS.md');
}

main().catch(console.error);
