# Flake 结构与构建流程

> 最后更新：2026-04-24

## flake.nix 结构

### Inputs（依赖源）

| Input | 用途 | 版本/分支 |
|-------|------|-----------|
| `nixpkgs` | 主软件仓库 | nixos-25.11 |
| `nixpkgs-unstable` | 最新版本包（overlay 方式引入） | nixos-unstable |
| `home-manager` | 用户环境管理 | release-25.11 |
| `darwin` | macOS 系统管理 (nix-darwin) | nix-darwin-25.11 |
| `nix-homebrew` | Nix 管理 Homebrew | latest |
| `nixos-wsl` | WSL 运行 NixOS | release-25.11 |
| `noctalia` | Wayland 桌面 Shell（配合 Niri） | latest |
| `grub2-themes` | GRUB2 启动主题 | latest |

大多数 input 使用 `inputs.nixpkgs.follows = "nixpkgs"` 锁定到同一 nixpkgs 版本。

### Outputs（系统配置）

```
outputs
├── darwinConfigurations
│   └── darwin          → hosts/wyf-macbook + home/profiles/macos.nix
├── nixosConfigurations
│   ├── desktop         → hosts/desktop-linux + home/profiles/desktop.nix
│   ├── wsl             → hosts/wsl + home/profiles/wsl.nix
│   └── vps             → hosts/vps-server + home/profiles/server.nix
└── formatter            → nixfmt-tree (x86_64-linux, aarch64-darwin)
```

### 全局变量

- `username = "wyf"` — 所有主机共用
- 每个主机定义自己的 `hostname` 和 `system`
- `specialArgs` 向模块传递 `username`、`hostname`、`inputs`

### Unstable Overlay 机制

在各 host 的 `default.nix` 中定义 overlay：
```nix
nixpkgs.overlays = [
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.system;
      config.allowUnfree = true;
    };
  })
];
```
之后模块中通过 `pkgs.unstable.<pkg>` 访问最新版本包。

## 构建流程

### Darwin（macOS）

两步构建：
1. `nix build .#darwinConfigurations.darwin.system` — 构建系统
2. `sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin` — 切换配置

### NixOS（Linux）

单步构建，但需要额外标志：
```bash
sudo nixos-rebuild switch --flake ".?submodules=1#<hostname>" --impure
```
- `submodules=1`：因为 PassWall2gfw 是 git submodule
- `--impure`：desktop 配置需要

### Justfile 命令映射

| 命令 | 实际操作 |
|------|----------|
| `just init <host>` | 首次构建（启用实验性功能） |
| `just rebuild <host>` | 日常更新（构建 + 切换） |
| `just rebuild-debug <host>` | 调试构建（--show-trace --verbose） |
| `just test <host>` | 仅测试不切换（Linux only） |
| `just build <host>` | 仅构建不切换（Linux only） |

`<host>` 取值：`darwin`、`wsl`、`vps-server`、`desktop-linux`

## flake.lock

- 由 `nix flake update` / `nix flake update <input>` 自动管理
- 不要手动编辑
