# Stargate-LLM-IA

**"The index is a derived map, not a governing authority."**  
**"Authority in Stargate resides in the interposition layer, not in documentation artifacts."**

A causal indexing system for controlling how LLMs read and modify code.

---

## What is this?

Stargate is a **control layer for LLM-assisted development**.

It introduces an explicit, human-maintained **causal index** that records *why* code exists, and forces an LLM to reference that intent before proposing or applying changes.

Stargate does not generate features, refactor code automatically, or replace human decisions.  
Its purpose is to **reduce unintended changes and loss of intent** when working with LLMs on an existing codebase.

---

## What problem does it address?

When using LLMs (Cursor, Copilot, local models) on real projects:

- Context is implicit and fragile
- The model modifies code without understanding why it exists
- Changes fix one thing and silently break another
- Developers lose trust in letting the LLM touch the code

Stargate addresses **intent loss**, not code quality.

---

## What Stargate is (and is not)

### Stargate is:
- A folder structure + ruleset
- A causal index (`index.yaml`) describing code intent
- A discipline enforced through tooling
- A way to constrain LLM behavior

### Stargate is NOT:
- A framework
- An API
- A runtime engine
- A refactoring tool
- A guarantee against bugs
- A “scale infinitely” solution
- **A system where an editable index is the primary source of truth**

---

## Core idea

Every meaningful piece of code should answer three questions:

1. What does it do?
2. Why does it exist?
3. What depends on it?

Stargate stores those answers in a **causal index** and requires the LLM to consult that index before acting.

If the intent is unclear, the LLM must stop.

---

## How it works (high level)

1. The LLM analyzes the existing codebase
2. It maps files and responsibilities into `stargate/index.yaml`
3. Each entry represents a **causal node** (an intent)
4. Future changes must:
   - Reference an existing node, or
   - Explicitly introduce a new one

Code is not modified unless its intent is accounted for.

---

## Installation (DragonRuby example)

Copy the following into your project directory:

```text
mygame/
├── app/
├── stargate/
├── .cursorrules
└── samples/ (optional)
```

Activate Stargate in `app/main.rb`:

```ruby
def tick(args)
  require "stargate/bootstrap.rb"
  Stargate.initialize_context(args)

  # Game logic continues normally
end
```

**Important:**
- This does not change game behavior
- It initializes context for LLM interaction
- It does not run AI code at runtime

---

## Using Stargate with an LLM

The first interaction is mapping only.

**Example prompt:**
```text
Read .cursorrules.
Analyze app/main.rb.
Create a causal map in stargate/index.yaml.
Do not modify source files.
This is an observation phase only.
```

You can also use `run` or `dragonruby-run` to launch DragonRuby.

After this, any change must be justified through the causal index.

---

## Why not comments or documentation?

Comments describe *what* code does.

Stargate records:
- **Why** the code exists
- **What assumptions** it relies on
- **What other parts** depend on it

This matters when:
- Letting an LLM modify unfamiliar code
- Returning to a project after time
- Evaluating the impact of a change

---

## Limitations

- Requires manual discipline
- The causal index can drift if ignored
- Best suited for small to medium projects
- Current tooling assumes Cursor-style workflows

These are known trade-offs.

---

## Who is this for?

- Developers experimenting with LLM-assisted coding
- Projects where predictability matters more than speed
- People who want to understand changes, not just apply them

---

## Documentation

- **Philosophy**: [DESIGN.md](stargate/docs/DESIGN.md)
- **Constitution**: [`stargate/docs/CAUSAL_INDEX_LAWS.md`](stargate/docs/CAUSAL_INDEX_LAWS.md)
- **API Contract**: [`stargate/docs/PUBLIC_CONTRACT.md`](stargate/docs/PUBLIC_CONTRACT.md)
- **Index Schema**: [`stargate/docs/INDEX_SCHEMA.md`](stargate/docs/INDEX_SCHEMA.md)
- Technical details: [`stargate/docs/TECHNICAL_DETAILS.md`](stargate/docs/TECHNICAL_DETAILS.md)
- Causal editing model: [`stargate/docs/architecture/CAUSAL_EDITING_MODEL.md`](stargate/docs/architecture/CAUSAL_EDITING_MODEL.md)
- Reset tool: `stargate/bin/stargate-reset`

---

## Status

This project is **experimental**.

- The ideas are stable.
- The implementation is evolving.

Critical feedback is welcome.
