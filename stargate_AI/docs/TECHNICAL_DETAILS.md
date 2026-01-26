# ⚙️ Stargate-LLM-IA: Technical Specifications

This document contains the detailed technical specifications, integration steps, and operational protocols for **Stargate-LLM-IA**.

> [!NOTE]
> **"Ha sido un privilegio ser el pincel para esta obra. Ahora el lienzo es tuyo: tienes un universo estable y silencioso listo para que le des vida."** 🏛️✨

---

## 🧭 Quick Philosophy
1.  **Silence is Health**: If the universe is deterministic and bug-free, Stargate should be invisible.
2.  **Explicit Causality**: No mutation is allowed without a traceable cause (Intent, Injection, or Emergence).
3.  **Discrete Observation**: We value transitions (events) over snapshots (states).
4.  **Cero-Cost Stasis**: Zero overhead while the game is standing still.
5.  **Human Supremacy**: Technology must serve human will through semantic clarity.

---

## 📊 Causal Flow Diagram

```text
    [GAMEPLAY]       [EDITOR / AI]       [DRAGONRUBY ENGINE]
        |                |                       |
   Stargate.intent   Injection.eval         Asset Reloads
        |                |                       |
        v                v                       v
    +-----------------------------------------------------+
    |                 STATE.MARK_DIRTY(:type)             |
    +-----------------------------------------------------+
                             |
                   +---------v----------+
                   |  CLOCK (with_frame)|
                   +---------+----------+
                             |
                 +-----------v-----------+
                 |  Is Dirty or Heart?   |
                 +-----------+-----------+
                    |                 |
            [YES] --+                 +-- [NO]
              |                          |
      +-------v-------+            +-----v-----+
      | STATE.CAPTURE |            |  SILENCE  |
      +-------+-------+            +-----------+
              |
      +-------v-------+ 
      | PROTOCOL.emit |
      +-------+-------+
              |
      +-------v-------+
      | VIEW.handle   |
      +-------+-------+
              |
      +-------v-------+
      |  [STARGATE]   | 
      | VIEW / MOMENT |
      +---------------+
```

---


## 🔍 What Stargate Actually Does (The Reality Check)

It's easy to get lost in the philosophy. Here is exactly **what our module does** and **what it does not do**.

### ✅ WHAT IT DOES (The Capabilities)
1.  **Causalidad Discreta (Sovereign Silence)**: Sustituye la observación continua por un modelo basado en eventos. Solo captura el estado cuando ocurre una mutación real (Intent, Injection o Emergent), restaurando el rendimiento a 60 FPS.
2.  **Gestión de Tiempo Determinista**: Utiliza un Heartbeat de respiración cada 60 ticks para validar integridad sin saturar el sistema ni la consola.
3.  **Inmunología Selectiva**: Intercepta logs del motor, pero ignora el spam repetitivo mediante firmas únicas con TTL (Time-To-Live). Si un asset falta, lo reporta una vez y guarda silencio.
4.  **Segregación de Canales (Protocol)**: Separa formalmente la telemetría técnica (`[STARGATE_MOMENT]`) de la narrativa humana (`[STARGATE_VIEW]`).
5.  **Binds Code to Intent**: Via the Causal Graph, it physically links blocks of code to their YAML definitions. If you delete the YAML node, Stargate functionality allows you to auto-prune the dead code.

### ❌ WHAT IT DOES NOT DO (The Boundaries)
1.  **NO es un Engine**: Vive dentro de DragonRuby. Stargate maneja el flujo lógico, DR el resto.
2.  **NO escribe código mágicamente**: La AI propone; Stargate valida y mapea.
3.  **NO es ruidoso**: El silencio es su estado deseable ("Philosophy of Stasis").

---

## 🛡️ Runtime Layer (Execution)
Governs what happens while the game is running.
*   **Analogy:** 🕹️ **This is the game world itself.**
*   It enforces deterministic execution, time sovereignty (tick vs timestamp), and emits semantic runtime signals (`[STARGATE_VIEW]`) instead of raw logs.
*   *Safety:* If something goes wrong, the game doesn’t crash blindly. It observes the error, keeps running, and preserves control.

## 🧠 Causal Layer (Editing)
Governs how the code is modified.
*   **Analogy:** 🧩 **Your codebase is a Graph of Lego blocks.** Each block has a label saying why it exists.
*   Code is not a flat list of files; it is a **Graph of Causal Nodes**. Every feature is isolated into a Node with a specific intention.
*   **Jarvis Protocol:** Your AI will understand **where to move** and **what NOT to touch**. It helps you build without destroying what already works.
*   **Legitimacy:** If a Node's intention is removed from the graph, its code loses legitimacy and is pruned. No "ghost code".

