---
applyTo: "**/Hammerspoon/**"
---

## Hammerspoon Module: AI Coding Agent Guidelines

This directory manages all Hammerspoon (Lua) automation for the config-set environment. Follow these rules for code generation, review, and answering questions:

### Project Context

- All code in this folder is for macOS automation using Hammerspoon (https://www.hammerspoon.org/).
- The `src/` directory contains modular Lua scripts for window management, automation, and system integration.
- `init.lua` is the main entry point and exports global functions (via `_G`) for use by Apple Shortcuts, Raycast, and other tools.
- Feature modules are organized in `src/feats/` subdirectory.
- Utility modules are organized in `src/utils/` subdirectory.

### Coding Guidelines

- **Modularity**: Place new features in `src/feats/` unless tightly coupled with an existing module.
- **Globals**: Export only automation entrypoints as `_G` globals in `init.lua`. Avoid polluting global namespace.
- **Logging**: Use `src/utils/log.lua` for logging. Avoid `print` for persistent logs.
- **Documentation**: Add comment headers to new modules. Document all exported functions.
- **Notifications**: Prefer Raycast notifications (`src/utils/raycastNotification.lua`) over native Hammerspoon notifications.
- **JS-Style Utilities**: Use `src/utils/js.lua` for array/table operations (map, filter, forEach, etc.) and async/await patterns.
- **Early Returns**: Prefer early returns over nested if-else structures.

### Examples & Patterns

- See `src/feats/windowManager/` for window management logic and modularization.
- See `src/init.lua` for global exports and integration patterns.
- See `src/utils/js.lua` for JavaScript-style utility functions (array methods, etc.).
- See `src/utils/find.lua` for accessibility element search utilities.
- See `src/utils/ms.lua` for time conversion utilities.
- See `src/utils/raycastNotification.lua` for Raycast notification integration.
