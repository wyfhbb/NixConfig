<h1 align="center">:snowflake: Ifan's NixConfig :snowflake:</h1>

<p align="center">
  My personal Nix configuration repository, using Nix Flakes to manage macOS, NixOS Desktop, WSL, and server systems in a unified way.
</p>

<p align="center">
  <a href="README_CN.md">中文文档</a>
</p>

> [!NOTE]
> This configuration is tailored to my personal needs. Feel free to use it as a reference for your own setup.

## System Overview

| System | Architecture | Hostname | Config Name | Status |
|--------|--------------|----------|-------------|--------|
| macOS (Nix-Darwin) | aarch64-darwin | wyf-macbook | `darwin` | ✅ Complete |
| NixOS Desktop | x86_64-linux | nixos-wyf | `desktop` | ✅ Complete |
| NixOS WSL | x86_64-linux | nixwsl | `wsl` | ✅ Complete |
| NixOS Server | x86_64-linux | vps-server | `vps` | 🚧 WIP |

## Directory Structure

```
.
├── flake.nix              # Flake entry point
├── flake.lock             # Dependency lock file
├── Justfile               # Task commands
├── docs/                  # Documentation for AI and contributors
├── modules/
│   ├── common/            # Cross-platform modules (nix-settings, fonts)
│   ├── darwin/            # macOS-specific modules (Homebrew apps)
│   └── nixos/             # NixOS-specific modules (desktop, graphics, fixes)
├── hosts/                 # Host-specific configurations
│   ├── wyf-macbook/
│   ├── desktop-linux/
│   ├── wsl/
│   └── vps-server/
└── home/                  # Home Manager user configurations
    ├── common/            # Shared CLI tools (neovim, tmux, git, zsh)
    ├── gui/               # GUI configs (terminal, input method, GNOME, niri)
    └── profiles/          # Platform-specific profiles
```

## Flake Inputs

| Input | Source | Purpose |
|-------|--------|---------|
| nixpkgs | nixos-25.11 | Stable package repository |
| nixpkgs-unstable | nixos-unstable | Latest packages (via `unstable.*` overlay) |
| home-manager | release-25.11 | User environment management |
| nix-darwin | nix-darwin-25.11 | macOS system management |
| nix-homebrew | latest | Manage Homebrew via Nix |
| nixos-wsl | release-25.11 | NixOS on WSL support |
| noctalia | noctalia-shell | Wayland desktop shell (for Niri) |
| grub2-themes | grub2-themes | GRUB2 WhiteSur theme |

---

## Components

### Shared CLI Tools (All Platforms)

<table>
  <tr>
    <th>Category</th>
    <th>Component</th>
  </tr>
  <tr>
    <td>Shell</td>
    <td>Zsh + <a href="https://ohmyz.sh/">Oh My Zsh</a> + <a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td>
  </tr>
  <tr>
    <td>Editor</td>
    <td><a href="https://neovim.io/">Neovim</a> (Catppuccin + Treesitter + Telescope + nvim-tree)</td>
  </tr>
  <tr>
    <td>Terminal Multiplexer</td>
    <td>Tmux (+ resurrect, continuum)</td>
  </tr>
  <tr>
    <td>File Manager</td>
    <td><a href="https://github.com/sxyazi/yazi">Yazi</a></td>
  </tr>
  <tr>
    <td>Git</td>
    <td>Git + <a href="https://github.com/jesseduffield/lazygit">Lazygit</a></td>
  </tr>
  <tr>
    <td>Dev Tools</td>
    <td><a href="https://github.com/anthropics/claude-code">Claude Code</a>, <a href="https://github.com/direnv/direnv">direnv</a>, <a href="https://github.com/astral-sh/uv">uv</a>, pnpm</td>
  </tr>
</table>

---

### Nix-Darwin (macOS)

<table>
  <tr>
    <th>Category</th>
    <th>Component</th>
  </tr>
  <tr>
    <td>Package Management</td>
    <td><a href="https://github.com/LnL7/nix-darwin">Nix-Darwin</a> + <a href="https://github.com/zhaofengli/nix-homebrew">nix-homebrew</a></td>
  </tr>
  <tr>
    <td>User Configuration</td>
    <td><a href="https://github.com/nix-community/home-manager">Home Manager</a></td>
  </tr>
  <tr>
    <td>Terminal Emulator</td>
    <td><a href="https://github.com/ghostty-org/ghostty">Ghostty</a></td>
  </tr>
  <tr>
    <td>Editor</td>
    <td>Neovim + VS Code</td>
  </tr>
