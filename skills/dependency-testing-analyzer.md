---
name: dependency-testing-analyzer
description: Analyzes repository dependency files and testing infrastructure to identify frameworks, libraries, build systems, and testing strategies used in a project. Use when determining the technology stack, dependency ecosystem, and testing setup of a repository.
metadata:
  author: dev-os
  version: 1.0
  category: repository-analysis
---

# Dependency & Testing Analyzer Skill

## Objective

Analyze repository dependency manifests and testing infrastructure to understand:

- frameworks used
- external libraries
- development tools
- testing frameworks
- test structure
- CI testing pipelines

This helps determine the project’s technology stack and code quality practices.

---

# Workflow

## Step 1 — Locate Dependency Files

Search the repository for dependency manifests such as:

Node / JavaScript:
- package.json
- package-lock.json
- yarn.lock

Python:
- requirements.txt
- pyproject.toml
- Pipfile

Java:
- pom.xml
- build.gradle

Go:
- go.mod

Rust:
- Cargo.toml

Other build systems if present.

---

## Step 2 — Extract Runtime Dependencies

Identify:

- primary frameworks
- core libraries
- infrastructure tools

Examples:

- web frameworks
- databases
- AI libraries
- networking libraries

Determine which dependencies are essential for application functionality.

---

## Step 3 — Extract Development Dependencies

Identify tools used for development such as:

- linters
- formatters
- build tools
- code quality tools

Examples:

- eslint
- black
- prettier
- flake8
- webpack

---

## Step 4 — Identify Testing Frameworks

Look for testing frameworks in dependency files.

Examples:

Python:
- pytest
- unittest
- pytest-cov

JavaScript:
- jest
- mocha
- vitest

Java:
- junit
- testng

Other ecosystems:
- go test
- cargo test

---

## Step 5 — Detect Test Structure

Search repository structure for testing directories such as:

- tests/
- test/
- __tests__/
- spec/

Identify:

- unit tests
- integration tests
- end-to-end tests

Determine the overall test organization.

---

## Step 6 — Detect Test Tooling

Look for testing-related tools including:

- coverage tools
- mocking libraries
- test runners

Examples:

- coverage.py
- istanbul
- nyc
- pytest-cov

---

## Step 7 — Detect CI Testing Pipelines

Check CI configuration files for automated testing:

Examples:

- .github/workflows/
- GitLab CI files
- CircleCI configs
- Jenkins pipelines

Identify if tests run automatically in CI.

---

# Output Format

Dependency & Testing Analysis

Primary Frameworks

Key Libraries

Development Tools

Testing Frameworks

Test Directory Structure

Coverage / Testing Tools

CI Testing Setup

Observations