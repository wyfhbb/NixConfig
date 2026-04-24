# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> 最后更新：2026-04-24

## 项目概览

统一的 Nix Flakes 配置仓库，管理用户 `wyf` 的 4 个系统：

| 配置名 | 主机名 | 架构 | 平台 |
|--------|--------|------|------|
| `darwin` | wyf-macbook | aarch64-darwin | macOS (nix-darwin + Homebrew) |
| `desktop` | nixos-wyf | x86_64-linux | NixOS 桌面 (Niri/Wayland + GNOME) |
| `wsl` | nixwsl | x86_64-linux | NixOS on WSL |
| `vps` | vps-server | x86_64-linux | NixOS 服务器 (WIP) |

入口文件：`flake.nix` — 定义 inputs（nixpkgs 25.11、home-manager、nix-darwin 等）和所有系统输出。

## 文档体系

本仓库使用 `docs/` 文档框架辅助 AI 理解代码。按需查阅：

- **[docs/CATALOG.md](docs/CATALOG.md)** — 文档索引，按任务类型指向对应文档
- **[docs/flake.md](docs/flake.md)** — Flake 结构、inputs/outputs、构建流程
- **[docs/darwin.md](docs/darwin.md)** — macOS 配置文件清单与修改指南
- **[docs/nixos.md](docs/nixos.md)** — NixOS 系统模块、显卡、桌面配置
- **[docs/home.md](docs/home.md)** — Home Manager 用户配置、CLI/GUI 工具

**文档日期规则**：每个文档顶部标注 `> 最后更新：YYYY-MM-DD`。修改代码后若对应文档内容过期，必须同步更新文档内容和日期。

## 构建与部署命令

所有操作通过 `just`（Justfile）执行：

```bash
just rebuild <hostname>        # 构建并切换（darwin/wsl/vps-server/desktop-linux）
just rebuild-debug <hostname>  # 带 --show-trace --verbose 的调试构建
just test <hostname>           # 测试 NixOS 配置但不切换（仅 Linux）
just build <hostname>          # 构建但不切换（仅 Linux）
just init <hostname>           # 首次初始化（启用实验性功能）
just fmt                       # 格式化所有 .nix 文件（nixfmt-tree）
just up                        # 更新所有 flake inputs
just upp <input>               # 更新指定 flake input
just clean                     # 删除 7 天前的旧版本
just gc                        # Nix store 垃圾回收
```

**注意**：NixOS 构建使用 `--impure` 和 `submodules=1`（PassWall2gfw 子模块）。Darwin 构建需要两步（先 nix build 再 darwin-rebuild）。所有 rebuild/build/test 命令需要 `sudo`。

## AI 验证方式（无 root 权限）

AI 没有 root 权限，使用以下命令验证：

```bash
just fmt                                    # 检查格式化
nix flake check                             # 验证 flake 结构
nix-instantiate --parse <file.nix>          # 检查单个文件语法
```

**不要**尝试 `just rebuild`、`just build` 或 `just test` — 它们需要 sudo。

## 架构与模块流

```
flake.nix                          # 入口：定义所有系统配置
  ├── hosts/<hostname>/default.nix # 主机特定配置：导入模块、设置硬件
  ├── modules/                     # 系统级 NixOS/Darwin 模块
  │   ├── common/                  # 跨平台（nix-settings、fonts）
  │   ├── darwin/                  # macOS 系统设置、Homebrew 应用
  │   └── nixos/                   # NixOS 核心、桌面、显卡、修复
  └── home/                        # Home Manager 用户配置
      ├── common/                  # CLI 工具（neovim、tmux、git、zsh）
      ├── gui/                     # GUI 配置（终端、输入法、GNOME）
      └── profiles/<platform>.nix  # 按平台组装的 profile
```

**数据流**：`flake.nix` → `hosts/`（选择模块）→ `modules/`（系统配置）+ `home/profiles/`（用户配置，通过 home-manager）。

**关键模式**：`specialArgs` 向所有模块传递 `username`、`hostname`、`inputs`。`inputs` 提供 `nixpkgs-unstable` overlay，用于获取最新包（如 `unstable.claude-code`、`unstable.vscode`）。

## 代码修改边界

### AI 可以安全修改的内容

- **增删软件包**：`modules/darwin/apps.nix`（Homebrew）、`modules/nixos/desktop.nix`（NixOS 桌面应用）、`modules/common/nix-settings.nix`（跨平台 CLI 工具）、`home/common/core-tools.nix`（用户 CLI 工具）
- **Home Manager 点文件**：`home/` 下的所有内容（neovim、tmux、zsh、终端设置）
- **GNOME/桌面设置**：`home/gui/gnome.nix`、`modules/nixos/gnome.nix`
- **新建主机配置**：在 `hosts/<new-host>/default.nix` 创建并加入 `flake.nix`

### AI 需谨慎修改的内容

- **flake.nix**：影响所有系统，仅在添加/移除 hosts 或 inputs 时修改
- **显卡模块**（`modules/nixos/graphics/`）：硬件相关，错误配置可能导致无法显示
- **启动/内核设置**：GRUB 配置、内核参数、固件 — 可能导致无法启动
- **网络/代理**：Mihomo 配置、`desktop.nix` 中的防火墙规则 — 可能断网
- **PassWall2gfw/**：Git 子模块，不要直接修改

### AI 未经明确请求不应修改的内容

- `flake.lock` — 仅通过 `just up` 或 `just upp` 更新
- `init_btrfs.sh` — 破坏性磁盘分区脚本
- 硬件专用固件文件（`cs35l56Fix.nix`、`intelFix.nix`）

## 修改后审查清单

每次代码修改后，按顺序执行：

1. **格式化**：运行 `just fmt` 确保代码风格一致
2. **语法检查**：用 `nix-instantiate --parse <file>` 验证修改的 `.nix` 文件
3. **跨平台感知**：修改 `modules/common/` 或 `home/common/` 时，确保 Darwin 和 NixOS 兼容（检查 `stdenv.isDarwin` / `stdenv.isLinux` 条件）
4. **同步文档**：如果修改影响了文档描述的内容，**必须**同步更新对应的 `docs/` 文档，并更新文档顶部的「最后更新」日期：
   - 修改 `modules/darwin/` 或 `hosts/wyf-macbook/` → 更新 `docs/darwin.md`
   - 修改 `modules/nixos/` 或 `hosts/desktop-linux/`、`hosts/wsl/` → 更新 `docs/nixos.md`
   - 修改 `home/` → 更新 `docs/home.md`
   - 修改 `flake.nix` 或 `Justfile` → 更新 `docs/flake.md`
   - 目录结构变化（新增/删除文件夹或文档） → 更新 `docs/CATALOG.md`
   - 构建命令、架构、修改边界变化 → 更新本文件（`CLAUDE.md`）
   - 用户可见功能变化 → 更新 `README.md`

## Nix 语言约定

- 使用 `nixpkgs-unstable` overlay 获取最新版本包（通过 `unstable.<pkg>` 访问）
- 包引用：`pkgs.<name>` 表示稳定版，`unstable.<name>` 表示最新版
- 所有模块接收 `{ config, pkgs, username, hostname, ... }` 作为参数
- Unfree 包全局允许（`nixpkgs.config.allowUnfree = true`）
- 格式化工具：`nixfmt-tree`（通过 `nix fmt`）
- 注释语言：中文
