---
name: performance-analysis
version: 1.0.0
description: |
  Performance profiling and optimization patterns for web apps, APIs, and CLIs.
  Covers browser DevTools profiling, Node.js profiling, database query analysis,
  memory leak detection, bundle size analysis, and systematic optimization workflow.
  Always profile before optimizing.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Performance Analysis

Systematic profiling and optimization. Never optimize what you haven't measured.

---

## The Optimization Loop

```
1. MEASURE — Establish baseline with real data
2. PROFILE — Find the actual bottleneck (not what you think it is)
3. HYPOTHESIZE — Form a theory about why it's slow
4. OPTIMIZE — Make one change at a time
5. MEASURE — Verify the improvement
6. REPEAT — Until performance goal is met
```

Never skip step 1 or 5. The loop only works if you measure before and after.

---

## Node.js / Backend Profiling

### CPU Profile
```bash
# Built-in profiler
node --prof app.js
# Run load test, then:
node --prof-process isolate-*.log > profile.txt

# Using clinic.js
npm install -g clinic
clinic doctor -- node app.js
clinic flame -- node app.js   # flamegraph
```

### Memory Leak Detection
```bash
# Heap snapshot
node --inspect app.js
# Open chrome://inspect → Memory tab → Take heap snapshot
# Run operations → Take another snapshot → Compare

# Automatic leak detection
npm install -g clinic
clinic heapdump -- node app.js
```

### Event Loop Lag
```javascript
// Measure event loop lag
const start = Date.now()
setImmediate(() => {
  const lag = Date.now() - start
  console.log(`Event loop lag: ${lag}ms`)
})

// With prom-client
const eventLoopLag = new promClient.Gauge({
  name: 'nodejs_eventloop_lag_seconds',
  help: 'Event loop lag in seconds',
  collect() { /* measure */ }
})
```

---

## Database Query Analysis

### PostgreSQL EXPLAIN ANALYZE
```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT u.*, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.created_at > NOW() - INTERVAL '30 days'
GROUP BY u.id;

-- Look for:
-- "Seq Scan" on large tables → missing index
-- "Hash Join" with large batches → may need index
-- "Rows Removed by Filter" >> "Rows" → bad selectivity
-- Shared hit=0 → cold cache (acceptable on first run)
```

### Slow Query Log
```sql
-- Find slow queries
SELECT query, calls, mean_exec_time::int AS avg_ms,
       total_exec_time::int AS total_ms, rows
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Find tables with most sequential scans (missing indexes)
SELECT relname, seq_scan, idx_scan,
       seq_scan - idx_scan AS difference
FROM pg_stat_user_tables
WHERE seq_scan > 100
ORDER BY difference DESC;
```

---

## Frontend / Browser Profiling

### Core Web Vitals
```javascript
// Measure LCP, FID, CLS
import { onLCP, onFID, onCLS } from 'web-vitals'

onLCP(({ value }) => console.log('LCP:', value))  // target < 2500ms
onFID(({ value }) => console.log('FID:', value))  // target < 100ms
onCLS(({ value }) => console.log('CLS:', value))  // target < 0.1
```

### Bundle Analysis
```bash
# Next.js
ANALYZE=true npm run build

# Webpack
npm install --save-dev webpack-bundle-analyzer
# Add to webpack config, then:
npm run build -- --analyze

# Look for: duplicate dependencies, unexpectedly large modules
```

### React Performance
```javascript
// Wrap with Profiler to find slow renders
import { Profiler } from 'react'

<Profiler id="MyComponent" onRender={(id, phase, actualDuration) => {
  if (actualDuration > 16) {
    console.warn(`Slow render: ${id} took ${actualDuration}ms`)
  }
}}>
  <MyComponent />
</Profiler>
```

---

## Common Performance Patterns

### N+1 Query Fix
```javascript
// Bad: N+1
const users = await db.users.findAll()
for (const user of users) {
  user.orders = await db.orders.findByUserId(user.id)  // N queries
}

// Good: batch load
const users = await db.users.findAll()
const orderMap = await db.orders.findByUserIds(users.map(u => u.id))
users.forEach(u => u.orders = orderMap[u.id] || [])
```

### Memoization
```javascript
// Cache expensive computation
const memoize = <T>(fn: (...args: any[]) => T) => {
  const cache = new Map()
  return (...args: any[]): T => {
    const key = JSON.stringify(args)
    if (cache.has(key)) return cache.get(key)
    const result = fn(...args)
    cache.set(key, result)
    return result
  }
}
```

### Pagination over large result sets
```javascript
// Cursor-based pagination (O(1) regardless of page depth)
const results = await db.query(
  'SELECT * FROM records WHERE id > $1 ORDER BY id LIMIT $2',
  [lastSeenId, pageSize]
)
```

---

## Performance Budgets

Set these before starting optimization:

| Metric | Target |
|--------|--------|
| API p50 | < 100ms |
| API p95 | < 500ms |
| API p99 | < 1000ms |
| Page LCP | < 2500ms |
| Bundle size | < 200KB gzipped (initial) |
| DB query | < 50ms (p99) |

Track these with monitoring. Alert when they regress.
