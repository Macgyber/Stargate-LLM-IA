# <img src="images/logo.png" width="150" height="150" align="right" /> 🌌 Stargate-LLM-IA
### *Developing at the speed of thought*

**Stargate-LLM-IA** is a professional, sustainable development runtime for DragonRuby. It transforms your code editor (Cursor, VS Code) into a **Causal AI Editor**.

**Think of it like this:** Instead of your code being just text files, it becomes a **Map of Reasons**. Every piece of code exists because *something* wanted it to exist. Stargate keeps track of those reasons, so when things change, you understand *why*, not just *what*.

---

## 💡 The Pragmatic Truth

### 1. What problem does it solve?
**Cognitive Collapse in AI-Assisted Coding.**
When you use AI (Cursor/Copilot) to build large projects, the code eventually becomes a "black box" of spaghetti that neither you nor the AI fully understands. Stargate forces a structure (Causal Graph) that prevents this chaos, keeping the project clean and modular forever.

### 2. How is it used in practice?
**You stop writing code; you start managing intentions.**
Instead of saying *"Add a function to move the player"*, you define a **Node** in your Graph called `PlayerMovement`. The AI generates the code *only* for that node. If you want to change movement, you edit that Node. You manage the map; the AI paves the roads.

### 3. What does it NOT replace?
*   It does **NOT** replace **DragonRuby** (it runs on top of it).
*   It does **NOT** replace **Git** (it works alongside version control).
*   It does **NOT** replace **Architecture** (you still need to design the system; Stargate just enforces it).

---

---

## 🔍 What Stargate Actually Does (The Reality Check)

It's easy to get lost in the philosophy. Here is exactly **what our module does** and **what it does not do**.

### ✅ WHAT IT DOES (The Capabilities)
1.  **Enforces Determinism**: It wraps the standard DragonRuby `tick` loop to ensure that Inputs + State always equal the same Output.
2.  **Manages Time**: It replaces `Time.now` with a monotonic `tick count`, allowing you to rewind, fast-forward, and replay game states perfectly.
3.  **Logs Semantics**: It intercepts `puts` and converts logs into structured signals (`[STARGATE_VIEW]`) that external tools can parse to visualize the game's internal state.
4.  **Protects the Loop**: It wraps your code in a safety net. If your code errors, Stargate catches it, logs the causal node failure, and keeps the engine running (preventing crash-to-desktop).
5.  **Binds Code to Intent**: Via the Causal Graph, it physically links blocks of code to their YAML definitions. If you delete the YAML node, Stargate functionality allows you to auto-prune the dead code.

### ❌ WHAT IT DOES NOT DO (The Boundaries)
1.  **It is NOT a Game Engine**: It runs *inside* DragonRuby. DragonRuby handles the rendering, physics, and inputs. Stargate handles the *logic flow*.
2.  **It does NOT write code for you**: The AI writes the code. Stargate provides the *structure* (the Graph) that tells the AI where to write.
3.  **It is NOT magic**: It requires discipline. You must register your nodes in `.causal/index.yaml`. If you bypass the system, you lose the benefits.

---

Stargate-LLM-IA is built as a **Sovereign Operating System for Development**, structured in two complementary layers:

### 🛡️ Runtime Layer (Execution)
Governs what happens while the game is running.
*   **Analogy:** 🕹️ **This is the game world itself.**
*   It enforces deterministic execution, time sovereignty (tick vs timestamp), and emits semantic runtime signals (`[STARGATE_VIEW]`) instead of raw logs.
*   *Safety:* If something goes wrong, the game doesn’t crash blindly. It observes the error, keeps running, and preserves control.

### 🧠 Causal Layer (Editing)
Governs how the code is modified.
*   **Analogy:** 🧩 **Your codebase is a Graph of Lego blocks.** Each block has a label saying why it exists.
*   Code is not a flat list of files; it is a **Graph of Causal Nodes**. Every feature is isolated into a Node with a specific intention.
*   **Jarvis Protocol:** Your AI will understand **where to move** and **what NOT to touch**. It helps you build without destroying what already works.
*   **Legitimacy:** If a Node's intention is removed from the graph, its code loses legitimacy and is pruned. No "ghost code".

📜 **Authoritative specification:**  
See [`docs/architecture/CAUSAL_EDITING_MODEL.md`](docs/architecture/CAUSAL_EDITING_MODEL.md)

---

## 🤖 AI Pilot Instructions

This project is designed to be operated by a human **or** an AI acting as a **Constrained Pilot**. The AI is not a free-roaming refactorer; it is a surgical operator of the Causal Graph.

**Analogy:** ✈️ **The AI is not an autopilot flying wherever it wants.** It’s a trained co-pilot following strict rules.

### ▶️ Running the Game
Launch the DragonRuby runtime with Stargate enabled using:
```bash
run
```
*(Shorthand for `dragonruby-run`)*

### ✂️ Modifying the Code (Causal Editing)
**The AI MUST NOT scan or refactor files freely.** All modifications must follow the Causal Protocol:

1.  **Consult** `.causal/index.yaml` to understand the Map.
2.  **Identify** the single specific Causal Node responsible for the intent.
3.  **Operate** strictly within that node’s declared line ranges.
4.  **Legitimacy**: Every edit must serve the Node's declared intention. Orphaned code is prohibited.

**Analogy:** 📚 **You’re editing a book where each chapter has a contract.** You don’t rewrite the whole story to fix one paragraph.

---

## 🧬 How to Integrate Stargate (Step-by-Step)

Want to add Stargate to your existing DragonRuby project? Follow this ritual:

### Step 1: Infection (Install Core)
Copy the `app/stargate/` directory into your project's `app/` folder.
*   *Reality:* You are giving your project a brain.

### Step 2: The Contract (Initialize Graph)
Create a `.causal/` folder in your project root and add `index.yaml`.
*   Define your starting node (System Core).
*   *Reality:* You are signing the Twin Law.

### Step 3: Activation (Main Loop)
Open your `app/main.rb`. At the very top, inject the Stargate:

```ruby
# --- STARGATE-LLM-IA START ---
require "app/stargate/core.rb"

def tick(args)
  Stargate.activate!(args)
  # --- STARGATE-LLM-IA END ---

  # Your game logic lives here...
end
```

### Step 4: Protection (AI Rules)
Copy `.cursorrules` to your root directory.
*   *Reality:* You are teaching the AI the laws of this world.

---

## 🔄 THE TWIN LAW (⚠️ CRITICAL)

**`app/main.rb` and `.causal/index.yaml` are CONJOINED TWINS.**
They share a single life force. One cannot exist without the other.

**Analogy:** 🧠 **Brain and Memory.** You can’t change one without the other.

*   **Rule 1**: You CANNOT edit `main.rb` without updating `index.yaml`.
*   **Rule 2**: You CANNOT update `index.yaml` without editing `main.rb`.
*   **Consequence**: Discrepancy between Code (Reality) and Graph (Intent) is a FATAL ERROR. The flow will break.

---

## 🔬 Current Objective: The First Test

We are currently validating the **Causal Graph Model** by materializing our first **Generative Nodes** (`GraphNodeGen`).

**The Goal:**
Prove that we can create, modify, and delete a feature (e.g., `GraphNodeGenTextures`) strictly through Causal Operations, without touching the rest of the codebase.

**Success Criteria:**
1.  Node defined in `.causal/index.yaml`.
2.  Code generated only within its bounds.
3.  Effect visible in the Runtime.
4.  Causal Probe confirms the flow.

---

## 🧭 Causal Memory

*   **`docs/architecture/`**: The core philosophy and the Causal Editing Model.
*   **`.causal/`**: The digital memory of the graph (hidden from general view).
*   **`bin/stargate-reset`**: Re-syncs the Code and the Index to a Seed State.

---

## 📦 Ingredients (Samples)

Your creative ingredients are always close at hand.
The **`SDK-DR/samples/`** directory contains the official DragonRuby examples.

*   Use these samples as **reference material** when defining new Causal Nodes.
*   **Do not modify** the samples directly; treat them as an immutable library of knowledge.

---

## 🛡️ Philosophy
Built for **Commercial Sustainability**.
- **Causal Integrity**: Code exists for a reason, or it doesn't exist at all.
- **Node-Based Debugging**: We don't debug lines; we debug causal relationships.
- **Flow Preservation**: Scalability without cognitive collapse.

Build sustainably. Stay in the flow. 🌌🐉🟦

---

## 🏛️ Origins & Inspiration

Stargate-LLM-IA stands on the shoulders of giants. We are reviving the lost art of **Live Computing** and **Authoring Tools** from a more elegant era.

**These were "Live Systems".**
In these worlds, you didn't wait to see *"if it compiles"* or *"if it runs"*.
You iterated purely in your imagination, and the screen reflected your thoughts instantly.
There was no gap between Idea and Reality.

We honor this lineage:

*   **[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk)**: For the vision of a world where everything is alive, and there is no wall between "using" and "creating".
*   **[HyperCard](https://en.wikipedia.org/wiki/HyperCard)**: For the promise that anyone can build a universe just by stacking cards.
*   **[Spore / Splice](https://en.wikipedia.org/wiki/Spore_(2008_video_game))**: For the beauty of procedural evolution—where complexity blooms from simple rules.
*   **[Tomorrow Corporation Tech Demo](https://www.youtube.com/watch?v=72y2EC5fkcE)**: For the seamless, visual execution of logic in real-time.

We are bringing these ancient philosophies into the era of AI.

### 🌌 The Synthesis
Stargate seeks to bring back **what worked in the past** (immediacy, tangibility) and fuse it with **modern AI tools** (infinite generative potential).
It connects the lost art of Live Computing with the explosive imagination of today's Artificial Intelligence.

**Developing at the speed of thought. Again.**

