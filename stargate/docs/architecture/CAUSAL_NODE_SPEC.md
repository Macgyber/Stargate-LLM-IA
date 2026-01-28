# Causal Node Specification (v1.0)

> "The code does not exist without its index."

This document formalizes the anatomy of a **Causal Node**, the **AI Navigation Protocol**, and the **Visual Heartbeat**.

---

## 1. Anatomy of a Causal Node

A Causal Node is the atomic unit of intent in Stargate.
It is not just a "file mapping"; it is a contract of existence.

### YAML Schema Definition
Every entry in `index.yaml` must conform to this partial schema:

```yaml
node_id:
  # 1. INTENT (The "Why")
  intent: "Short, semantic description of what this node achieves."
  
  # 2. TERRITORY (The "Where")
  files:
    - "path/to/primary/file.rb"
    - "path/to/helper.rb:10-50" # Line ranges supported

  # 3. STATE (The "How Safe")
  state: stable | experimental | frozen | volatile

  # 4. DEPENDENCIES (The "Cost")
  depends_on:
    - other_node_id
    - core_system
```

### State Definitions

| State | Role | AI Permission |
| :--- | :--- | :--- |
| **`stable`** | Core functionality that works. | **Read-Only** by default. Requires explicit "Refactor" intent to touch. |
| **`frozen`** | Legacy or sensitive code (e.g., Stargate itself). | **FORBIDDEN**. No modifications allowed. |
| **`experimental`**| New prototypes or drafts. | **Read-Write**. AI can iterate freely here. |
| **`volatile`** | Code known to be buggy or temporary. | **Write-Optimized**. AI is encouraged to fix/replace. |

---

## 2. The AI Navigation Protocol

The AI acts as a **Navigator**, not a free Editor.
**CRITICAL LAW**: The AI **NEVER** writes to `index.yaml` autonomously. It only reads.

### The Ignition Sequence
Before writing a single line of code, the AI must:

1.  **READ INDEX**: Load `stargate/index.yaml` to understand the authorized map.
2.  **LOCATE NODE**: Find the Node ID corresponding to the user's request.
    *   *If no node exists*: **STOP**. Ask the Human to create the node.
3.  **CHECK STATE**: Verify if the node is `frozen` or `stable`.
4.  **LOAD TERRITORY**: Read *only* the files listed in that node.
5.  **EXECUTE**: Apply changes within the territory.
6.  **VERIFY TWIN**: Confirm that the code changes still align with the `intent` described in the index.

> **The Twin Law (Refined):**
> *   **Human Role**: Author of the Index. Defining Intent.
> *   **AI Role**: Executor of the Index. Respecting Intent.
> *   The AI cannot change the Code if it violates the Index.
> *   The AI cannot update the Index to suit the Code.

---

## 3. The Visual Heartbeat (Minimal Feedback)

Instead of a noisy console logs, Stargate exposes a **Visual Heart**.
This is a minimal UI element (pixel, dot, or bar) that communicates the **Health of the Causal System**.

### Semantics

*   **PULSE (Rhythm)**: The system is alive.
*   **COLOR (State)**:
    *   🟢 **GREEN**: All Nodes valid. Integrity 100%.
    *   🟡 **YELLOW**: Ghost Code detected or `experimental` node active.
    *   🔴 **RED**: Causal Violation (Code contradicts Index).
*   **TEXT (Silence)**: No text logs unless a Violation occurs.

### Implementation Goal
A single, non-intrusive indicator in the corner of the screen that replaces the scrolling wall of text.
