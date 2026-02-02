---
applyTo: "**/Hammerspoon/**"
---

## Hammerspoon Module: AI Coding Agent Guidelines

This directory manages all Hammerspoon (Lua) automation for the config-set environment. Follow these rules for code generation, review, and answering questions:

### Project Context

- All code in this folder is for macOS automation using Hammerspoon (https://www.hammerspoon.org/).
- The `src/` directory contains modular Lua scripts for window management, automation, and system integration.
- `init.lua` is the main entry point and exports global functions (via `_G`) for use by Apple Shortcuts, Raycast, and other tools.
- Scripts are designed to interoperate with yabai, skhd, Karabiner, and other config-set tools.
- Logging (for debugging) is written to the `log/` directory.
- Feature modules are organized in `src/feats/` subdirectory.
- Utility modules are organized in `src/utils/` subdirectory.

### Coding Guidelines

- **Modularity**: Place new features in their own file in `src/feats/` unless tightly coupled with an existing module.
- **Globals**: Export only intended automation entrypoints as `_G` globals in `init.lua`. Avoid polluting the global namespace.
- **Integration**: Prefer calling out to other config-set tools (e.g., yabai, skhd) via shell commands or AppleScript when possible.
- **Idempotency**: Functions should be safe to call repeatedly and not leave the system in an inconsistent state.
- **Logging**: Use the logging utility (see `src/utils/js.lua`) for debug output. Do not use `print` for persistent logs.
- **Error Handling**: Fail gracefully—return `nil, err` or log errors, do not crash Hammerspoon.
- **Documentation**: Add a comment header to each new module describing its purpose and usage. Document all exported functions.
- **No hardcoded paths**: Use environment variables or config-set conventions for any file paths.

### Examples & Patterns

- See `src/feats/windowManager/` for window management logic and modularization.
- See `src/init.lua` for global exports and integration patterns.
- See `src/utils/js.lua` for JavaScript-style utility functions (array methods, etc.).
- See `src/utils/find.lua` for accessibility element search utilities.
- See `src/utils/ms.lua` for time conversion utilities.
- See `src/utils/raycastNotification.lua` for Raycast notification integration.

### Integration Points

- Functions in this module are called by Raycast, Apple Shortcuts, and other automations. Maintain backward compatibility for exported APIs.
- Coordinate with other config-set tools (e.g., update window state in yabai if moving windows).

### Review Checklist

- [ ] New modules are placed in `src/feats/` and documented
- [ ] No unnecessary globals or hardcoded paths
- [ ] Logging uses the provided utility
- [ ] Functions are idempotent and error-tolerant
- [ ] Integration with other tools is robust
