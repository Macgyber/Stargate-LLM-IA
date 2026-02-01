# The Sovereign Runtime Contract (SRC)

These are the **Sovereign Laws** that govern the Stargate interposition layer. They represent the "physical" rules of the runtime to ensure execution continuity and failure visibility.

---

## ⚖️ The Ten Sovereign Laws

### Law 1: The Tick is Sacred
Every iteration of the host engine's loop must result in a visual output. The screen shall never be gray.

### Law 1.1: Render Precedes Logic
The `Stargate::Avatar.render` must execute **before** any Stargate logic or project code. If the world crashes later in the frame, the Avatar has already spoken.

### Law 2: No Heavy Work in the Tick
Disk I/O, recursive directory scans, and intensive computation are strictly forbidden within the active `tick`. These are "Offline" or "Forensic" activities.

### Law 3: Absolute Authority of `args`
No subsystem shall rely on implicit global state (like `$gtk` or globals). Reality is passed through `args` from the Bridge. If `args` is not present, the world does not exist.

### Law 4: The Clock is Constant
The internal `Stargate::Clock` governs causal time. It can be paused, but the host engine loop must stay alive to observe the pause.

### Law 5: Boot serves Observation
The initialization phase (`bootstrap.rb`) must observe the territory and set anchors, but it shall not "punish" or block the first frame.

### Law 5.1: Vigilante is a Sensor, not a Flow Controller
The `Vigilante` identifies violations and emits intents/states. It does not pause the clock directly; it requests stasis from the Bridge.

### Law 6: No Self-Audit while Alive
`LedgerKeeper` is an offline diagnostic service. Automatic file-system audits during the game tick are a jurisdictional violation.

### Law 7: The Pulse is Permanent
The `Stargate::Avatar` must render a minimal pulse every frame to confirm the interposition layer is breathing.

### Law 8: Isolation of Intent
A gameplay intent must mark state as "dirty" but should not know how or when that state is persisted.

### Law 9: Jurisdictional Silence
If a subsystem has nothing of value to report, it must stay silent. Log spam is a breach of sovereign order.

### Law 10: Error is Visible
A failure must never lead to silence. Exceptions must be caught by the Bridge and rendered visually by the Avatar.

---

## ⚓ The Ironclad Amendments

### Amendment 10.1: Fail-Safe Visual Fallback
The Bridge must catch all top-level exceptions and pass them to the Avatar for immediate, non-blocking visual reporting.

### Amendment 5.1 (Revised): Passive Intervention
Stargate does not "stop" the game; it proposes a "Stasis Mode" which the Bridge decides to enforce.

### Amendment 6.1: Semantic Reporting
Subsystems (like LedgerKeeper) report findings as structured data. They do not trigger system-wide shouts or punishments directly.
