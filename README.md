<h1 align="center">Efan's NixConfig</h1>

<p align="center">My personal Nix configuration repository, using Nix Flakes to manage macOS, NixOS Desktop, WSL, and server systems in a unified way.</p>

> [!NOTE]
> This configuration is tailored to my personal needs. Feel free to use it as a reference for your own setup.

## System Overview

| System | Architecture | Hostname | Status |
|--------|--------------|----------|--------|
| macOS (Nix-Darwin) | aarch64-darwin | wyf-macbook | ✅ Complete |
| NixOS Desktop | x86_64-linux | nixos-wyf | ✅ Complete |
| NixOS WSL | x86_64-linux | nixwsl | ✅ Complete |
| NixOS Server | x86_64-linux | vps-server | 🚧 WIP |

---

## Directory Structure

```
.
├── flake.nix              # Flake entry point
├── flake.lock             # Dependency lock file
├── Justfile               # Task commands
├── modules/
│   ├── common/            # Cross-platform modules
│   ├── darwin/            # macOS-specific modules
│   └── nixos/             # NixOS-specific modules
├── hosts/                 # Host configurations
│   ├── wyf-macbook/
│   ├── desktop-linux/
│   ├── wsl/
│   └── vps-server/
└── home/                  # Home Manager configurations
    ├── common/            # Shared user configs
    ├── gui/               # GUI-related configs
    └── profiles/          # System-specific profiles
```


## Components

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
    <td>Shell</td>
    <td>Zsh + <a href="https://ohmyz.sh/">Oh My Zsh</a> + <a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td>
  </tr>
  <tr>
    <td>Editor</td>
    <td>Neovim + VS Code</td>
  </tr>
  <tr>
    <td>File Manager</td>
    <td><a href="https://github.com/sxyazi/yazi">Yazi</a></td>
  </tr>
  <tr>
    <td>Terminal Multiplexer</td>
    <td>Tmux</td>
  </tr>
  <tr>
    <td>Git TUI</td>
    <td><a href="https://github.com/jesseduffield/lazygit">Lazygit</a></td>
  </tr>
</table>

**Homebrew Casks:**
- Browser: Google Chrome
- Development: VS Code, Ghostty, Termius
- Communication: QQ, WeChat, WeChat Work, Tencent Meeting
- Utilities: LocalSend, Mos, UTM

**Mac App Store:**
- Microsoft Office Suite (OneDrive, Excel, PowerPoint, Word)

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
    <td>Shell Framework</td>
    <td><a href="https://github.com/noctalia-dev/noctalia-shell">Noctalia Shell</a></td>
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
    <td>Shell</td>
    <td>Zsh + <a href="https://ohmyz.sh/">Oh My Zsh</a> + <a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td>
  </tr>
  <tr>
    <td>Editor</td>
    <td>Neovim + VS Code</td>
  </tr>
  <tr>
    <td>Input Method</td>
    <td><a href="https://github.com/fcitx/fcitx5">Fcitx5</a> + <a href="https://github.com/rime/rime-ice">Rime</a></td>
  </tr>
  <tr>
    <td>File Manager</td>
    <td><a href="https://github.com/sxyazi/yazi">Yazi</a></td>
  </tr>
  <tr>
    <td>Audio System</td>
    <td>PipeWire</td>
  </tr>
  <tr>
    <td>Bootloader</td>
    <td>GRUB2 + <a href="https://github.com/vinceliuice/grub2-themes">Whitesur Theme</a></td>
  </tr>
</table>

**GUI Applications:**
- Browser: Google Chrome
- Development: VS Code, Ghostty
- Multimedia: OBS Studio
- Office Suite: WPS Office
- Communication: QQ, WeChat, Tencent Meeting

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
    <td>Shell</td>
    <td>Zsh + <a href="https://ohmyz.sh/">Oh My Zsh</a> + <a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td>
  </tr>
  <tr>
    <td>Editor</td>
    <td>Neovim</td>
  </tr>
  <tr>
    <td>File Manager</td>
    <td><a href="https://github.com/sxyazi/yazi">Yazi</a></td>
  </tr>
  <tr>
    <td>Terminal Multiplexer</td>
    <td>Tmux</td>
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

- Install Nix package manager
- Enable Flakes feature

### macOS

```bash
# Initial deployment
just init-darwin

# Update configuration
just darwin
```

### NixOS

```bash
# Initial deployment (hostname: desktop/wsl/vps)
just init-linux <hostname>

# Update configuration
just rebuild <hostname>
```

### Common Commands

```bash
# Update all flake inputs
just up

# Update specific input
just upp <input>

# Clean old generations (older than 7 days)
just clean

# Garbage collection
just gc

# Format nix files
just fmt
```

