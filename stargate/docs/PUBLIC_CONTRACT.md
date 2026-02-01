# Stargate Public Contract (v1.0)

This document defines the **Frozen Surface** of Stargate.
Ideally, breaking changes should never occur within this surface.

Internal modules (`Stargate::Clock`, `Stargate::State`, etc.) are **private** and subject to change without notice.

---

## 1. The Sovereign API

These methods are the **only** entry points an external system (Game or Editor) should use.

### `Stargate.initialize_context(args, mode: :standard)`

*   **Role:** Bootstrapping / Instrumentation.
*   **Promise:** Idempotent. safe to call during the boot phase. In the **Sovereign Bridge** architecture, it is traditionally called once by the Bridge.
*   **Side Effects:** Attaches observability hooks. Does **not** alter game logic execution flow.
*   **Parameters:**
    *   `args`: Host environment object (see *Host Contract* below).
    *   `mode`: Symbol. `:standard` (default), `:silent`, or `:chaos_lab`.

### `Stargate.intent(type, payload = {}, **options)`

*   **Role:** The voice of the Game.
*   **Promise:** Asynchronously accepts a semantic signal.
*   **Behavior:**
    *   If `source: :gameplay` (default), it marks the current frame as **Mutated/Dirty**.
    *   This is the *only* legitimate way to trigger a state capture in the Causal Graph.
*   **Parameters:**
    *   `type`: Symbol/String (e.g., `:jump`, `:damage`, `:ui_click`).
    *   `payload`: Hash. Arbitrary data describing the event.

### `Stargate.status`

*   **Role:** Health check.
*   **Promise:** Returns a simple Hash with no side effects.
*   **Returns:**
    *   `active`: Boolean. Stargate is initialized.
    *   `interrupted`: Boolean. Vigilante has detected a violation.
    *   `booted`: Boolean. Bootstrap sequence completed.
    *   `stasis_requested`: Boolean. A subsystem has proposed pausing the clock.
    *   `fail_safe`: Boolean. The system is running in emergency fallback mode due to a crash.

---

## 2. The Host Contract

Stargate is not a standalone engine; it relies on a **Host** (e.g., DragonRuby GTK).
It expects the `args` object passed to `initialize_context` to satisfy this structural typing:

*   **`args.state`** (Required):
    *   Must be a persistent, mutable object (OpenStruct or Hash-like).
    *   Stargate uses this to read `tick_count` for timestamping.
*   **`args.outputs`** (Optional):
    *   Used only for visual overlays if enabled.

**Failure Mode:**
If `args` does not satisfy the contract, Stargate will catch the exception, log a warning, and enter **Dormant Mode** (no-op) to prevent crashing the host application.

---

## 3. Anti-Guarantees

We explicitly **DO NOT** promise:

1.  **Rendering Performance:** If you emit 10 intents per frame, we will process 10 intents. We do not throttle for you.
2.  **Internal Stability:** Classes inside the `Stargate::` namespace (excluding the public module methods above) are implementation details. Do not subclass them.
3.  **Persistence Format:** The JSON/Binary format of the blobs in `.stargate/blobs` is private and versioned internally. Do not parse it manually.

---

## 4. Deprecation Policy

*   **`Stargate.activate!`**: Deprecated. Use `initialize_context`.
*   **`capture!`, `recall!`**: Legacy debug tools. Likely to be moved to a separate `TimeTravel` module or plugin.
