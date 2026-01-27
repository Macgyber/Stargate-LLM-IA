# <img src="stargate_AI/docs/images/logo.png" width="120" height="120" align="right" /> 🌌 Stargate-LLM-IA
### *Causal Programming: From text files to intent maps.*

---

> **"Reclaiming the magic of living systems from the past so that human will always remains the master of technology."**

---
<<<<<<< HEAD

## ⚡ The Pitch
**Stargate** is not a tool for writing code; it is a tool for never getting lost.

When using AI for programming, projects often spiral into a chaos of files that no one understands. Stargate forces both the AI and the human to follow a **Causal Map**: a logical diagram where every line of code has an explicit reason for being. If there is no reason, there is no code.
=======
## ⚡ The Pitch
**Stargate** is not a tool for writing code; it is a tool for **never getting lost**. 

When using AI for programming, projects often spiral into a chaos of files that no one understands. Stargate forces both the AI and the human to follow a **Causal Map**: a logical diagram where every line of code has an explicit *reason for being*. If there is no reason, there is no code. 
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434

**Result:** You can scale projects infinitely with AI without the code breaking or turning into "garbage."

---

## 🧩 Core Concept
Imagine that building software is like assembling a **10,000-piece giant LEGO set** with an assistant, or installing a **Minecraft Mod**:
<<<<<<< HEAD

=======
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
*   **Without Stargate:** The assistant places pieces without order. Eventually, you have a structure that looks okay, but if you move anything, everything collapses and no one knows why.
*   **With Stargate:** You use a **living instruction manual** (inside the `stargate_AI/` folder). Every piece is linked to a page in the manual. If you want to change something, the system knows exactly what to touch and what must remain intact. Just like when you swap a Mod folder to add a new feature without breaking the game.

> [!TIP]
> **In short:** Stargate is the order engine that allows you to scale at maximum speed without losing control.

---

## 🚀 "Plug & Play" Installation (Mod Style)
<<<<<<< HEAD

> [!IMPORTANT]
> **THE 2 MAGIC ELEMENTS:** To activate Stargate, you only need to copy and paste these 2 elements into your game's main folder:

1.  📂 **`stargate_AI/`**: The folder containing the brain, the map, and the guides.
2.  📜 **`.cursorrules`**: The "sacred" instructions for the AI.
3.  📂 **`samples/` (Optional)**: The Ingredients (Code samples usually included in DragonRuby). These provide a local source of knowledge; even a local AI can use them to build your project without "hallucinating" or inventing external patterns.

It should look like this inside your game folder (where `app/` is located):
=======
> [!IMPORTANT]
> **THE 2 MAGIC ELEMENTS:** To activate Stargate, you only need to copy and paste these 2 elements into your game's main folder:
> 1.  📂 **`stargate_AI/`**: The folder containing the brain, the map, and the guides.
> 2.  📜 **`.cursorrules`**: The "sacred" instructions for the AI.
> 3.  📂 **`samples/` (Optional)**: **The Ingredients** (Code samples usually included in DragonRuby). These provide a local source of knowledge; even a local AI can use them to build your project without "hallucinating" or inventing external patterns.

**It should look like this inside your game folder (where `app/` is located):**
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434

```text
dragonruby/ (or wherever you have it installed)
└── mygame/          <-- YOUR GAME FOLDER
    ├── app/         <-- (where your main.rb is)
    ├── stargate_AI/ <-- (folder you copied)
    └── .cursorrules <-- (file you copied)
```

### 📋 One-Step: Activate the Code
Copy these two lines at the beginning of your `tick` function in `app/main.rb`:

```ruby
def tick(args)
  require "stargate_AI/core.rb" # 👈 Step 1
  Stargate.activate!(args)      # 👈 Step 2
  
  # Your game starts here...
end
```

---

## 🤖 How to Talk to the AI
<<<<<<< HEAD
It's time to ignite the engines and let your imagination light the way.

To unleash the full power of Stargate, use this **"Passage 1: The Ignition"** prompt. This is an observation phase: the AI will analyze your project to create its first Causal Map without deleting or overwriting your current code—it’s designed to understand you, not replace you.
=======
### *It's time to ignite the engines and let your imagination light the way.*

To unleash the full power of Stargate, use this **"Passage 1: The Ignition"** prompt. This is an **observation phase**: the AI will analyze your project to create its first Causal Map without deleting or overwriting your current code—it’s designed to understand you, not replace you.
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434

```text
"Initiating Stargate-LLM-IA Protocol. 

1. Read `.cursorrules` to adopt your new logic and constraints.
2. Analyze my current `app/main.rb` to understand its core intentions.
3. MAP my existing code into Causal Nodes in `stargate_AI/index.yaml`. Observe and index my work without modifying my source files. This is a mapping phase, not a refactoring phase.
4. Search for 'The Ingredients' in any `samples/` folder to align with my style.

From now on, you are the pilot of a Causal System. Do not write code without an intent in the map. Transform my text files into a Sovereign Graph. Are you ready?"
```
<<<<<<< HEAD
### ▶️ Running the Game
To launch your project with Stargate enabled, simply use:

```bash
run
```
or
```bash
dragonruby-run
```
*(This is the shorthand for starting your DragonRuby simulation).*
---

## 🛠️ Quick Access
*   🚀 **[HOW DOES IT WORK? (TECHNICAL DETAILS)](stargate_AI/docs/TECHNICAL_DETAILS.md)**: Everything about installation and the internal engine.
*   🧠 **[PHILOSOPHY & ARCHITECTURE](stargate_AI/docs/architecture/CAUSAL_EDITING_MODEL.md)**: The "why" behind the system.
*   📜 **[THE CAUSAL MANIFESTO](stargate_AI/docs/TECHNICAL_DETAILS.md#origins-&-inspiration)**: The vision and origin of Stargate.
=======

---

## 🛠️ Quick Access

*   🚀 **[HOW DOES IT WORK? (TECHNICAL DETAILS)](stargate_AI/docs/TECHNICAL_DETAILS.md)**: Everything about installation and the internal engine.
*   🧠 **[PHILOSOPHY & ARCHITECTURE](stargate_AI/docs/architecture/CAUSAL_EDITING_MODEL.md)**: The "why" behind the system.
*   📜 **[THE CAUSAL MANIFESTO](stargate_AI/docs/architecture/WHY_THIS_EXISTS.md)**: The vision and origin of Stargate.
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
*   🔄 **[SYSTEM RESET](stargate_AI/bin/stargate-reset)**: Tool to synchronize the map and the code.

---

## 🏛️ Inspiration
Reviving the golden age of creative tools:
<<<<<<< HEAD

=======
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
*   **[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk)**
*   **[HyperCard](https://en.wikipedia.org/wiki/HyperCard)**
*   **[Spore](https://en.wikipedia.org/wiki/Spore_(2008_video_game))**
*   **[Tomorrow Corporation Tech Demo](https://www.youtube.com/watch?v=72y2EC5fkcE)**

**Developing at the speed of thought. Again.** 🌌🐉🟦
