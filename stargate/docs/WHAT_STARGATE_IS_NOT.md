# What Stargate Is NOT (The Anti-Manifesto)

To prevent technical inertia and preserve the system's core philosophy, we explicitly define what Stargate is **not**. 

**"The index is a derived map, not a governing authority."**

---

### ❌ NOT: An editable index as primary source of truth
Stargate does not rely on regular users or LLMs manually editing a YAML file to "change" how the system works. Documentation artifacts are windows into the system's logic, not the logic itself. Authority resides in the **interposition layer**.

### ❌ NOT: A code-generation-first framework
While Stargate helps LLMs write better code by providing causal context, its primary purpose is **intent preservation** and **governance**, not automated generation. It is a control layer, not a factory.

### ❌ NOT: A logging or telemetry tool
Stargate records *why* things happen (causality), not just *that* they happened (events). It is an analytical lens for structural integrity, not a performance monitor or an error logger.

### ❌ NOT: A replacement for human decision-making
Stargate constrains the LLM to follow human-defined intent. It does not "decide" architecture; it enforces the architecture defined by the Human Author.

### ❌ NOT: A monolithic override
Stargate sits between the user and the system. It is a transparent layer that can be bypassed or removed without destroying the underlying project. It is **sovereign** but **non-invasive**.

---

**"Authority in Stargate resides in the interposition layer, not in documentation artifacts."**
