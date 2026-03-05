# Config-Set: Personal Development Environment Configuration 🛠️

This repository manages a comprehensive collection of configuration files for a macOS development environment. Each directory contains configurations for specific tools, with automated linking and build systems.

## Architecture Overview 🏗️

**Configuration Management Pattern**: Each tool directory contains:

- Raw configuration files (dotfiles, JSON, YAML, Lua scripts)
- `link.sh` scripts for symlinking configs to proper system locations
- Custom build systems for tools requiring compilation/processing

**Key Tool Categories**:

- **Terminal/Shell** 🐚: Zsh (Oh My Zsh), Warp terminal with launch configurations
- **Window Management** 🪟: yabai + skhd + Hammerspoon for advanced macOS window control
- **Development Tools** 💻: VS Code (modular settings), Neovim, Karabiner Elements
- **Theming** 🎨: Extensive theme collections (Warp, VSCode token customizations)

## Critical Workflows ⚡

### VSCode Settings Management 📝

The `VSCode/settingsDotJson/` directory uses a **modular JSON merge system**:

```bash
cd VSCode/settingsDotJson && pnpm run build
```

- Source modules in `src/modules/*.json` are merged via TypeScript
- Build creates timestamped `build/settings.json` with automatic versioning
- Uses `comment-json` library to preserve comments in JSON

### Configuration Linking 🔗

Each tool has its own `link.sh` script that creates symlinks:

```bash
# Example pattern for any tool
cd <tool-directory> && ./link.sh
```

- Handles existing links gracefully (checks before creating)
- Links to standard config locations (`~/.config/`, `~/.hammerspoon/`, etc.)

#### Standard `link.sh` Template

Single file/directory link:

```bash
FROM=~/Code/config-set/<Tool>/<config-file>
TO=~/<target-path>/<config-file>

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
```

Loop-based link (multiple files):

```bash
TO_DIR=~/<target-dir>

for FROM in ~/Code/config-set/<Tool>/<pattern>; do
    TO="$TO_DIR/$(basename "$FROM")"
    rm -f "$TO"
    ln -s "$FROM" "$TO"
    echo "🔗 link $FROM -> $TO"
done
```

#### Standard `cp.sh` Template

```bash
FROM=~/Code/config-set/<Tool>/<build-output>
TO=~/<target-path>/<config-file>

cp "$FROM" "$TO"
echo "📋 copy $FROM -> $TO"
```

**Conventions**:

- Always define `FROM` and `TO` variables at the top
- Use `mkdir -p "$(dirname "$TO")"` to ensure target directory exists
- Use `rm -f` for file links, `rm -rf` for directory links
- Echo with 🔗 emoji for link operations, 📋 for copy operations
- Format: `echo "🔗 link $FROM -> $TO"` / `echo "📋 copy $FROM -> $TO"`

### Warp Launch Configurations 🚀

Project-specific workspace setups in `Warp/launch_configurations/`:

- Each YAML defines terminal layouts with specific directories and split panes
- Used for quickly launching development environments for different projects
- Contains real project paths (binjiang, yq-common, pbis, etc.)

## Project-Specific Conventions 🔧

### Multi-Machine Support 💻

Zsh configurations have machine-specific variants:

- `Zsh/Mac/MacBookProM2Max/` vs `Zsh/Mac/MacBookAirM3/`
- Different plugin sets and performance optimizations per machine

### Karabiner Complex Modifications ⌨️

JSON files in `KarabinerElements/` define advanced key mappings:

- **Double Command To Hyper M**: Complex timing-based key detection
- **Caps Lock transformations**: Context-aware modifier key behavior
- Uses Karabiner's variable system for stateful key handling

## Key Files to Reference 📁

- `VSCode/settingsDotJson/src/merge.ts` - JSON module merge logic
- `Hammerspoon/src/init.lua` - Global function exports for system integration
- `yabai/yabairc` + `skhd/skhdrc` - Window management configuration pair
- `Zsh/module/link.sh` - Oh My Zsh custom module linking pattern
- `Warp/launch_configurations/*.yaml` - Project workspace templates

## Development Notes 📝

- **TypeScript builds** use `tsx` for direct TS execution without compilation
- **Symlink management** is idempotent - safe to re-run link scripts
- **Theme management** follows base16 architecture for color consistency
- **Cross-tool integration** via shell exports, global functions, and shared keybindings
