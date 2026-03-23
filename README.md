# Dotfiles

My macOS terminal environment — Alacritty / Ghostty + Zsh + tmux + Neovim, all managed through Homebrew and symlinks.

![Shell: Zsh](https://img.shields.io/badge/shell-zsh-informational?style=flat&logo=gnu-bash)
![Terminal: Alacritty](https://img.shields.io/badge/terminal-alacritty-F46D01?style=flat&logo=alacritty)
![Terminal: Ghostty](https://img.shields.io/badge/terminal-ghostty-171717?style=flat&logo=ghostty)
![Editor: Neovim](https://img.shields.io/badge/editor-neovim-57A143?style=flat&logo=neovim)
![Multiplexer: tmux](https://img.shields.io/badge/multiplexer-tmux-1BB91F?style=flat&logo=tmux)

---

## Quick Start

On a fresh Mac, run:

```bash
git clone git@github.com:golah/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

This will:

1. Install **Homebrew** (if missing)
2. Install all packages and casks from the **Brewfile**
3. Create **symlinks** for all config files
4. Sync **Neovim plugins** via Lazy.nvim
5. Reload **tmux** config if a session is running

After install, restart your terminal.

---

## Repository Structure

```
~/dotfiles/
├── alacritty/
│   ├── alacritty.toml          # Main Alacritty config
│   └── themes/                 # 159+ color schemes (TOML)
│       └── themes/
│           └── coolnight.toml  # Active theme
├── ghostty/
│   ├── config                  # Main Ghostty config
│   └── themes/
│       └── coolnight           # Coolnight theme (ported from Alacritty)
├── nvim/
│   ├── init.lua                # Entry point (loads LazyVim)
│   ├── lazy-lock.json          # Pinned plugin versions
│   └── lua/
│       ├── config/             # Options, keymaps, autocmds
│       └── plugins/            # Custom plugin specs
├── tmux/
│   └── .tmux.conf              # tmux config
├── zsh/
│   ├── .zshrc                  # Shell config
│   └── .p10k.zsh               # Powerlevel10k prompt config
├── Brewfile                    # All Homebrew packages and casks
├── install.sh                  # One-command bootstrap script
└── symlink.sh                  # Creates all symlinks
```

### Where Symlinks Point

| Source (dotfiles repo)              | Target (system location)           |
|-------------------------------------|------------------------------------|
| `alacritty/alacritty.toml`          | `~/.config/alacritty/alacritty.toml` |
| `alacritty/themes/`                 | `~/.config/alacritty/themes/`      |
| `ghostty/config`                    | `~/.config/ghostty/config`         |
| `ghostty/themes/`                   | `~/.config/ghostty/themes/`        |
| `nvim/`                             | `~/.config/nvim/`                  |
| `tmux/.tmux.conf`                   | `~/.tmux.conf`                     |
| `zsh/.zshrc`                        | `~/.zshrc`                         |
| `zsh/.p10k.zsh`                     | `~/.p10k.zsh`                      |

---

## Alacritty

**GPU-accelerated terminal emulator.** Fast, minimal, configured entirely through a TOML file — no tabs, no splits (tmux handles that).

### Visual Settings

| Setting | Value | Notes |
|---------|-------|-------|
| Theme | **Coolnight** | Dark blue bg (`#011423`), cyan/green accents, inspired by Aura |
| Font | **MesloLGS Nerd Font Mono** | Nerd Font patched — supports icons for p10k, eza, nvim |
| Font size | **14** | |
| Opacity | **0.8** (80%) | Semi-transparent window with desktop visible behind |
| Blur | **Enabled** | Frosted-glass effect on the transparent background |
| Padding | **10px** all sides | Breathing room between text and window edges |
| Decorations | **Buttonless** | No macOS traffic-light buttons — clean, minimal title bar |
| TERM | `xterm-256color` | Full 256-color support |
| Option key | **Both as Alt** | Both left/right Option keys send Alt codes (needed for tmux/nvim keybindings on macOS) |

### Coolnight Color Palette

```
Background   #011423  ████  Dark navy
Foreground   #CBE0F0  ████  Soft blue-white

Cursor       #47FF9C  ████  Bright mint green

Black        #214969  ████  Muted steel blue
Red          #E52E2E  ████  Vivid red
Green        #44FFB1  ████  Bright mint
Yellow       #FFE073  ████  Warm gold
Blue         #0FC5ED  ████  Electric cyan
Magenta      #A277FF  ████  Soft purple
Cyan         #24EAF7  ████  Bright cyan
White        #24EAF7  ████  Cyan (used as white)
```

### Switching Themes

159+ themes are bundled in `alacritty/themes/themes/`. To switch, edit the import line in `alacritty.toml`:

```toml
import = [
    "~/.config/alacritty/themes/coolnight.toml"
    # Change to any other theme, e.g.:
    # "~/.config/alacritty/themes/themes/catppuccin_mocha.toml"
    # "~/.config/alacritty/themes/themes/tokyo-night.toml"
    # "~/.config/alacritty/themes/themes/dracula.toml"
]
```

Changes apply instantly — no restart needed.

---

## Ghostty

**Fast, native terminal emulator** by Mitchell Hashimoto (creator of Vagrant, Terraform). Written in Zig, uses platform-native rendering. Like Alacritty, it has no tabs or splits — tmux handles that.

Ghostty is configured to look and feel identical to the Alacritty setup above, using a ported version of the Coolnight theme.

### Configuration Format

Ghostty uses a simple `key = value` format (not TOML). One setting per line, `#` for comments.

- **Config file:** `~/.config/ghostty/config`
- **Custom themes:** `~/.config/ghostty/themes/`

### Visual Settings

| Setting | Value | Ghostty Config Key |
|---------|-------|--------------------|
| Theme | **Coolnight** (custom) | `theme = coolnight` |
| Font | **MesloLGS Nerd Font Mono** | `font-family = MesloLGS Nerd Font Mono` |
| Font size | **14** | `font-size = 14` |
| Opacity | **0.8** (80%) | `background-opacity = 0.8` |
| Blur | **Intensity 20** | `background-blur = 20` |
| Padding | **10px** all sides | `window-padding-x = 10` / `window-padding-y = 10` |
| Title bar | **Transparent** | `macos-titlebar-style = transparent` (blends into background, still draggable) |
| Option key | **Both as Alt** | `macos-option-as-alt = true` |
| TERM | `xterm-256color` | `term = xterm-256color` |

> **Note on TERM:** Ghostty ships its own terminfo (`xterm-ghostty`), but we override to `xterm-256color` for compatibility with remote servers that don't have the Ghostty terminfo installed. If you only work locally, you can use `xterm-ghostty` instead.

> **Note on blur:** Unlike Alacritty's boolean `blur = true`, Ghostty takes an integer intensity. `20` gives a similar frosted-glass effect. You can also use `macos-glass-regular` or `macos-glass-clear` for macOS vibrancy effects.

### Switching Themes

Edit the `theme` line in `ghostty/config`:

```
theme = coolnight
# Or use a built-in theme:
# theme = Catppuccin Mocha
# theme = Tokyo Night
```

List all available built-in themes:

```bash
ghostty +list-themes
```

To add a custom theme, create a file in `ghostty/themes/` (no extension) using the same `key = value` format with color settings.

### Settings Comparison: Alacritty vs Ghostty

| Setting | Alacritty (TOML) | Ghostty (key=value) |
|---------|-----------------|---------------------|
| Theme | `import = ["~/.../coolnight.toml"]` | `theme = coolnight` |
| Font | `normal.family = "MesloLGS Nerd Font Mono"` | `font-family = MesloLGS Nerd Font Mono` |
| Font size | `size = 14` | `font-size = 14` |
| Opacity | `opacity = 0.8` | `background-opacity = 0.8` |
| Blur | `blur = true` | `background-blur = 20` |
| Decorations | `decorations = "Buttonless"` | `macos-titlebar-style = transparent` |
| Padding | `padding.x = 10` / `padding.y = 10` | `window-padding-x = 10` / `window-padding-y = 10` |
| Option as Alt | `option_as_alt = "Both"` | `macos-option-as-alt = true` |
| TERM env | `[env] TERM = "xterm-256color"` | `term = xterm-256color` |
| Colors | Separate `.toml` theme file | Separate theme file in `themes/` dir (no extension) |

---

## Zsh + Powerlevel10k

### Prompt

**Powerlevel10k** with the **rainbow** preset — a feature-rich, instant-loading prompt.

| Setting | Value |
|---------|-------|
| Style | Rainbow (colored background segments) |
| Icons | Nerd Font v3 + Powerline glyphs |
| Separators | Angled (  ) |
| Heads | Sharp |
| Tails | Flat |
| Lines | 2-line (prompt on second line) |
| Frame | Full frame with dotted connector |
| Time | 24h format |
| Spacing | Sparse (blank line before prompt) |
| Instant prompt | Enabled (prompt renders immediately, before plugins load) |

To reconfigure the prompt style interactively:

```bash
p10k configure
```

### Plugins

Installed via Homebrew (not oh-my-zsh), sourced directly in `.zshrc`:

| Plugin | What It Does |
|--------|-------------|
| **zsh-autosuggestions** | Ghost-text suggestions from history as you type. Accept with `→` arrow key. |
| **zsh-syntax-highlighting** | Colors commands as you type — green for valid commands, red for errors, underlined for paths. |

### Shell Aliases

```bash
ls    →  eza --icons=always    # Colorized file listing with file-type icons
```

### PATH Additions

```bash
~/.npm-global/bin     # npm global packages (avoids sudo)
~/.local/bin          # User-local binaries
~/opt/anaconda3/bin   # Conda (loaded conditionally)
```

---

## tmux

**Terminal multiplexer** — splits, sessions, and persistent workspaces. All window management happens here, not in the terminal emulator (neither Alacritty nor Ghostty have built-in splits).

### Visual Theme

**Powerline Cyan** (via `jimeh/tmux-themepack`) — status bar with powerline glyphs in cyan, matching the Alacritty color scheme.

### Key Bindings

Default prefix is `Ctrl+b`, then:

| Keys | Action |
|------|--------|
| `\|` | Split pane horizontally (replaces `%`) |
| `-` | Split pane vertically (replaces `"`) |
| `h` / `j` / `k` / `l` | Resize pane left/down/up/right (5 cells, repeatable with `-r`) |
| `m` | Toggle pane zoom (maximize/restore) |

### Vi Copy Mode

tmux uses **vi-style keys** for scrolling and copying:

| Keys | Action |
|------|--------|
| `Ctrl+b` then `[` | Enter copy/scroll mode |
| `j` / `k` | Scroll down/up line by line |
| `Ctrl+d` / `Ctrl+u` | Scroll down/up half page |
| `v` | Start visual selection |
| `y` | Yank (copy) selection |
| `q` | Exit copy mode |

Mouse scrolling also works — `set -g mouse on` is enabled, so you can scroll with trackpad/mouse wheel to enter copy mode automatically.

> **Note:** Mouse drag to select does NOT exit copy mode (`MouseDragEnd1Pane` is unbound), so you can adjust the selection after dragging.

### Plugins (TPM)

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm). On a new machine, install them with `Ctrl+b` then `I` (capital i).

| Plugin | Purpose |
|--------|---------|
| **vim-tmux-navigator** | Seamless `Ctrl+h/j/k/l` navigation between tmux panes and Neovim splits — no prefix key needed |
| **tmux-themepack** | Statusbar themes (using `powerline/default/cyan`) |
| **tmux-resurrect** | Save and restore tmux sessions across reboots (`Ctrl+b` then `Ctrl+s` to save, `Ctrl+b` then `Ctrl+r` to restore). Captures pane contents. |
| **tmux-continuum** | Auto-saves sessions every 15 minutes and auto-restores on tmux start |

### Terminal Compatibility

```
set -g default-terminal "screen-256color"
```

This ensures 256-color support inside tmux. Combined with the terminal emulator's `TERM=xterm-256color` (set in both Alacritty and Ghostty), colors render correctly in Neovim and other tools.

---

## Neovim (LazyVim)

**Neovim** with the **LazyVim** distribution — a batteries-included setup with sensible defaults, managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

### Configuration

The config uses LazyVim's defaults with no custom overrides — `options.lua`, `keymaps.lua`, and `autocmds.lua` are all stock. The `plugins/example.lua` file exists but is disabled (`if true then return {} end`).

### Default Colorscheme

**Tokyo Night** (falls back to `habamax` if unavailable). Catppuccin is also installed and available.

### Plugin List (33 plugins)

| Plugin | Purpose |
|--------|---------|
| **blink.cmp** | Fast completion engine |
| **bufferline.nvim** | Tab-like buffer bar at top |
| **catppuccin** | Catppuccin color scheme |
| **conform.nvim** | Auto-formatting on save |
| **flash.nvim** | Quick jump/search motions |
| **friendly-snippets** | Community-maintained snippet collection |
| **gitsigns.nvim** | Git diff markers in the gutter |
| **grug-far.nvim** | Find and replace across files |
| **lazydev.nvim** | Lua development helpers |
| **lualine.nvim** | Statusline |
| **mason.nvim** | LSP/linter/formatter installer |
| **mason-lspconfig.nvim** | Bridges Mason and lspconfig |
| **mini.ai** | Better text objects (around/inside) |
| **mini.icons** | File type icons |
| **mini.pairs** | Auto-close brackets and quotes |
| **noice.nvim** | Better UI for messages, cmdline, popupmenu |
| **nui.nvim** | UI component library (used by noice) |
| **nvim-lint** | Async linting |
| **nvim-lspconfig** | LSP client configuration |
| **nvim-treesitter** | Syntax highlighting and code parsing |
| **nvim-treesitter-textobjects** | Treesitter-aware text objects |
| **nvim-ts-autotag** | Auto-close/rename HTML/JSX tags |
| **persistence.nvim** | Session management (auto-save on exit) |
| **plenary.nvim** | Lua utility library |
| **snacks.nvim** | Collection of small QoL plugins |
| **todo-comments.nvim** | Highlight and search TODO/FIXME/HACK comments |
| **tokyonight.nvim** | Tokyo Night color scheme |
| **trouble.nvim** | Pretty diagnostics list |
| **ts-comments.nvim** | Treesitter-aware commenting |
| **which-key.nvim** | Popup showing available keybindings |

### Mason Auto-installed Tools

These are installed automatically by Mason on first launch:

- **stylua** — Lua formatter
- **shellcheck** — Shell script linter
- **shfmt** — Shell script formatter
- **flake8** — Python linter

### Treesitter-enabled Languages

Syntax highlighting and code intelligence for: Bash, HTML, JavaScript, JSON, Lua, Markdown, Python, Regex, TSX, TypeScript, Vim, YAML.

---

## CLI Tools

All installed via Homebrew (`brew bundle install --file=Brewfile`).

### Daily Drivers

| Tool | What It Does |
|------|-------------|
| **eza** | Modern `ls` replacement. Colorized output with file-type icons (aliased to `ls`). |
| **fzf** | Fuzzy finder. `Ctrl+R` for history search, `Ctrl+T` for file picker, `Alt+C` for directory jump. Integrated into Zsh. |
| **lazygit** | Terminal UI for git. Interactive staging, committing, branching, rebasing — all without memorizing git commands. Launch with `lazygit`. |
| **neovim** | Extensible text editor (see Neovim section above). |
| **tmux** | Terminal multiplexer (see tmux section above). |
| **glow** | Render Markdown in the terminal with syntax highlighting and word wrap. |
| **pandoc** | Universal document converter (Markdown to PDF, DOCX, HTML, etc.). |

### Development

| Tool | What It Does |
|------|-------------|
| **node** | JavaScript/TypeScript runtime. |
| **php** | PHP runtime. |
| **cocoapods** | iOS/macOS dependency manager (for React Native / Flutter). |
| **texlive** | LaTeX distribution for typesetting documents and PDFs. |

### Libraries & Utilities

| Tool | What It Does |
|------|-------------|
| **curl** | HTTP client (Homebrew version, newer than macOS built-in). |
| **exiftool** | Read/write metadata in images, PDFs, videos. |
| **poppler** | PDF rendering library (provides `pdftotext`, `pdfinfo`, etc.). |
| **libpq** | PostgreSQL client library. |
| **libssh2** | SSH protocol library. |
| **openldap** | LDAP client library. |
| **openssl@1.1** | TLS/SSL library. |
| **freetds** | TDS protocol library (for Microsoft SQL Server). |
| **krb5** | Kerberos authentication library. |
| **apr-util** | Apache Portable Runtime utilities. |
| **rtmpdump** | RTMP streaming toolkit. |
| **libzip** | Library for reading/writing ZIP archives. |

### Casks (GUI Apps & Fonts)

| Cask | What It Is |
|------|-----------|
| **alacritty** | GPU-accelerated terminal emulator. |
| **ghostty** | Fast, native terminal emulator (Zig). Identical config to Alacritty included. |
| **font-meslo-lg-nerd-font** | Primary font — Meslo LG patched with Nerd Font icons. Used by Alacritty/Ghostty and Powerlevel10k. |
| **font-hack-nerd-font** | Alternative Nerd Font (Hack typeface). |
| **kid3** | Audio file tag editor (ID3, Vorbis, etc.). |

---

## Adding to This Setup

### New Homebrew package

```bash
brew install <package>
# Then add it to the Brewfile:
echo 'brew "<package>"' >> ~/dotfiles/Brewfile
```

### New Alacritty theme

Drop a `.toml` file into `alacritty/themes/themes/` and update the import in `alacritty.toml`.

### New Ghostty theme

Create a file (no extension) in `ghostty/themes/` with color settings, then set `theme = <name>` in `ghostty/config`.

### New tmux plugin

Add to `.tmux.conf`:

```bash
set -g @plugin 'author/plugin-name'
```

Then press `Ctrl+b` then `I` to install.

### New Neovim plugin

Create a new file in `nvim/lua/plugins/` (e.g., `myplugin.lua`):

```lua
return {
  { "author/plugin-name", opts = {} },
}
```

Lazy.nvim picks it up automatically on next launch.
