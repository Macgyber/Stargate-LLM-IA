# Stargate: Technical Limitations & Observational Boundaries

Stargate v1-Experimental is a **Sovereign Visibility Layer** for DragonRuby. It is designed to provide narrative and technical clarity during runtime, but it operates within strict jurisdictional boundaries.

## 1. Safety vs. Visibility
- **Not an Auto-Fixer**: Stargate provides a FAIL-SAFE HUD to prevent the "Gray Screen of Death," but it **cannot fix** the underlying logic errors in your gameplay code.
- **Informational HUD**: The red fail-safe view is a diagnostic tool. If your code is broken, the game remains logically halted while Stargate remains visually active.

## 2. The Law of Non-Intervention
- **Passive Vigilante**: The Vigilante detects unsanctioned mutations but **does not revert them**. It emits alerts and suggests stasis, but the final decision to stop or continue belongs to the Human (or the Bridge).
- **Manual Audits**: The `LedgerKeeper` (The Book of Truth) will only audit the structural integrity of your nodes when explicitly called (`audit!`). It does not perform real-time policing of your filesystem.

## 3. Performance & I/O
- **Deterministic Drift**: While Stargate uses deterministic seeding for RNG, it cannot guarantee determinism if external, non-sanctioned Ruby libraries or system calls are used within the game loop.
- **Law of Silence**: To maintain 60FPS, Stargate's internal logging is throttled. Excessive technical telemetry on the machine-readable channels (`[STARGATE_MOMENT]`) is silenced by default unless `$stargate_debug` is active.

## 4. Experimental Status
- **v1-Experimental**: This architecture is a proof-of-concept for Sovereignty. Use it to gain visibility into your LLM/Agentic iterations, but do not rely on it as a production-grade security sandbox.

---
*Observe. Decide. Build.*
