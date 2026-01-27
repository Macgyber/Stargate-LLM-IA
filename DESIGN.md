# Stargate – Design Document

This document explains the design decisions and mental model behind Stargate.
It is not a usage guide.

---

## 1. Design Goals

Stargate is designed to:

- Preserve human intent when working with LLMs on existing codebases
- Make implicit architectural assumptions explicit
- Prevent unintentional code changes caused by missing context
- Encourage deliberate, traceable modifications

The system prioritizes **predictability and understanding** over speed or automation.

---

## 2. Non-Goals

Stargate explicitly does not aim to:

- Automatically refactor code
- Optimize performance
- Enforce architectural correctness
- Replace code reviews or testing
- Act autonomously without human intent

Any future capability must respect these constraints.

---

## 3. Core Concepts

### 3.1 Causal Index

The causal index is a structured representation of *why* code exists.

It is stored as a human-readable file (`index.yaml`) and serves as the primary source of truth for intent.

The authoritative rules governing the index are defined in [`CAUSAL_INDEX_LAWS.md`](CAUSAL_INDEX_LAWS.md).

The index is authoritative; source code is not sufficient by itself.

### 3.2 Causal Node

A causal node represents a unit of intent.

Each node should answer:
- What responsibility this code fulfills
- Why that responsibility exists
- What other nodes depend on it

Nodes are not required to map one-to-one with files.

### 3.3 Mapping Phase vs Change Phase

Stargate distinguishes between two modes of interaction:

- **Mapping Phase**:  
  The LLM observes and records intent without modifying code.

- **Change Phase**:  
  Modifications are proposed or applied only when justified by the causal index.

This separation is fundamental to the system.

---

## 4. Mental Model

Stargate operates as a **metadata overlay** on top of the source code.

- **The Territory**: The actual source code files (`.rb`, `.js`, etc.).
- **The Map**: The `index.yaml` provided by Stargate.

Legacy development treats the code as the only truth. Stargate asserts that code is merely the implementation of an intent defined in the index. Use logic flows from the Map to the Territory, never the reverse. If code exists without a corresponding node in the Map, it is considered "Ghost Code" and is a candidate for removal.

---

## 5. Interaction with LLMs

Stargate acts as a **constraint mechanism** for Large Language Models.

Instead of asking an LLM "Fix this bug", the workflow is:
1.  **Locate Node**: Identify the Causal Node responsible for the behavior.
2.  **Retrieve Context**: Load only the relevant node and its explicit dependencies.
3.  **Constraint**: The LLM is forbidden from modifying files outside this scope.

This prevents the common failure mode where an LLM fixes a local issue but breaks a global assumption (hallucinated refactoring).

---

## 6. Why This Is Not a Framework

A framework dictates *structure* (MVC, Entity-Component-System).
Stargate dictates *process*.

- You can use Stargate with Rails, DragonRuby, Node.js, or plain C scripts.
- It does not import libraries into your runtime (other than a minimal core for validation if desired).
- It does not force you to write classes or functions in a specific way.

It only captures **metadata about** those classes and functions.

---

## 7. Known Trade-offs

### 7.1 Velocity vs. Precision
Stargate slows down the "write code fast" loop.
- **Cost**: You must update `index.yaml` when adding features.
- **Benefit**: You do not lose context 6 months later.

### 7.2 Dual Maintenance
You must maintain sync between code and index.
- **Risk**: Drift. If the index says one thing and the code does another, the system fails.
- **Mitigation**: Tooling (e.g., `stargate-reset`) helps, but human discipline is required.

---

## 8. Current Constraints

- **Single Index File**: Currently, `index.yaml` is a monolithic file. Large projects may require splitting this in the future (e.g., `stargate/nodes/*.yaml`).
- **Manual Verification**: There is currently no automated linter to block CI/CD if the index is out of sync.
- **Tooling Dependency**: The workflow relies heavily on the user or the LLM updating the YAML correctly.

---

## 9. Future Directions (Non-Commitments)

These areas are being explored but are not guaranteed:

- **Automated Drift Detection**: Git hooks to warn if code changes without index updates.
- **IDE Integration**: Direct visualization of Causal Nodes in editor margins.
- **Hierarchical Indexing**: Support for nested namespaces in the causal map.
