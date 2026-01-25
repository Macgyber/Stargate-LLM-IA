# 🧠 Causal Editing Protocol (AI-V1)

## 1. The Prime Directive
**You do not edit "files". You edit "Nodes".**
Before writing a single line of code, you must identify which **Causal Node** from `.causal/index.yaml` is responsible for the User's request.

## 2. Interaction Loop

### Phase A: Diagnosis (Read-Only)
1.  **Receive Intent**: User says "Make the boss move faster".
2.  **Consult Index**: Read `.causal/index.yaml`.
3.  **Select Node**: Match "Make the boss move faster" -> `enemies.boss.ai`.
4.  **Target Focus**:
    *   Reading `app/main.rb` lines 84-120 (as defined in the node).
    *   **IGNORE** `rendering.compositor`, `audio`, `player.input`.

### Phase B: Execution (Surgical)
1.  **Plan Change**: "Increase `args.state.boss.y` interpolation factor from 0.04 to 0.08".
2.  **Verify Constraints**: Ensure this change stays within the `enemies.boss.ai` node ranges.
3.  **Apply Patch**: Edit *only* the specific lines.
4.  **Update Index**: If the logic expands (e.g., added new lines 121-125), update the `ranges` in `.causal/index.yaml` immediately.

### Phase C: Failure/Revert (Undo)
If the User rejects the change:
1.  Identify the Node touched (`enemies.boss.ai`).
2.  Revert code within that Node's range to the previous state.
3.  The rest of the system (Player, Physics, Render) remains untouched.

## 3. Forbidden Actions (Strict)
*   ❌ **NEVER** scan the entire file to "find" code. Use the Index.
*   ❌ **NEVER** modify code outside the Active Node without declaring a dependency.
*   ❌ **NEVER** leave `index.yaml` outdated. If you change the territory, update the map.

## 4. Multi-Node Intents
If a request spans multiple nodes (e.g. "Add a health bar to the boss"):
1.  **Primary Node**: `enemies.boss.ai` (Add health property).
2.  **Secondary Node**: `rendering.compositor` (Draw the bar).
3.  **Protocol**: You must explicitly declare you are "Working on Nodes: `enemies.boss.ai` + `rendering.compositor`".

---
*This protocol transforms the IDE from a Text Editor into a Causal Editor.*
