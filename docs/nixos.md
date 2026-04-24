# NixOS 系统配置

> 最后更新：2026-04-24

## 主机配置

### hosts/desktop-linux/default.nix
桌面主机入口。关键配置：
- 主机名：`nixos-wyf`，GPU：AMD 核显（`igpu-amd.nix`）
- 导入：core、desktop、gnome、graphic、fonts、nix-settings
- 启用：蓝牙、power-profiles-daemon、upower、NetworkManager
- Swap：64GB 文件
- 系统包：lazygit、pciutils、ntfs3g、xwayland-satellite、gparted、mission-center、powertop、lm_sensors

### hosts/wsl/default.nix
WSL 主机入口。最小化配置：
- 主机名：`nixwsl`
- 导入：core、nix-settings
- NVIDIA GPU 支持：`LD_LIBRARY_PATH = "/usr/lib/wsl/lib"`
- WSL 默认用户：wyf

### hosts/vps-server/default.nix
服务器模板（**WIP**，当前为空）。

## 系统模块

### modules/nixos/core.nix
NixOS 基础配置：
- 系统包：wget、curl、binutils、strace、lsof
- nix-ld：兼容预编译二进制文件
- OpenSSH：启用，禁止 root 登录

### modules/nixos/desktop.nix
桌面环境完整配置（**最大的模块文件**）：

| 功能区 | 配置内容 |
|--------|----------|
| 引导 | GRUB2 + Whitesur 主题，最多 10 代 |
| 窗口管理 | Niri (Wayland compositor) 启用 |
| 国际化 | en_US.UTF-8 主语言，zh_CN.UTF-8 本地化覆盖 |
| 输入法 | Fcitx5 + Rime + 中文附加组件 |
| 字体 | PingFang SC 默认，Noto 系列回退 |
| 音频 | PipeWire（含 ALSA 32-bit 支持） |
| 登录 | GDM 显示管理器 |
| 容器 | Docker（用户 wyf 在 docker 组） |
| 代理 | Mihomo TUN 模式，配置来自 PassWall2gfw 子模块 |
| 防火墙 | 启用，信任 Meta 接口，checkReversePath = false |
| GUI 应用 | Chrome、Ghostty、VS Code、OBS、WPS Office、QQ、微信、腾讯会议 |

### modules/nixos/gnome.nix
GNOME 桌面配置：
- 扩展：appindicator、blur-my-shell、dash-to-dock、tophat、magic-lamp、transparent-window-moving
- 排除包：gnome-tour、epiphany、yelp、xterm 等
- dconf：Mutter VRR、暗色模式、触控板自然滚动、动态工作区
- Qt 主题：adwaita-dark

### modules/nixos/graphic.nix
显卡选择器，通过导入 `graphics/` 子目录下的模块来组合显卡驱动。

### modules/nixos/graphics/

| 文件 | 模式 | 说明 |
|------|------|------|
| `igpu-amd.nix` | AMD 核显 | Vulkan + VA-API (radeonsi) |
| `igpu-intel.nix` | Intel 核显 | iHD 驱动 + PRIME 支持 |
| `nvidia-powersave.nix` | 省电 | Offload 模式，核显输出，独显按需，细粒度电源管理 |
| `nvidia-performance.nix` | 性能 | Sync 模式，独显直连，禁用电源管理 |

切换显卡：修改 `graphic.nix` 中的 imports 列表。

### modules/nixos/intelFix.nix
Intel 平台修复：
- SOF 音频固件 + ALSA UCM 配置
- thermald 热管理
- 内核参数：`intel_pstate=active`
- DSP 驱动：`snd-intel-dspcfg dsp_driver=3`

### modules/nixos/cs35l56Fix.nix
Cirrus CS35L56 音频编解码器固件：
- 从 linux-firmware git 拉取 .wmfw + .bin 固件文件
- 禁用固件压缩

### modules/nixos/server.nix
服务器模块（**TODO**，当前为空）。

## 修改指南

| 任务 | 修改文件 |
|------|----------|
| 添加/移除 NixOS 桌面应用 | `modules/nixos/desktop.nix` |
| 修改 GNOME 扩展/设置 | `modules/nixos/gnome.nix` |
| 切换显卡驱动 | `modules/nixos/graphic.nix` |
| 修改基础系统包 | `modules/nixos/core.nix` |
| 修改主机硬件/启动配置 | `hosts/<hostname>/default.nix` |
| 修改代理/防火墙 | `modules/nixos/desktop.nix`（Mihomo 和 firewall 部分） |
| 修改用户环境 | 参见 [home.md](home.md) |

## 注意事项

- `desktop.nix` 中 Mihomo 使用 `unstable.mihomo`（需要 xhttp 支持的新版本）
- WPS Office 通过 `LANGUAGE=zh_CN` 环境变量启用中文
- 防火墙 `checkReversePath = false` 是 Mihomo TUN 所需
- 显卡模块错误配置可能导致黑屏，修改前务必确认硬件型号
