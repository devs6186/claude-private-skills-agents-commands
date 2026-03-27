---
name: hooks-automation
version: 1.0.0
description: |
  Claude Code hooks system for automating actions before/after tool use, on
  session start/end, and on prompt submission. Covers all hook types, shell
  command hooks, blocking vs non-blocking hooks, and practical automation patterns
  like auto-formatting, secret scanning, and session memory sync.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Hooks Automation

Claude Code hooks execute shell commands at specific lifecycle points, enabling automation that runs regardless of what Claude does.

---

## Hook Types

| Hook | When It Fires | Use For |
|------|--------------|---------|
| `PreToolUse` | Before any tool call | Block dangerous ops, log, validate |
| `PostToolUse` | After any tool call | Format code, run linters, sync |
| `UserPromptSubmit` | When user sends a message | Inject context, route to agents |
| `SessionStart` | On session initialization | Load memory, restore context |
| `SessionEnd` | On session close | Save state, backup |
| `Stop` | When Claude finishes responding | Sync, notify, cleanup |
| `PreCompact` | Before context compaction | Save session state |
| `SubagentStart` | When a subagent starts | Log, initialize context |
| `TaskCompleted` | When a task completes | Record outcome, train patterns |

---

## Hook Configuration (settings.json)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATHS\"",
            "timeout": 10000
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$CLAUDE_TOOL_INPUT\" | grep -E 'rm -rf|DROP TABLE|force-push' && exit 1 || exit 0",
            "timeout": 5000
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node ~/.claude/helpers/session-restore.js",
            "timeout": 15000
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node ~/.claude/helpers/sync-memory.js",
            "timeout": 10000
          }
        ]
      }
    ]
  }
}
```

---

## Environment Variables Available in Hooks

| Variable | Value |
|----------|-------|
| `$CLAUDE_TOOL_NAME` | Name of the tool being called |
| `$CLAUDE_TOOL_INPUT` | JSON input to the tool |
| `$CLAUDE_TOOL_OUTPUT` | JSON output from the tool (PostToolUse only) |
| `$CLAUDE_FILE_PATHS` | Space-separated paths of files modified |
| `$CLAUDE_PROJECT_DIR` | Root of the current project |
| `$CLAUDE_SESSION_ID` | Current session identifier |

---

## Practical Hook Patterns

### Auto-format on file write
```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "npx prettier --write \"$CLAUDE_FILE_PATHS\" 2>/dev/null || true"
    }]
  }]
}
```

### Block dangerous bash commands
```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "node -e \"const input = process.env.CLAUDE_TOOL_INPUT; const dangerous = ['rm -rf /', 'DROP TABLE', '--force']; if (dangerous.some(d => input.includes(d))) process.exit(1);\""
    }]
  }]
}
```

### Secret scanner on file write
```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "grep -rE '(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|AKIA[A-Z0-9]{16})' \"$CLAUDE_FILE_PATHS\" && echo 'SECRET DETECTED' && exit 1 || exit 0"
    }]
  }]
}
```

### Inject git status on prompt submit
```json
{
  "UserPromptSubmit": [{
    "hooks": [{
      "type": "command",
      "command": "echo \"Current git status: $(git status --short 2>/dev/null | head -10)\""
    }]
  }]
}
```

---

## Blocking vs Non-Blocking

- Hook exits with **code 0** → Claude continues normally
- Hook exits with **code 1** → Claude is blocked (PreToolUse) or error is reported (PostToolUse)
- Hook stdout → Injected into Claude's context as additional information
- Hook stderr → Shown as warning but does not block

Use blocking hooks for guardrails. Use non-blocking hooks for enrichment.

---

## Timeout Guidelines

| Hook Type | Recommended Timeout |
|-----------|-------------------|
| PreToolUse (validation) | 3–5 seconds |
| PostToolUse (formatting) | 10 seconds |
| SessionStart (restore) | 15 seconds |
| Stop (sync) | 10 seconds |
| UserPromptSubmit | 5 seconds |

Hooks that exceed their timeout are killed silently. Keep them fast.
