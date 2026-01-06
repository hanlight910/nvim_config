# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration repository using Packer.nvim as the plugin manager. The configuration is structured in a modular way with custom utilities, keybindings, and extensive plugin integrations for development across multiple languages (Python, Java, C/C++, Rust, JavaScript, Dart/Flutter).

## Architecture

### Entry Point & Loading Order

The configuration loads in this sequence:
1. `init.lua` → requires `theprimeagen.init`
2. `lua/theprimeagen/init.lua` → loads modules in order:
   - `variables.lua` (global paths and environment setup)
   - `packer.lua` (plugin definitions)
   - `set.lua` (vim options and settings)
   - `remap.lua` (core keybindings)
   - `my_utils/time_track.lua` (time tracking initialization)
3. Plugin configurations in `after/plugin/*.lua` (loaded automatically by Neovim after plugins are installed)

### Core Module Structure

- `lua/theprimeagen/variables.lua`: Defines global vim.g variables for paths (archive, projects, config directories). These are used extensively in keybindings and functions.
- `lua/theprimeagen/functions.lua`: Large collection of utility functions for window/buffer navigation, terminal management, code running/compilation, file operations, and custom workflows.
- `lua/theprimeagen/my_utils/`: Custom utility modules loaded as needed.
- `lua/theprimeagen/utils.lua`: Provides `safe_require()` function used throughout to gracefully handle missing plugins.

### Plugin Configuration Pattern

All plugin configurations follow this pattern:
1. Use `safe_require()` from `theprimeagen.utils` to check if plugin exists
2. If plugin not available, return nil early (fail gracefully)
3. Configure plugin with custom settings
4. Set up keybindings specific to that plugin

Example from `after/plugin/telescope.lua`:
```lua
local util = require('theprimeagen.utils')
local stat = util.safe_require("telescope")
if not stat then return nil end
-- ... configuration ...
```

### Terminal Management System

The configuration has a sophisticated terminal management system:
- Functions like `open_terminal()`, `move_to_terminal_window()`, `cycle_hidden_terminal_to_window()`
- Terminals are always created at bottom with fixed height (10 lines)
- Terminal windows automatically run SSH setup if in remote_ssh directory
- Multiple keybindings for creating, cycling through, and managing terminal buffers

### Buffer/Window Navigation

Custom functions handle navigation between different buffer types:
- `move_to_next_normal_buffer()` / `move_to_prev_normal_buffer()`: Cycle through regular file buffers (skip terminals)
- `move_workspace()`: Smart movement to active/listed windows
- `delete_normal_buffer()`: Delete current buffer and switch to next normal buffer

### Run System

The `functions.run()` function provides a unified interface for running code:
1. First checks for a `run` file in current or parent directories (up to 5 levels)
2. If found, executes that custom run script
3. Otherwise, dispatches to language-specific runners based on file extension:
   - `.py` → `run_py()` (auto-detects venv/virtualenv up to 8 levels up)
   - `.java` → `run_java()` (compiles, runs, cleans up .class files)
   - `.c` → `compile_c()` (compiles with gcc, runs in gdb)
   - `.cpp` → `compile_cpp()` (compiles with g++ including OpenCV flags)
   - `.sh` → `run_shell()` (adds +x permission, executes)
   - `.js` → `run_nodejs()`
   - `.sql` → `run_sql()` (pipes to mysql)
   - `.rs` → `run_rust()` (cargo run)

Bound to `<F5>` key.

### Path System

Global paths defined in `variables.lua`:
- `vim.g.archive`: Personal knowledge base root (`~/archive`)
- `vim.g.areas`: Areas folder (`~/archive/02-AREAS`)
- `vim.g.fleeting`: Fleeting notes (`~/archive/05-FLEETING`)
- `vim.g.projects`: Projects directory
- `vim.g.algorithm_notes`: Algorithm practice notes
- `vim.g.bash_config`: Shell configuration (`~/.my_config`)

These paths are used throughout keybindings for quick navigation with Telescope file browser.

## Common Development Workflow

### Plugin Management

```bash
# Inside Neovim
:PackerSync    # Update/install plugins (or use <leader>ps)
:PackerCompile # Compile plugin configuration
```

Plugins are defined in `lua/theprimeagen/packer.lua`. When adding new plugins, use `safe_require()` in plugin config files.