</table>

**Homebrew Casks:**
- Browser: Google Chrome
- Development: VS Code, Ghostty, Termius, Postman, Docker Desktop
- Communication: QQ, WeChat, WeChat Work, Tencent Meeting, Feishu
- Utilities: LocalSend, Mos, UTM, OBS, Clash Party, Baidu Netdisk, Logi Options+

**Homebrew Brews:** curl, wget, sox, nodejs, unar

**Mac App Store:** Microsoft Office (OneDrive, Excel, PowerPoint, Word), Windows App

---

### NixOS Desktop

<table>
  <tr>
    <th>Category</th>
    <th>Component</th>
  </tr>
  <tr>
    <td>Window Manager</td>
    <td><a href="https://github.com/YaLTeR/niri">Niri</a> (Wayland Compositor)</td>
  </tr>
  <tr>
    <td>Desktop Shell</td>
    <td><a href="https://github.com/noctalia-dev/noctalia-shell">Noctalia Shell</a> + GNOME</td>
  </tr>
  <tr>
    <td>Display Manager</td>
    <td>GDM</td>
  </tr>
  <tr>
    <td>User Configuration</td>
    <td><a href="https://github.com/nix-community/home-manager">Home Manager</a></td>
  </tr>
  <tr>
    <td>Terminal Emulator</td>
    <td><a href="https://github.com/ghostty-org/ghostty">Ghostty</a></td>
  </tr>
  <tr>
    <td>Input Method</td>
    <td><a href="https://github.com/fcitx/fcitx5">Fcitx5</a> + <a href="https://github.com/rime/rime-ice">Rime</a></td>
  </tr>
  <tr>
    <td>Audio System</td>
    <td>PipeWire</td>
  </tr>
  <tr>
    <td>Proxy</td>
    <td>Mihomo (TUN mode)</td>
  </tr>
  <tr>
    <td>Container</td>
    <td>Docker</td>
  </tr>
  <tr>
    <td>Bootloader</td>
    <td>GRUB2 + <a href="https://github.com/vinceliuice/grub2-themes">WhiteSur Theme</a></td>
  </tr>
</table>

**GUI Applications:**
- Browser: Google Chrome
- Development: VS Code, Ghostty, Termius
- Multimedia: OBS Studio
- Office Suite: WPS Office
- Communication: QQ, WeChat, Tencent Meeting
- System Tools: GParted, Mission Center, wdisplays

---

### NixOS WSL

<table>
  <tr>
    <th>Category</th>
    <th>Component</th>
  </tr>
  <tr>
    <td>WSL Integration</td>
    <td><a href="https://github.com/nix-community/NixOS-WSL">NixOS-WSL</a></td>
  </tr>
  <tr>
    <td>User Configuration</td>
    <td><a href="https://github.com/nix-community/home-manager">Home Manager</a></td>
  </tr>
  <tr>
    <td>Editor</td>
    <td>Neovim</td>
  </tr>
  <tr>
    <td>GPU Support</td>
    <td>NVIDIA (via LD_LIBRARY_PATH)</td>
  </tr>
</table>

---

### NixOS Server

🚧 **Work in Progress**

---

## Deployment

### Prerequisites

- Install [Nix](https://nixos.org/download) package manager
- Enable Flakes experimental feature (handled by `just init`)

### First-Time Setup

```bash
# Initialize any system (enables flakes automatically)
just init <hostname>    # darwin / wsl / vps-server / desktop-linux
```

### Update Configuration

```bash
# Rebuild and switch to new configuration
just rebuild <hostname>

# Debug build (with --show-trace --verbose)
just rebuild-debug <hostname>

# Test without switching (Linux only)
just test <hostname>

# Build without switching (Linux only)
just build <hostname>
```

### Common Commands

```bash
just up              # Update all flake inputs
just upp <input>     # Update specific input
just clean           # Clean old generations (> 7 days)
just gc              # Garbage collect nix store
just fmt             # Format all .nix files
just history         # List system generation history
just repl            # Open nix repl
just gcroot          # List auto GC roots
```
