# Home Manager 用户配置

> 最后更新：2026-04-24

## Profile 组装关系

每个平台 profile 导入不同模块来组装用户环境：

```
home/profiles/
├── macos.nix    → core-tools + terminal
├── desktop.nix  → core-tools + package + terminal + input-method + gnome + noctalia
├── wsl.nix      → core-tools + package
└── server.nix   → (空，TODO)
```

## 通用工具（home/common/）

### core-tools.nix
**用户级 CLI 工具链**，所有平台共享。这是最核心的用户配置文件。

包含的工具及配置：

| 工具 | 关键配置 |
|------|----------|
| **Neovim** | catppuccin-mocha 主题，13 个插件（treesitter、telescope、lualine、nvim-tree、leap 等），leader = space |
| **Tmux** | 鼠标启用，1-based 索引，`\|` / `-` 分屏，vim 方向键，插件：resurrect、continuum |
| **Git** | editor=nvim，pull.rebase=true，30+ alias，merge tool=nvimdiff，diff=histogram |
| **Zsh** | Oh-My-Zsh（git/tmux/docker 插件）+ Powerlevel10k + syntax-highlighting + autosuggestions |
| **Yazi** | 文件管理器，启用 git 集成 |
| **direnv** | nix-direnv 集成 |

额外安装的包：`uv`、`pnpm`、`unstable.claude-code`

### package.nix
额外包：`nodejs_24`。仅 desktop 和 wsl 导入。

### p10k.zsh
Powerlevel10k 主题配置文件（rainbow 风格，双行提示符）。不需要手动修改，由 `p10k configure` 生成。

### conda-init.zsh
Conda 环境初始化脚本。Zsh 启动时 source。

## GUI 配置（home/gui/）

### terminal.nix
Ghostty 终端配置：
- 通用：MesloLGS NF 字体，size 10，VS Code Dark+ 配色，光标 smear 特效（自定义 GLSL shader）
- macOS 特有：透明标题栏、背景模糊、透明度 0.7
- Linux 特有：禁用窗口装饰（Niri 处理）、暗色窗口主题

平台差异通过 `pkgs.stdenv.isDarwin` 条件判断。

### input-method.nix
Fcitx5 + Rime 输入法配置（**仅 Linux**）：
- 方案：小鹤双拼（xiaoheFlypy，从 GitHub release 下载）
- 主题：非人哉（暗色）
- 字体：PingFang SC 12
- 环境变量：GTK_IM_MODULE、QT_IM_MODULE、XMODIFIERS

### gnome.nix（home 级）
GNOME dconf 用户设置：
- 暗色模式、电池百分比、星期显示
- 触控板自然滚动、轻触点击
- Mutter：分数缩放、VRR、XWayland 原生缩放
- 扩展配置：dash-to-dock（底部、自动隐藏、48px 图标）
- Nautilus 书签列表
- `open-as-admin.py`：右键菜单「以管理员打开」扩展

### niri/config.kdl
Niri 窗口管理器配置（KDL 格式）。由 `home/profiles/desktop.nix` 通过 `xdg.configFile` 部署。

### cursor_smear.glsl
Ghostty 光标 smear 特效着色器。由 `terminal.nix` 引用。

### macOS-cursor.tar.gz
macOS 风格光标主题包。由 `home/profiles/desktop.nix` 解压到 `~/.local/share/icons/`。

## Profile 详情

### desktop.nix（home/profiles/）
除导入模块外的额外配置：
- 光标主题：macOS cursor（从 tar.gz 解压）
- Niri 配置：部署 `config.kdl` 到 XDG config
- Noctalia Shell：启用但 systemd 禁用（由 niri spawn-at-startup 启动）
- systemd：sd-switch 用于优雅重载

### macos.nix（home/profiles/）
- Home 路径：`/Users/wyf`
- 仅导入 core-tools + terminal

### wsl.nix（home/profiles/）
- Home 路径：`/home/wyf`
- 仅导入 core-tools + package（无 GUI）

## 修改指南

| 任务 | 修改文件 |
|------|----------|
| 添加/修改 CLI 工具或 dotfile | `home/common/core-tools.nix` |
| 修改 Neovim 插件或配置 | `home/common/core-tools.nix`（programs.neovim 部分） |
| 修改终端外观/行为 | `home/gui/terminal.nix` |
| 修改输入法设置 | `home/gui/input-method.nix` |
| 修改 GNOME 用户偏好 | `home/gui/gnome.nix` |
| 修改 Niri 窗口管理器 | `home/gui/niri/config.kdl` |
| 为新平台创建 profile | `home/profiles/` 新建文件并在 `flake.nix` 引用 |
| 添加 Node.js 等运行时包 | `home/common/package.nix` |

## 注意事项

- `core-tools.nix` 是跨平台共享的，修改时注意不要引入仅 Linux/macOS 可用的包
- `terminal.nix` 使用 `stdenv.isDarwin` 做平台判断，添加平台特定配置时需遵循此模式
- Git 用户信息已配置（wyf, GitHub noreply email），不要修改
