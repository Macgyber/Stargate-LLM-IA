# Stargate-LLM-IA (v1-Experimental)

**"A visibility layer for causal intent, not a replacement for human logic."**

Stargate is a **Sovereign Causal SDK** for LLM-assisted development. It functions as a technical library that provides:

1.  **Sovereign Visibility**: A safety-first interposition layer (The Bridge) that guarantees simulation continuity even during project crashes.
2.  **Causal Indexing**: A derived mapping of intent over code, establishing a contract for LLMs to consult the *why* before changing the *what*.

---

## 🏗️ Core Capabilities (Observed)

- **Execution Continuity**: Prevents the "Gray Screen" by ensuring a render call happens before the logic loop.
- **Fail-Safe Diagnostics**: Catch-all interposition that displays errors while keeping the engine alive.
- **Structural Memory**: A manual `LedgerKeeper` tool to detect node "births" and "ghosts" in the filesystem.

## ⚠️ Jurisdictional Boundaries

Stargate is a **visibility tool**, not a security sandbox or a bug-fixer.

- **Non-Intervention**: It detects violations but does not automatically revert code.
- **Manual Audits**: Structural checks are performed only when explicitly requested.
- **Passive Nature**: If everything is technically correct, Stargate remains invisible.

> [!CAUTION]
> **READ BEFORE USING**: For a full list of technical boundaries and anti-guarantees, see [LIMITATIONS.md](stargate/docs/LIMITATIONS.md).

---

## 🧬 Integration Ritual

1. **Install**: Copy the `stargate/` folder to your project root.
2. **Launch**: Replace your standard `tick` with the **Sovereign Bridge** pattern (see [TECHNICAL_DETAILS.md](stargate/docs/TECHNICAL_DETAILS.md)).
3. **Map**: Use the provided `.cursorrules` to instruct your LLM to map existing intent into `stargate/index.yaml`.

---

## Documentation Index

- **Foundations**: [DESIGN.md](stargate/docs/DESIGN.md)
- **The Laws**: [SOVEREIGN_LAWS.md](stargate/docs/SOVEREIGN_LAWS.md)
- **Technical Specs**: [TECHNICAL_DETAILS.md](stargate/docs/TECHNICAL_DETAILS.md)
- **Technical Limits**: [LIMITATIONS.md](stargate/docs/LIMITATIONS.md)
- **Public API**: [PUBLIC_CONTRACT.md](stargate/docs/PUBLIC_CONTRACT.md)

---

## Status

**Experimental (v1)**. This architecture is a proof-of-concept for Sovereignty in Agentic Workflows. It is designed for observability and human-in-the-loop control.

*Observe. Decide. Build.*
