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

## 📊 Causal Flow Diagram (Sovereign)

```text
    [GAMEPLAY]       [BRIDGE (main.rb)]     [AVATAR]
        |                  |                   |
    Stargate.intent   Avatar.render <------- Pulse / Fail-safe
        |                  |                   |
        v                  v                   |
    +-----------------------------------------------------+
    |           SOVEREIGN BRIDGE (Main Loop)              |
    +-----------------------------------------------------+
        |                  |                   |
        |           Check Status / Stasis?     |
        |                  |                   |
        +--------+---------+---------+---------+
                 |                   |
           [OK]--+           [CRASH / STASIS]--+
                 |                   |         |
         +-------v-------+   +-------v-------+ |
         | CLOCK.tick    |   | AVATAR RENDERS| |
         |   (Game)      |   |   STASIS HUD  | |
         +-------+-------+   +---------------+ |
                 |                             |
         +-------v-------+            +--------v--------+
         | STATE.CAPTURE |            | FAIL-SAFE VISUAL|
         +---------------+            +-----------------+
```

---

## 🔍 What Stargate Actually Does (Sovereign Edition)

### ✅ WHAT IT DOES (The Capabilities)
1.  **Sovereign Bridge**: Prevents "Gray Screen" by guaranteeing a visual call (`Avatar`) before logic.
2.  **Continuity over Stability**: If your code crashes, Stargate catches the error and keeps the engine running in "Fail-Safe Mode".
3.  **Passive Vigilante**: Senses mutations and logic leaks without stopping the engine loop or writing to disk during tick.
4.  **Forensic Ledger**: Audits the codebase offline to detect missing intentions or "ghost code" without affecting 60FPS performance.
5.  **Causal Memory**: Only captures state when an `Intent` or `Injection` occurs, keeping the system lightweight.

### ❌ WHAT IT DOES NOT DO (The Boundaries)
1.  **NO es un Engine**: Vive dentro de DragonRuby. Stargate maneja el flujo lógico, DR el resto.
2.  **NO es un Autopilot**: El humano define la intención; Stargate protege la ejecución de esa intención.
3.  **NO es ruidoso**: El silencio es salud. Si todo va bien, Stargate es invisible.

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
3. MAP my existing code into Causal Nodes in `stargate/index.yaml`. 
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

1.  **Consult** `stargate/index.yaml` to understand the Map.
2.  **Refer** to any `samples/` directory found in the project (usually included with your DragonRuby copy). These are the **Sovereign Examples**. The AI must mirror their style and structure to prevent hallucinations.
3.  **Identify** the single specific Causal Node responsible for the intent.
4.  **Operate** strictly within that node’s declared line ranges.
5.  **Legitimacy**: Every edit must serve the Node's declared intention. Orphaned code is prohibited.

**Analogy:** 📚 **You’re editing a book where each chapter has a contract.** You don’t rewrite the whole story to fix one paragraph.

---

## 🧬 How to Integrate Stargate (Step-by-Step)

Want to add Stargate to your existing DragonRuby project? Follow this ritual:

### Step 1: The Package
Copy the `stargate/` folder into your project's root directory (next to your `app/` folder).

```text
my-project/
├── app/          <-- (your code)
├── stargate/     <-- (this package)
└── mygame.exe
```

### Step 2: The Sovereign Bridge (main.rb)
Replace your standard `tick` with the **Sovereign Bridge**. This is the single most important stability requirement:

```ruby
require "stargate/bootstrap.rb"

def tick args
  # LEY 1.1: Render First (Avatar)
  Stargate::Avatar.render(args, fail_safe: $stargate_fail_safe)
  
  begin
    # LEY 5: Initial Boot
    unless Stargate.status[:booted]
      Stargate.initialize_context(args)
    end

    # LEY 5.1: Bridge Flow Control
    if $stargate_stasis_requested && !Stargate::Clock.paused?
      Stargate::Clock.pause!
    end

    # Your actual game logic
    run_game_tick(args)
  rescue => e
    # LEY 10.1: Fail-Safe Visual
    $stargate_fail_safe = e
  end
end
```

### Step 3: Protection (AI Rules)
Move the file `stargate/.cursorrules` to your project's root directory.
*   *Reality:* You are teaching the AI the laws of this world.

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