### LSP Configuration

LSP setup uses lsp-zero.nvim with Mason for automatic language server installation. Language servers configured in `after/plugin/lsp.lua`:
- Auto-installed servers: rust_analyzer, clangd, pyright, lua_ls, cssls, emmet_language_server, texlab, ts_ls
- Special configurations for lua_ls (Lua 5.1), emmet_language_server (web files), pyright

### Testing Code

Use `<F5>` to run current file. The run system:
1. Looks for custom `run` file in current directory or up to 5 parent directories
2. Falls back to language-specific runner
3. Opens/reuses terminal window at bottom
4. For Python: automatically sources venv/virtualenv if found within 8 parent directories

### Telescope Navigation

The configuration heavily uses Telescope for navigation. Key patterns:
- `<A-f>`: Browse current directory (depth=1)
- `<A-y>`: Browse current directory (depth=10, recursive)
- `<A-a>`: Browse archive directory
- `<A-z>`: Browse fleeting notes
- File browser excludes: .git, venv, node_modules, __pycache__, .pytest_cache

## Key Keybinding Patterns

### Modal Keybindings

- Insert mode: `jk` or `kj` to escape
- Normal mode: `<leader>` (space) prefix for most commands
- Terminal mode: `kj` to exit terminal mode, `<A-q>` to close terminal

### Window Management

- `<leader>wv`: Split vertically and move right
- `<leader>ws`: Split horizontally and move down
- Arrow keys: Navigate between windows
- `<C-j>` / `<C-k>`: Cycle through normal buffers
- `<C-l>`: Move to terminal window
- `<A-x>`: Delete current buffer

### Custom Workflows

- `<leader>ts`: Toggle time tracker (start/stop)
- `<leader>pw`: Copy current file path to clipboard
- `<leader>cp`: Copy entire file content to clipboard
- `<leader>al`: Open algorithm notes and start time tracker
- `gl`: Open link/file path under cursor with xdg-open

## Special Features

### Time Tracking System

Built-in time tracker for tracking work sessions:
- Stores start time in `vim.g.time_tracker`
- On stop: calculates elapsed time, formats as HH:MM:SS, copies to clipboard
- Uses noice.nvim for notifications
- Bound to `<leader>ts`

### Smart File Operations

- Auto-reloads files changed externally (FileChangedShellPost autocmd)
- Auto-changes directory to current file's directory (BufEnter autocmd)
- Disabled backspace in insert mode (hardmode)

### Custom Utilities in my_utils

- `temp_note.lua`: Temporary note-taking functionality
- `time_track.lua`: Time tracking module initialization
- `my_file.lua`: File path utilities including `is_subpath_of_current_file()`
- `motions.lua`: Custom motion utilities

## Plugin Integration Notes

### Copilot

- Auto-trigger enabled for all file types
- Accept suggestion: `<A-o>` in insert mode
- Attach/detach: `<C-k>m` / `<C-k>k` in insert mode

### Noice/Notify

Used for enhanced UI notifications. Time tracker and other functions use noice for displaying messages.

### Language-Specific

- **Java**: Uses nvim-java suite with spring-boot support
- **Flutter**: flutter-tools.nvim with dressing.nvim for UI
- **Markdown**: render-markdown.nvim for preview, markdown-preview.nvim for browser preview
- **Grammar**: grammar-guard.nvim for writing assistance

## Modifying Keybindings

Keybindings are centralized in `lua/theprimeagen/remap.lua`. Plugin-specific keybindings are in their respective `after/plugin/*.lua` files. When adding new keybindings:
1. Use descriptive `desc` parameter for which-key integration
2. Follow existing patterns (leader for commands, Alt for quick access)
3. Check for conflicts with existing bindings

## Dependencies

External commands used by functions:
- `xdg-open`: Opening files/URLs
- `chmod`: Making files executable
- `gcc` / `g++`: C/C++ compilation
- `javac` / `java`: Java compilation and execution
- `mysql`: SQL file execution
- `pkg-config`: OpenCV linking for C++
- `silicon`: Code screenshot generation (customsilicon.sh script)
- `clip_llm.sh`: Copy file content to clipboard for LLM
- `openpptx.sh`: Convert markdown to PowerPoint