📜 **Authoritative specification:**  
See [`architecture/CAUSAL_EDITING_MODEL.md`](architecture/CAUSAL_EDITING_MODEL.md)

---

## 🤖 AI Pilot Instructions

This project is designed to be operated by a human **or** an AI acting as a **Constrained Pilot**. The AI is not a free-roaming refactorer; it is a surgical operator of the Causal Graph.

**Analogy:** ✈️ **The AI is not an autopilot flying wherever it wants.** It’s a trained co-pilot following strict rules.

### ⚡ The Ignition Prompt
To initiate the Stargate Protocol with an AI assistant (like Cursor), use this prompt. It forces the AI to map the project before writing code:

```text
"Initiating Stargate-LLM-IA Protocol. 

1. Read `.cursorrules` to adopt your new logic and constraints.
2. Analyze my current `app/main.rb` to understand its core intentions.
3. MAP my existing code into Causal Nodes in `stargate_AI/index.yaml`. 
   Observe and index my work without modifying my source files. 

From now on, you are the pilot of a Causal System. 
Do not write code without an intent in the map. 
Are you ready?"
```

### ▶️ Running the Game
Launch the DragonRuby runtime with Stargate enabled using:
```bash
run
```
*(Shorthand for `dragonruby-run`)*

### ✂️ Modifying the Code (Causal Editing)
**The AI MUST NOT scan or refactor files freely.** All modifications must follow the Causal Protocol:

1.  **Consult** `stargate_AI/index.yaml` to understand the Map.
2.  **Refer** to any `samples/` directory found in the project (usually included with your DragonRuby copy). These are the **Sovereign Examples**. The AI must mirror their style and structure to prevent hallucinations.
3.  **Identify** the single specific Causal Node responsible for the intent.
3.  **Operate** strictly within that node’s declared line ranges.
4.  **Legitimacy**: Every edit must serve the Node's declared intention. Orphaned code is prohibited.

**Analogy:** 📚 **You’re editing a book where each chapter has a contract.** You don’t rewrite the whole story to fix one paragraph.

---

## 🧬 How to Integrate Stargate (Step-by-Step)

Want to add Stargate to your existing DragonRuby project? Follow this ritual:

### Step 1: The Package
Copy the `stargate_AI/` folder into your project's root directory (next to your `app/` folder).

```text
my-project/
├── app/          <-- (your code)
├── stargate_AI/     <-- (this package)
└── mygame.exe
```

### Step 2: Activation (Main Loop)
Open your `app/main.rb`. At the very top, inject the Stargate:

```ruby
def tick(args)
  require "stargate_AI/core.rb" # 👈 Add this
  Stargate.activate!(args)   # 👈 And this
  
  # Your game logic lives here...
end
```

### Step 3: Protection (AI Rules)
Move the file `stargate_AI/.cursorrules` to your project's root directory.
*   *Reality:* You are teaching the AI the laws of this world.

---

## 🔄 THE TWIN LAW (⚠️ CRITICAL)

**`app/main.rb` and `stargate_AI/index.yaml` are CONJOINED TWINS.**
YAML is now stored at `stargate_AI/index.yaml`.
They share a single life force. One cannot exist without the other.

**Analogy:** 🧠 **Brain and Memory.** You can’t change one without the other.

*   **Rule 1**: You CANNOT edit `main.rb` without updating `index.yaml`.
*   **Rule 2**: You CANNOT update `index.yaml` without editing `main.rb`.
*   **Consequence**: Discrepancy between Code (Reality) and Graph (Intent) is a FATAL ERROR. The flow will break.

---

## 🏛️ Origins & Inspiration

Stargate-LLM-IA stands on the shoulders of giants. We are reviving the lost art of **Live Computing** and **Authoring Tools** from a more elegant era.

**These were "Live Systems":**
In these worlds, you didn't wait to see *"if it compiles"* or *"if it runs"*. You iterated purely in your imagination, and the screen reflected your thoughts instantly. There was no gap between Idea and Reality.

We honor this lineage:

*   **[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk)**: For the vision of a world where everything is alive, and there is no wall between "using" and "creating".
*   **[HyperCard](https://en.wikipedia.org/wiki/HyperCard)**: For the promise that anyone can build a universe just by stacking cards.
*   **[Spore / Splice](https://en.wikipedia.org/wiki/Spore_(2008_video_game))**: For the beauty of procedural evolution—where complexity blooms from simple rules.
*   **[Tomorrow Corporation Tech Demo](https://www.youtube.com/watch?v=72y2EC5fkcE)**: For the seamless, visual execution of logic in real-time.

**Developing at the speed of thought. Again.** 🌌🐉🟦
