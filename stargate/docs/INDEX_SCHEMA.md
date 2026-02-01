# Index Schema & Ghost Code Protocol

This document defines the **Physical Structure** of the Causal Index and the **Operational Definition** of Ghost Code.

---

## 1. Minimum Viable Format (`index.yaml`)

A valid `index.yaml` is a list of **Causal Nodes**. Each node must strictly adhere to this schema.

### YAML Structure
```yaml
nodes:
  - id: [unique-slug]
    intent: >
      [Human-readable description of WHY this exists.
      Must explain the business value or logical necessity.]
    responsibility:
      - [Specific behavior 1]
      - [Specific behavior 2]
    implementation:
      files:
        - [path/to/file.rb]
      symbols:
        - [Class#method]
    depends_on:
      - [other-node-id]
```

### Mandatory Fields (Non-Negotiable)

| Field | Purpose | Validation Rule |
| :--- | :--- | :--- |
| **`id`** | Stable reference | Must be kebab-case, unique, and effectively immutable. |
| **`intent`** | The "Why" | Must describe purpose, not mechanics. "Fix bug" is invalid. "Ensure player gravity" is valid. |
| **`implementation`** | The "Where" | Must list at least one file. Defines the node's **Territory**. |
| **`depends_on`** | Impact analysis | Must list causal dependencies. Empty list `[]` implies a root axiom. |

### Excluded Fields
*   **DO NOT include**: Line numbers, hashes, performance metrics, complexity scores. These are volatile implementation details, not intent.

---

## 2. Ghost Code (Operational Definition)

**Ghost Code** is any business logic that exists in the codebase but is not claimed by an active Causal Node.

### Detection Rules
A block of code is **Ghost Code** if it meets ALL of the following criteria:
1.  **Lives in the Territory**: It is outside the `stargate/` tooling directory.
2.  **Exerts Force**: It contains state mutation, conditional logic (flow control), or domain calculations.
3.  **Untraceable**: It cannot be linked to a Node via the `implementation` map (file path or symbol name).

### Taxonomy of Ghosts
*   👻 **Innocent**: Code currently being written, not yet indexed. (Transitional state).
*   ⚠️ **Orphaned**: Code left behind after its Causal Node was deleted. (Cleanup required).
*   ☠️ **Illegitimate**: Active logic executing without a known intent. **This is an Ontological Error.**

### LLM Protocol for Ghost Code
When an LLM encounters logic that fits the Ghost Code definition:
1.  **HALT**: Do not modify or refactor it.
2.  **REPORT**: "I found logic in `[file]` that has no Causal Node."
3.  **QUERY**: Ask the user:
    *   *Create a new node?*
    *   *Attach to existing node?*
    *   *Delete the code?*

---

## 3. The Golden Rule

> **"If you cannot justify a change by citing a Causal Node ID, the change must not happen."**

*   **Mapping Phase**: Create the Node first.
*   **Change Phase**: Reference the Node ID in the commit/diff.
