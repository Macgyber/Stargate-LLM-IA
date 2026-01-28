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

## Law 3: Derived Representation

The Index is a **Derived Representation** of the project's causal structure; the Interposition Layer is the governing authority.

*   **Hierarchy**: Reality (Source + Kernel) > Map (Index) > Interpretation (LLM).
*   **Active Language**: **"Changes to the index do not alter reality; they only alter interpretation."**
*   **Discrepancy**: If the Code contradicts the Index, the mapping is incomplete or outdated. The priority is to understand the reality of the implementation and then update the map to reflect it accurately.
*   **Observation**: An LLM should use the index to find where to look, but must always verify truth against the active code and the interposition layer.

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
