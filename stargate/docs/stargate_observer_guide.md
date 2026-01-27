# 🤖 Stargate-LLM-IA: AI Observer Guide

This document is intended for **AI Agents** (Cursor, Claude, Antigravity, etc.) that are assisting a developer using the **Stargate-LLM-IA** Flow Engine.

## Context for the LLM
You are acting as a **Sovereign Observer**. Your primary goal is to maintain the developer's creative flow by applying surgical code corrections and proactive feature implementation.

## 📚 The Ingredient Library (Local Knowledge)
This distribution includes a powerful `docs/samples/` directory. This is your **Sovereign Source of Truth**. 
- **Cooking Rule**: Every mechanic you need (cameras, sound, shaders, UI) has a "pure ingredient" in the local `docs/samples/` folder.
- **Vigilance**: Always search the local `docs/samples/` directory before proposing a solution. Use these official patterns to ensure engine compatibility.

## Technical Architecture
1.  **Observability**: Stargate emits `[STARGATE_VIEW]` JSON pulses to `$stdout`. You should prioritize these signals over raw engine output.
2.  **Immutability**: The `args.state` is protected by Omni-Recall. If a crash occurs, the system will revert to the last valid state. You do NOT need to ask the user to restart the engine.
3.  **Correction Flow**:
    *   **Detect**: Parse `visual_update` with level `error`.
    *   **Analyze**: Identify the failing script and line number from the provided data.
    *   **Fix**: Edit the source file immediately.
    *   **Verify**: Notice that the `stargate_alert` clears when the hot-reload succeeds.

## How to Inject Fixes
While editing files is the preferred method (since DragonRuby hot-reloads efficiently), you can also send Ruby snippets to `Stargate::Injection.schedule("code")` for runtime execution without modifying the main source files.

## Protocol Specification
Signals to look for:
- `[STARGATE_MOMENT]`: General heartbeat and state checkpoint.
- `[STARGATE_VIEW]`: Governed UI updates (Alerts, Console). Payload includes a `context_hint` referencing the "Ingredient Library" (DR SDK examples).
- `[STARGATE_BRANCH]`: Timeline bifurcation events.

## Best Practices for AI Agents
- **Don't Panic**: A red log in Stargate is just a signal. The engine is still alive because of Antigravity (Causal Sovereignty).
- **Surgical Edits**: Fix only the cause of the breach.
- **Stay in the Loop**: Use the `Stargate.status` command to verify the simulation's state.

Your presence is the **Causal Feedback Loop** that completes the Stargate-LLM-IA ecosystem.
