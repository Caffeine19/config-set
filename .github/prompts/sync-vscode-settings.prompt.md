---
description: "Sync VSCode dist.json changes back to source modules. Use when dist.json has been modified and changes need to be reflected in src/modules/*.json files."
agent: "agent"
---

# Sync VSCode Settings to Source Modules

Sync uncommitted changes in [dist.json](../../VSCode/settingsDotJson/build/dist.json) back to the corresponding source module files in [src/modules](../../VSCode/settingsDotJson/src/modules).

## Steps

1. **Detect changes**: Diff the live VSCode settings file (`~/Library/Application Support/Code/User/settings.json`) against the built [dist.json](../../VSCode/settingsDotJson/build/dist.json) to identify added, removed, or modified settings.

2. **Map each setting to its module**: For each changed setting key `"aaa.bbb.ccc"`:
   - First check if the setting already exists in any module file — if so, update it there.
   - Otherwise, look for a module named `aaa.bbb.json` (e.g., `editor.tokenColorCustomizations.json`).
   - Then try `aaa.json` (e.g., `editor.json`, `git.json`, `vim.json`).
   - If no matching module exists, place it in `$settings.json`.

3. **Apply edits**: Update each module file to add/remove/modify the setting, preserving the existing style (comments, grouping, spacing).

4. **Rebuild and verify**: Run `cd VSCode/settingsDotJson && pnpm run build-all` and confirm the rebuilt `dist.json` diff matches the original changes (ignoring the build timestamp).

## Key module mappings for reference

- `chat.*`, `github.copilot.*`, `inlineChat.*` → `githubCopilotChat.json`
- `vim.*` → `vim.json`
- `editor.*` → `editor.json` or `editor.tokenColorCustomizations.json`
- `git.*`, `gitlens.*`, `scm.*`, `diffEditor.*` → `git.json`
- `workbench.*` → `workbench.json`
- `window.*` → `window.json`
- `terminal.*` → `terminal.json`
- `vscode_custom_css.*` → `vscodeCustomCssAndJs.json`
- `animations.*` → `animations.json`
- `catppuccin.*` → `catppuccin.json`
- `cSpell.*` → `codeSpellCheck.json`
- `[language]` formatters → `languageFormatter.json`
- `vscode-neovim.*` → `neovim.json`
