---
description: This file provides guidelines for the Hammerspoon (Lua) automation modules in the config-set environment.
applyTo: "**/Hammerspoon/**"
---

## Hammerspoon Module: AI Coding Agent Guidelines

When using this instructions, say "⌘ Using hammerspoon.instructions.md" explicitly, this is very very important.

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
- **JS-Style Utilities**: Use `src/utils/js.lua` for array/table operations (map, filter, forEach, etc.) and async/await patterns. **When adding or removing functions from `js.lua`, always update the `### js.lua Available Functions` table in `.github/instructions/hammerspoon.instructions.md`.**
- **Early Returns**: Prefer early returns over nested if-else structures.
- **Async Naming**: All functions that return a Promise (use `async`/`await`) **must** be suffixed with `_async` in feature modules (e.g., `tidyMainScreen_async`, `setMode_async`). In `js.lua`, follow the JS camelCase convention instead: `forEachAsync`, `mapAsync`, `retryAsync`.

### Module Import Conventions

- **Default**: Use `module.xxx` style for calling module methods (e.g., `log.d(...)`, `find.byRole(...)`). This is the standard convention unless explicitly stated otherwise.
- **Exception — `js.lua`**: Always destructure/unpack `js.lua` functions at the top of the file and call them **directly** (e.g., `map(...)`, `filter(...)`, `diff(...)`). **Never** use `js.map(...)` or `js.diff(...)` style.

  ```lua
  -- Correct: destructure js.lua functions
  local js = require("Utils.js")
  local map, filter, diff, includes = js.map, js.filter, js.diff, js.includes

  local result = map(items, function(item) return item.name end)
  local changed = diff(oldList, newList)

  -- Wrong: do NOT use js.xxx
  local js = require("Utils.js")
  local result = js.map(items, function(item) return item.name end)
  ```

### `js.lua` Available Functions

Always destructure only what you need at the top of the file.

| Function                     | JS Equivalent                | Description                                                                             |
| ---------------------------- | ---------------------------- | --------------------------------------------------------------------------------------- |
| `merge(...arrays)`           | `[...a, ...b]`               | Flatten multiple arrays into one                                                        |
| `includes(table, value)`     | `array.includes(v)`          | Check if array contains a value                                                         |
| `map(array, fn)`             | `array.map(fn)`              | Transform elements, return new array                                                    |
| `forEach(array, fn)`         | `array.forEach(fn)`          | Iterate elements, no return                                                             |
| `filter(array, fn)`          | `array.filter(fn)`           | Return elements passing predicate                                                       |
| `find(array, fn)`            | `array.find(fn)`             | Return first matching element or nil                                                    |
| `reduce(array, fn, init?)`   | `array.reduce(fn, init)`     | Accumulate to a single value                                                            |
| `flat(array, depth?)`        | `array.flat(depth)`          | Flatten nested arrays                                                                   |
| `flatMap(array, fn)`         | `array.flatMap(fn)`          | Map then flatten one level                                                              |
| `diff(array, other, keyFn?)` | `differenceBy()`             | Elements in first not in second                                                         |
| `forEachEntries(object, fn)` | `Object.entries().forEach()` | Iterate key-value pairs of a table                                                      |
| `values(object)`             | `Object.values()`            | Return array of table values                                                            |
| `forEachAsync(array, fn)`    | —                            | Async forEach, use with `await`                                                         |
| `mapAsync(array, fn)`        | —                            | Async map, use with `await`                                                             |
| `debounce(options, fn)`      | `debounce()`                 | Delay fn until `options.delay` ms idle; returns `.cancel()`, `.flush()`, `.isPending()` |
| `throttle(options, fn)`      | `throttle()`                 | Invoke immediately, ignore within `options.interval` ms; returns `.isThrottled()`       |

### Examples & Patterns

- See `src/feats/windowManager/` for window management logic and modularization.
- See `src/init.lua` for global exports and integration patterns.
- See `src/utils/js.lua` for JavaScript-style utility functions (array methods, etc.).
- See `src/utils/find.lua` for accessibility element search utilities.
- See `src/utils/ms.lua` for time conversion utilities.
- See `src/utils/raycastNotification.lua` for Raycast notification integration.
