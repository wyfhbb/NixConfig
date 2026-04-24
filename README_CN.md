<h1 align="center">:snowflake: Ifan 的 NixConfig :snowflake:</h1>

<p align="center">
  我的个人 Nix 配置仓库，使用 Nix Flakes 统一管理 macOS、NixOS 桌面、WSL 和服务器系统。
</p>

<p align="center">
  <a href="README.md">English</a>
</p>

> [!NOTE]
> 此配置根据我的个人需求定制，欢迎作为参考。

## 系统概览

| 系统 | 架构 | 主机名 | 配置名 | 状态 |
|------|------|--------|--------|------|
| macOS (Nix-Darwin) | aarch64-darwin | wyf-macbook | `darwin` | ✅ 完成 |
| NixOS 桌面 | x86_64-linux | nixos-wyf | `desktop` | ✅ 完成 |
| NixOS WSL | x86_64-linux | nixwsl | `wsl` | ✅ 完成 |
| NixOS 服务器 | x86_64-linux | vps-server | `vps` | 🚧 进行中 |

## 目录结构

```
.
├── flake.nix              # Flake 入口文件
├── flake.lock             # 依赖锁定文件
├── Justfile               # 任务命令
├── docs/                  # AI 及贡献者文档
├── modules/
│   ├── common/            # 跨平台模块（nix 设置、字体）
│   ├── darwin/            # macOS 专属模块（Homebrew 应用）
│   └── nixos/             # NixOS 专属模块（桌面、显卡、修复）
├── hosts/                 # 主机特定配置
│   ├── wyf-macbook/
│   ├── desktop-linux/
│   ├── wsl/
│   └── vps-server/
└── home/                  # Home Manager 用户配置
    ├── common/            # 共享 CLI 工具（neovim、tmux、git、zsh）
    ├── gui/               # GUI 配置（终端、输入法、GNOME、niri）
    └── profiles/          # 按平台组装的 profile
```

## Flake 输入源

| 输入源 | 来源 | 用途 |
|--------|------|------|
| nixpkgs | nixos-25.11 | 稳定软件包仓库 |
| nixpkgs-unstable | nixos-unstable | 最新版软件包（通过 `unstable.*` overlay） |
| home-manager | release-25.11 | 用户环境管理 |
| nix-darwin | nix-darwin-25.11 | macOS 系统管理 |
| nix-homebrew | 最新版 | 通过 Nix 管理 Homebrew |
| nixos-wsl | release-25.11 | WSL 上运行 NixOS |
| noctalia | noctalia-shell | Wayland 桌面 Shell（配合 Niri） |
| grub2-themes | grub2-themes | GRUB2 WhiteSur 主题 |

---

## 组件

### 共享 CLI 工具（全平台通用）

<table>
  <tr>
    <th>类别</th>
    <th>组件</th>
  </tr>
  <tr>
    <td>Shell</td>
    <td>Zsh + <a href="https://ohmyz.sh/">Oh My Zsh</a> + <a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td>
  </tr>
  <tr>
    <td>编辑器</td>
    <td><a href="https://neovim.io/">Neovim</a>（Catppuccin + Treesitter + Telescope + nvim-tree）</td>
  </tr>
  <tr>
    <td>终端复用器</td>
    <td>Tmux（+ resurrect、continuum）</td>
  </tr>
  <tr>
    <td>文件管理器</td>
    <td><a href="https://github.com/sxyazi/yazi">Yazi</a></td>
  </tr>
  <tr>
    <td>Git</td>
    <td>Git + <a href="https://github.com/jesseduffield/lazygit">Lazygit</a></td>
  </tr>
  <tr>
    <td>开发工具</td>
    <td><a href="https://github.com/anthropics/claude-code">Claude Code</a>、<a href="https://github.com/direnv/direnv">direnv</a>、<a href="https://github.com/astral-sh/uv">uv</a>、pnpm</td>
  </tr>
</table>

---

### Nix-Darwin（macOS）

<table>
  <tr>
    <th>类别</th>
    <th>组件</th>
  </tr>
  <tr>
    <td>包管理</td>
    <td><a href="https://github.com/LnL7/nix-darwin">Nix-Darwin</a> + <a href="https://github.com/zhaofengli/nix-homebrew">nix-homebrew</a></td>
  </tr>
  <tr>
    <td>用户配置</td>
    <td><a href="https://github.com/nix-community/home-manager">Home Manager</a></td>
  </tr>
  <tr>
    <td>终端模拟器</td>
    <td><a href="https://github.com/ghostty-org/ghostty">Ghostty</a></td>
  </tr>
  <tr>
    <td>编辑器</td>
    <td>Neovim + VS Code</td>
  </tr>
