# Stargate-LLM-IA: Causal Editing Model (v1.0)

> **Normative Status**: This document defines the operating model of the Stargate system. If an AI's behavior contradicts this model, the behavior is considered incorrect.

**Stargate-LLM-IA** functions as a **Sovereign Operating System** for AI-assisted development. It is composed of two distinct, complementary layers designed to prevent project collapse as complexity scales.

## 1. Runtime Layer (Execution) 🛡️
*Protects the process in real-time.*

This layer governs the active simulation, ensuring that errors are detected and contained without destroying the session.

-   **Time Sovereignty**: The system explicitly defines the rules of causal time (`tick`) versus real time (`timestamp`). It guarantees that the runtime can detect anomalies and prepare deterministic rollbacks without crashing the OS process.
-   **Determinism**: Through the **Sovereign RNG** (`args.state.rng`), the system guarantees that identical initial states + identical inputs = identical outcomes. This is a mathematical absolute, not a "best effort."
-   **Observability Bridge**: The runtime emits semantic signals (`[STARGATE_VIEW]`) rather than raw logs. This allows an Observer (AI) to understand *consequences* (e.g., "Boss died at tick 600") without needing to infer them from raw code execution. The runtime declares truth; it does not ask the observer to guess.

## 2. Causal Layer (Editing) 🧠
*Protects the reasoning during development.*

This layer governs how code is modified, preventing the "amnesia" and "context explosion" typical of Large Language Models.

-   **Causal Index (`stargate/index.yaml`)**: A cognitive map that divides large files into strictly bounded **Causal Nodes** (e.g., `enemies.boss.ai`, `player.input`). It transforms a "file" into a library of logical responsibilities.
-   **Node Surgery Protocol**: When an intent is formed (e.g., "Make the boss faster"), the AI **must** identify the single responsible Node and operate *only* within its defined line ranges. **A Node is the smallest unit of causality. If a change requires touching multiple nodes, the intent must be decomposed into multiple sequential operations.**
-   **Safe Editing**: Modifications are strictly scoped. Changing the Boss logic cannot break the Player Input because the AI is prohibited from accessing or modifying the Player Input node during that operation.

## 3. The Negative Space: What This Model Forbids 🚫
The power of this model lies in its constraints. Intelligence is defined by what the system **refuses** to do.

-   ❌ **No Context Scanning**: The AI shall never read an entire file to "get context." It must consult the Index.
-   ❌ **No Global Refactors**: The AI shall never "clean up" or "optimize" code outside the active Node.
-   ❌ **No Creative Rewriting**: The AI shall not rewrite functional code styles unless explicitly requested by the Intent.
-   ❌ **No Invisible Changes**: Every modification must be traceable to a specific, declared Causal Node.
-   ❌ **No Inference of architecture**: The AI shall not guess the architecture; it must read the `index.yaml` as the source of architectural truth.

## 4. Lifecycle Synchronization ♻️
The Index and the Code are one. They are born together and die together.

-   **Automatic Synchronization**: When the project is reset (e.g., via `stargate/bin/stargate-reset`), both `app/main.rb` and `stargate/index.yaml` are simultaneously restored to a **Seed State**.
-   **No Orphaned Indices**: It is a violation of the model to have Index Nodes pointing to non-existent code. The Index must always reflect the exact reality of the Codebase.

---
*Stargate-LLM-IA transforms development from "fragile structures" to "assembling Lego blocks."*
