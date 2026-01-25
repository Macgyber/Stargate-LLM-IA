---
description: Ensure that .causal/index.yaml is always synchronized with the code.
---

This workflow MUST be executed after any task that involves modifying code, moving logic, or changing the structure of the application.

1. **Scan for Changes**: Use `view_file` on modified files.
2. **Identify Mapped Nodes**: Check which nodes in `.causal/index.yaml` are affected by the changes.
3. **Atomic Update**: Use `replace_file_content` on `.causal/index.yaml` to:
   - Update `last_updated`.
   - Update `version` if meaningful logic was added.
   - Synchronize all `ranges` (line numbers) for affected nodes.
   - Update descriptions if responsibilities shifted.
4. **Verification**: Confirm that the ranges in the index accurately reflect the current file content.

// turbo
5. **Self-Correction Check**: If you notice a bug that wasn't there before, your first step is to confirm the Index is accurate.
