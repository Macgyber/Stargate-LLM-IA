# Stargate-LLM-IA

**"The index is a derived map, not a governing authority."**  
**"Authority in Stargate resides in the interposition layer, not in documentation artifacts."**

A causal indexing system for controlling how LLMs read and modify code.

---

Stargate is a **Sovereign Causal SDK** for LLM-assisted development.

It functions as a technical library/runtime that provides:
1.  **A Sovereign Runtime Layer**: A safety-first interposition layer (The Bridge) that provides **execution continuity and failure visibility**.
2.  **A Causal Index**: A mapping of intent over code, establishing a contract for LLMs to consult the *why* before changing the *what*.

---

## What problem does it address?

When using LLMs (Cursor, Copilot, local models) on real projects:

- Context is implicit and fragile
- The model modifies code without understanding why it exists
- Changes fix one thing and silently break another
- Developers lose trust in letting the LLM touch the code

Stargate addresses **intent loss**, not code quality.

---

## What Stargate is

### 1. A Sovereign Runtime Layer
A safety-first interposition layer (**The Bridge**) that provides execution continuity and failure visibility. It ensures the environment stays alive even during project crashes.

### 2. A Causal Index
A mapping of intent over code (`index.yaml`), establishing a contract for LLMs to consult the **why** before changing the **what**.

---

## 🧬 Quick Integration

1. **Install**: Copy the `stargate/` folder to your project root.
2. **Launch**: Launch your project using the **Sovereign Bridge** pattern.
3. **Map**: Ask your LLM to map your intent into `stargate/index.yaml`.

> [!TIP]
> For the detailed **Sovereign Bridge** integration ritual and technical diagrams, see [TECHNICAL_DETAILS.md](stargate/docs/TECHNICAL_DETAILS.md).

---

## Why Stargate?

Traditional LLM assistance often lacks context. Stargate addresses **intent loss** by:
- Explicitly mapping code to human motivation.
- Providing a visual fail-safe for runtime debugging.
- Reducing the risk of "Gray Screen" failures in engines like DragonRuby.

---


---

## Why not comments or documentation?

Comments describe *what* code does.

Stargate records:
- **Why** the code exists
- **What assumptions** it relies on
- **What other parts** depend on it

This matters when:
- Letting an LLM modify unfamiliar code
- Returning to a project after time
- Evaluating the impact of a change

---

## Limitations

- Requires manual discipline
- The causal index can drift if ignored
- Best suited for small to medium projects
- Current tooling assumes Cursor-style workflows

These are known trade-offs.

---

## Who is this for?

- Developers experimenting with LLM-assisted coding
- Projects where predictability matters more than speed
- People who want to understand changes, not just apply them

---

## Documentation

- **Philosophy**: [DESIGN.md](stargate/docs/DESIGN.md)
- **The Laws**: [SOVEREIGN_LAWS.md](stargate/docs/SOVEREIGN_LAWS.md) (The Core Specs)
- **Causal Model**: [CAUSAL_INDEX_LAWS.md](stargate/docs/CAUSAL_INDEX_LAWS.md)
- **Integration Guide**: [TECHNICAL_DETAILS.md](stargate/docs/TECHNICAL_DETAILS.md)
- **Public API**: [PUBLIC_CONTRACT.md](stargate/docs/PUBLIC_CONTRACT.md)

---

## Status

This project is **experimental**.

- The ideas are stable.
- The implementation is evolving.

Critical feedback is welcome.
