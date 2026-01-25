# <img src="images/logo.png" width="150" height="150" align="right" /> 🌌 Stargate-LLM-IA
### *Developing at the speed of thought*

**Stargate-LLM-IA** is a professional, sustainable development runtime for DragonRuby. It transforms the codebase into a **Causal Graph**, where every line of code exists only because of a declared intention. It's designed to protect the "Flow State" and ensure that as complexity scales, the project remains understandable and modifiable by both humans and constrained AI Pilots.

---

## 🏛️ Architecture Overview

Stargate-LLM-IA is built as a **Sovereign Operating System for Development**, structured in two complementary layers:

### 🛡️ Runtime Layer (Execution)
Governs what happens while the game is running.
It enforces deterministic execution, time sovereignty (tick vs timestamp), and emits semantic runtime signals (`[STARGATE_VIEW]`) for observability instead of raw logs. This layer ensures the game does not collapse under errors; it observes them and maintains sovereignty.

### 🧠 Causal Layer (Editing)
Governs how the code is modified.
Code is not a flat list of files; it is a **Graph of Causal Nodes**. Every feature is isolated into a Node with a specific intention. If a Node's intention is removed from the graph, its code loses legitimacy and is pruned.

📜 **Authoritative specification:**  
See [`docs/architecture/CAUSAL_EDITING_MODEL.md`](docs/architecture/CAUSAL_EDITING_MODEL.md)

---

## 🤖 AI Pilot Instructions

This project is designed to be operated by a human **or** an AI acting as a **Constrained Pilot**. The AI is not a free-roaming refactorer; it is a surgical operator of the Causal Graph.

### ▶️ Running the Game
Launch the DragonRuby runtime with Stargate enabled using:
```bash
run
```
*(Shorthand for `dragonruby-run`)*

### ✂️ Modifying the Code (Causal Editing)
**The AI MUST NOT scan or refactor files freely.** All modifications must follow the Causal Protocol:
1.  **Consult** `.causal/index.yaml` to understand the Graph.
2.  **Identify** the single specific Causal Node responsible for the intent.
3.  **Operate** strictly within that node’s declared line ranges.
4.  **Legitimacy**: Every edit must serve the Node's declared intention. Orphaned code is prohibited.

---

## 🛠️ Activation

To protect your own project with Stargate:
1.  **Copy** the `app/stargate/` directory into your `app/` folder.
2.  **Initialize** at the very top of your `app/main.rb`:

```ruby
# --- STARGATE-LLM-IA START ---
require "app/stargate/core.rb"

def tick(args)
  Stargate.activate!(args)
  # --- STARGATE-LLM-IA END ---

  # Your sovereign simulation begins here...
end
```

---

## 🔄 Causal Synchronization

The `.causal/index.yaml` is the **Table of Contents** of your project. If it is out of sync with the code, the book is broken.

*   **Rule**: Every new feature must be registered as a Node in `.causal/index.yaml` **before** or **immediately after** writing code.
*   **Enforcement**: Code without a corresponding Node is considered "illegitimate" and subject to removal during pruning.
*   **Tooling**: Use `bin/stargate-sync` (if available) or manual audits to ensure parity.

---

## 🔬 Current Objective: The First Test

We are currently validating the **Causal Graph Model** by materializing our first **Generative Nodes** (`GraphNodeGen`).

**The Goal:**
Prove that we can create, modify, and delete a feature (e.g., `GraphNodeGenTextures`) strictly through Causal Operations, without touching the rest of the codebase.

**Success Criteria:**
1.  Node defined in `.causal/index.yaml`.
2.  Code generated only within its bounds.
3.  Effect visible in the Runtime.
4.  Causal Probe confirms the flow.

---

## 🧭 Causal Memory

*   **`docs/architecture/`**: The core philosophy and the Causal Editing Model.
*   **`.causal/`**: The digital memory of the graph (hidden from general view).
*   **`bin/stargate-reset`**: Re-syncs the Code and the Index to a Seed State.

---

## 📦 Ingredients (Samples)

Your creative ingredients are always close at hand. 
The **`SDK-DR/samples/`** directory contains the official DragonRuby examples.

*   Use these samples as **reference material** when defining new Causal Nodes.
*   **Do not modify** the samples directly; treat them as an immutable library of knowledge.

---

## 🛡️ Philosophy
Built for **Commercial Sustainability**.
- **Causal Integrity**: Code exists for a reason, or it doesn't exist at all.
- **Node-Based Debugging**: We don't debug lines; we debug causal relationships.
- **Flow Preservation**: Scalability without cognitive collapse.

Build sustainably. Stay in the flow. 🌌🐉🟦
