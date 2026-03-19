---
name: injection-detector
description: Detects injection vulnerabilities including SQL injection, XSS, command injection, SSTI, path traversal, and SSRF patterns in source code.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Injection Detector

## Objective

Identify code patterns where unsanitized user input flows into dangerous sinks, creating injection vulnerabilities across multiple attack classes.

## Workflow

**Step 1 — Identify input sources (taint sources)**
Map all locations where user-controlled data enters the application:
- HTTP request parameters: `req.query`, `req.body`, `req.params`, `request.GET`, `request.POST`
- URL path segments and query strings
- HTTP headers: `request.headers`, `req.headers`
- File uploads: file names, content
- WebSocket messages
- GraphQL arguments
- Database query results used as subsequent queries (second-order injection)
- Environment variables set from external sources
- CLI arguments in server-side scripts

**Step 2 — Identify dangerous sinks**
Map all dangerous execution points:

*SQL sinks:*
- String-concatenated SQL: `"SELECT * FROM users WHERE id = " + userId`
- Template literal SQL: `` `SELECT * FROM ${table} WHERE ${condition}` ``
- Raw query methods: `.raw()`, `.execute()`, `cursor.execute()`, `db.query()`

*XSS sinks:*
- `innerHTML`, `outerHTML`, `document.write()`
- `dangerouslySetInnerHTML` in React
- Unescaped template rendering: `{{ variable | safe }}`, `{{{ variable }}}`
- `eval()`, `Function()`, `setTimeout(string)`, `setInterval(string)`

*Command injection sinks:*
- `exec()`, `execSync()`, `spawn()`, `spawnSync()` with string concatenation
- `os.system()`, `subprocess.call()`, `subprocess.Popen()` with unsanitized input
- Shell pipe operators in string-built commands

*Path traversal sinks:*
- `fs.readFile()`, `fs.writeFile()`, `open()` with user-controlled paths
- `path.join()` with unsanitized input without normalization check
- File download/upload handlers without path sanitization

*SSRF sinks:*
- `fetch()`, `axios.get()`, `requests.get()` with user-controlled URLs
- HTTP client calls where the URL or host is derived from user input
- Webhook URL handlers without allowlist validation

*SSTI sinks:*
- `render_template_string()` in Flask with user input
- Jinja2/Twig/Handlebars template rendering with unsanitized variables
- `_.template()` in lodash with user input

*LDAP injection sinks:*
- LDAP query construction with string concatenation

*NoSQL injection sinks:*
- MongoDB `$where` with string input
- Object keys derived from user input in NoSQL queries

**Step 3 — Trace data flows (taint analysis)**
For each identified source:
- Follow the variable through assignments, function calls, and transformations
- Identify if the data reaches a dangerous sink without sanitization
- Check for sanitization functions between source and sink:
  - SQL: parameterized queries, prepared statements, ORM methods
  - XSS: `escapeHtml()`, `DOMPurify.sanitize()`, template auto-escaping
  - Command: `shellEscape()`, argument array usage instead of strings
  - Path: `path.resolve()` + allowlist check, `realpath()` validation
  - SSRF: URL allowlist, IP range blocking, hostname validation

**Step 4 — Classify each finding**
For each taint flow that reaches a sink without sanitization:
- Assign vulnerability class and CVE type
- Assess exploitability: direct (1-hop) vs. indirect (multi-hop)
- Estimate impact: data breach, RCE, authentication bypass, DoS

**Step 5 — Document attack payload examples**
For each finding, construct a representative attack payload to demonstrate exploitability.

## Output Format

```json
{
  "skill": "injection-detector",
  "summary": {
    "total_findings": 0,
    "sql_injection": 0,
    "xss": 0,
    "command_injection": 0,
    "path_traversal": 0,
    "ssrf": 0,
    "ssti": 0,
    "nosql_injection": 0,
    "ldap_injection": 0
  },
  "findings": [
    {
      "id": "INJ-001",
      "severity": "CRITICAL",
      "type": "sql_injection",
      "subtype": "string_concatenation",
      "file": "src/routes/users.js",
      "line_source": 24,
      "line_sink": 31,
      "source": "req.query.userId",
      "sink": "db.query(\"SELECT * FROM users WHERE id = \" + userId)",
      "sanitized": false,
      "sanitization_present": "none",
      "taint_path": [
        "req.query.userId → userId (line 24)",
        "userId → queryString (line 28)",
        "queryString → db.query() (line 31)"
      ],
      "attack_payload": "' OR '1'='1' -- ",
      "impact": "Authentication bypass, full table read, potential data exfiltration",
      "remediation": "Use parameterized queries: db.query('SELECT * FROM users WHERE id = ?', [userId])"
    }
  ]
}
```
