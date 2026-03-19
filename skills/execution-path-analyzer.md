---
name: execution-path-analyzer
description: Traces execution paths within a repository to determine how requests, data, or program flow move through modules and services. Use when understanding runtime behavior, entry points, and interactions between components.
metadata:
  author: dev-os
  version: 1.0
  category: repository-analysis
---

# Execution Path Analyzer Skill

## Objective

Understand how execution flows through a codebase.

Identify:

- entry points
- request handling flow
- service interactions
- module dependencies
- runtime behavior

This helps developers quickly understand how the system operates.

---

# Workflow

## Step 1 — Identify Entry Points

Search for primary execution entry points such as:

Application servers:
- main.py
- app.py
- server.js
- index.js

Compiled languages:
- main.go
- main.rs
- Main.java

CLI programs:
- CLI handlers
- command entry points

Framework startup files.

---

## Step 2 — Trace Request or Execution Flow

Follow how execution proceeds from the entry point.

Identify:

- routing logic
- controller handlers
- service layers
- data access layers

Determine the flow of control through the application.

---

## Step 3 — Map Module Interactions

Identify how modules interact:

Examples:

- API → service → database
- CLI → command handler → worker
- request → middleware → handler → service

Determine dependencies between components.

---

## Step 4 — Identify External Integrations

Detect integrations with:

- databases
- APIs
- message queues
- external services

Determine where these integrations occur in the execution path.

---

## Step 5 — Identify Critical Code Paths

Highlight important flows such as:

- request lifecycle
- data processing pipelines
- background jobs
- scheduled tasks

---

# Output Format

Execution Path Analysis

Entry Points

Primary Execution Flow

Module Interaction Map

External Integrations

Critical Code Paths

Observations