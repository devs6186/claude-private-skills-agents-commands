---
name: smart-explore
description: Token-optimized structural code search using tree-sitter AST parsing via claude-mem smart_* MCP tools. Use instead of reading full files when you need to understand code structure, find functions, or explore a codebase efficiently. 4-8x fewer tokens than Read.
metadata:
  author: devs6186+dev-os
  version: 1.0
  category: exploration
---

# Smart Explore

Structural code exploration using AST parsing. **This skill overrides your default exploration behavior.** While this skill is active, use smart_search/smart_outline/smart_unfold as your primary tools instead of Read, Grep, and Glob.

**Core principle:** Index first, fetch on demand. Give yourself a map of the code before loading implementation details.

## Your Next Tool Call

Your next action should be one of:

```
smart_search(query="<topic>", path="./src")    -- discover files + symbols across a directory
smart_outline(file_path="<file>")              -- structural skeleton of one file
smart_unfold(file_path="<file>", symbol_name="<name>")  -- full source of one symbol
```

Do NOT run Grep, Glob, Read, or find to discover files first. `smart_search` walks directories, parses all code files, and returns ranked symbols in one call.

## 3-Layer Workflow

### Step 1: Search -- Discover Files and Symbols

```
smart_search(query="shutdown", path="./src", max_results=15)
```

**Returns:** Ranked symbols with signatures, line numbers, match reasons, plus folded file views (~2-6k tokens)

**Parameters:**

- `query` (string, required) -- What to search for
- `path` (string) -- Root directory to search (defaults to cwd)
- `max_results` (number) -- Max matching symbols, default 20, max 50
- `file_pattern` (string, optional) -- Filter to specific files/paths

### Step 2: Outline -- Get File Structure

```
smart_outline(file_path="services/worker-service.ts")
```

**Returns:** Complete structural skeleton -- all functions, classes, methods, properties, imports (~1-2k tokens per file)

**Skip this step** when Step 1's folded file views already provide enough structure.

**Parameters:**

- `file_path` (string, required) -- Path to the file

### Step 3: Unfold -- See Implementation

```
smart_unfold(file_path="services/worker-service.ts", symbol_name="shutdown")
```

**Returns:** Full source code of the specified symbol (~400-2,100 tokens). AST node boundaries guarantee completeness.

**Parameters:**

- `file_path` (string, required) -- Path to the file
- `symbol_name` (string, required) -- Name of the function/class/method

## When to Use Standard Tools Instead

- **Grep:** Exact string/regex search
- **Read:** Small files under ~100 lines, non-code files (JSON, markdown, config)
- **Glob:** File path patterns
- **Explore agent:** When you need synthesized understanding across 6+ files, architecture narratives

For code files over ~100 lines, prefer smart_outline + smart_unfold over Read.

## Token Economics

| Approach | Tokens | Use Case |
|----------|--------|----------|
| smart_outline | ~1,000-2,000 | "What's in this file?" |
| smart_unfold | ~400-2,100 | "Show me this function" |
| smart_search | ~2,000-6,000 | "Find all X across the codebase" |
| search + unfold | ~3,000-8,000 | End-to-end find and read |
| Read (full file) | ~12,000+ | When you truly need everything |

**4-8x savings** on file understanding. **11-18x savings** on codebase exploration vs Explore agent.

## Supported Languages (24 bundled)

JS, TS, Python, Go, Rust, Ruby, Java, C, C++, Kotlin, Swift, PHP, Elixir, Lua, Scala, Bash, Haskell, Zig, CSS, SCSS, TOML, YAML, SQL, Markdown

## Prerequisites

Requires claude-mem plugin with smart_* MCP tools enabled.