</table>

**Homebrew Casks：**
- 浏览器：Google Chrome
- 开发工具：VS Code、Ghostty、Termius、Postman、Docker Desktop
- 通讯协作：QQ、微信、企业微信、腾讯会议、飞书
- 实用工具：LocalSend、Mos、UTM、OBS、Clash Party、百度网盘、Logi Options+

**Homebrew Brews：** curl、wget、sox、nodejs、unar

**Mac App Store：** Microsoft Office（OneDrive、Excel、PowerPoint、Word）、Windows App

---

### NixOS 桌面

<table>
  <tr>
    <th>类别</th>
    <th>组件</th>
  </tr>
  <tr>
    <td>窗口管理器</td>
    <td><a href="https://github.com/YaLTeR/niri">Niri</a>（Wayland 合成器）</td>
  </tr>
  <tr>
    <td>桌面 Shell</td>
    <td><a href="https://github.com/noctalia-dev/noctalia-shell">Noctalia Shell</a> + GNOME</td>
  </tr>
  <tr>
    <td>登录管理器</td>
    <td>GDM</td>
  </tr>
  <tr>
    <td>用户配置</td>
    <td><a href="https://github.com/nix-community/home-manager">Home Manager</a></td>
  </tr>
  <tr>
    <td>终端模拟器</td>
    <td><a href="https://github.com/ghostty-org/ghostty">Ghostty</a></td>
  </tr>
  <tr>
    <td>输入法</td>
    <td><a href="https://github.com/fcitx/fcitx5">Fcitx5</a> + <a href="https://github.com/rime/rime-ice">Rime</a>（小鹤双拼）</td>
  </tr>
  <tr>
    <td>音频系统</td>
    <td>PipeWire</td>
  </tr>
  <tr>
    <td>代理</td>
    <td>Mihomo（TUN 模式）</td>
  </tr>
  <tr>
    <td>容器</td>
    <td>Docker</td>
  </tr>
  <tr>
    <td>引导程序</td>
    <td>GRUB2 + <a href="https://github.com/vinceliuice/grub2-themes">WhiteSur 主题</a></td>
  </tr>
</table>

**GUI 应用：**
- 浏览器：Google Chrome
- 开发工具：VS Code、Ghostty、Termius
- 多媒体：OBS Studio
- 办公套件：WPS Office
- 通讯协作：QQ、微信、腾讯会议
- 系统工具：GParted、Mission Center、wdisplays

---

### NixOS WSL

<table>
  <tr>
    <th>类别</th>
    <th>组件</th>
  </tr>
  <tr>
    <td>WSL 集成</td>
    <td><a href="https://github.com/nix-community/NixOS-WSL">NixOS-WSL</a></td>
  </tr>
  <tr>
    <td>用户配置</td>
    <td><a href="https://github.com/nix-community/home-manager">Home Manager</a></td>
  </tr>
  <tr>
    <td>编辑器</td>
    <td>Neovim</td>
  </tr>
  <tr>
    <td>GPU 支持</td>
    <td>NVIDIA（通过 LD_LIBRARY_PATH）</td>
  </tr>
</table>

---

### NixOS 服务器

🚧 **开发中**

---

## 部署

### 前置要求

- 安装 [Nix](https://nixos.org/download) 包管理器
- 启用 Flakes 实验性功能（`just init` 会自动处理）

### 首次初始化

```bash
# 初始化任意系统（自动启用 flakes）
just init <hostname>    # darwin / wsl / vps-server / desktop-linux
```

### 更新配置

```bash
# 构建并切换到新配置
just rebuild <hostname>

# 调试模式构建（带 --show-trace --verbose）
just rebuild-debug <hostname>

# 仅测试不切换（仅 Linux）
just test <hostname>

# 仅构建不切换（仅 Linux）
just build <hostname>
```

### 常用命令

```bash
just up              # 更新所有 flake 输入源
just upp <input>     # 更新指定输入源
just clean           # 清理旧版本（> 7 天）
just gc              # Nix store 垃圾回收
just fmt             # 格式化所有 .nix 文件
just history         # 列出系统版本历史
just repl            # 打开 nix repl
just gcroot          # 列出自动 GC roots
```
