# Causal Index Laws

The **Causal Index** (`stargate/index.yaml`) is the constitutional document of the project.
These laws govern its creation, maintenance, and interpretation.

---

## Law 0: Scope

The Causal Index maps **Human Intent** to **Machine Implementation**.
It is not a file list or a dependency graph. It is a registry of *decisions*.

*   **Subject**: The project hosted by Stargate (e.g., the Game).
*   **Object**: The `index.yaml` file.
*   **Agent**: The Human or the LLM operating the system.

---

## Law 1: Territory

The Index describes the **Host Territory** (the User's Project), never the Stargate Tooling.

*   **Invisibility**: Stargate itself is invisible to the map.
*   **No Self-Reference**: `index.yaml` must not contain nodes describing `stargate/` internal files.
*   **Separation**: Stargate is the *Lens*; the Project is the *Image*. The lens does not see itself.

---

## Law 2: Coverage

All **Business Logic** must be covered by a Causal Node.

*   **Definition**: "Business Logic" refers to code that implements the specific rules, behaviors, or content of the project.
*   **Exclusion**: Trivial glue code, pure UI adapters, or vendor libraries do not require explicit nodes *unless* they embody a specific business decision.
*   **Ghost Code**: Logic that exists in the codebase but is not referenced by any Causal Node is considered "Ghost Code". It lacks legitimacy and is a candidate for pruning.

---

## Law 3: Source of Truth

The Index is the **Authoritative Source of Truth**; the Code is merely the implementation.

*   **Hierarchy**: Intent > Implementation.
*   **Discrepancy**: If the Code contradicts the Index, the Code is incorrect (or the Index is outdated). In either case, the conflict must be resolved by aligning the Code to the Index, or updating the Index to reflect the new Intent.
*   **Primacy**: An LLM must never modify code to fix a bug if doing so violates the declared Intent of the Node. It must request an Index update first.

---

## Consequences

### For the System
*   **Validation**: Tools may flag Ghost Code as warnings or errors.
*   **Drift**: Discrepancies between Index and Code are treated as "Ontological Bugs".

### For the LLM
*   **Read-First**: You must read `index.yaml` before reading any source code.
*   **Justification**: Every proposed code change must cite the specific Causal Node it serves.
*   **Constraint**: If a change requires logic outside existing nodes, you must propose a new Node first.

### For the Human
*   **Maintenance**: You are responsible for keeping the Index alive. A dead Index leads to a dead project.
*   **Review**: Review the Index changes as rigorously as the Code changes.
