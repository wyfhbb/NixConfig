# macOS (Darwin) 配置

> 最后更新：2026-04-24

## 文件清单

### hosts/wyf-macbook/default.nix
主机入口。导入所有 darwin 模块和共享模块。配置内容：
- 主机名：`wyf-macbook`
- unstable overlay 定义
- 导入：`modules/common/`（nix-settings、fonts）+ `modules/darwin/`（system、apps、homebrew-mirror）

### modules/darwin/system.nix
macOS 系统偏好设置（通过 `defaults` 配置）：
- 时钟：24 小时制
- Dock：热角（左上 Mission Control，其余禁用）
- Finder：显示扩展名、完整路径、状态栏
- 触控板：轻触点击、三指拖动
- 键盘：全键盘控制、快速重复（Vim 友好）
- 隐私：阻止 .DS_Store 在网络/USB 驱动器生成
- 应用语言：微信、QQ、Office 使用中文

### modules/darwin/apps.nix
Homebrew 应用管理（通过 nix-homebrew）：
- **Brews**（命令行）：curl、wget、sox、nodejs、unar
- **Casks**（GUI 应用）：Chrome、VS Code、Ghostty、QQ、微信、企业微信、Termius、LocalSend、腾讯会议、Mos、UTM、飞书、Docker Desktop、百度网盘、Postman、OBS、Clash Party、Logi Options+
- **App Store**：OneDrive、Excel、PowerPoint、Word、Windows App
- 配置 `onActivation.cleanup = "zap"` — 未声明的 cask 会被移除

### modules/darwin/homebrew-mirror.nix
清华大学 Homebrew 镜像源配置：
- API、bottles、brew git、core git、pip 全部走清华镜像

## 修改指南

| 任务 | 修改文件 |
|------|----------|
| 添加/移除 Homebrew 应用 | `modules/darwin/apps.nix` |
| 修改 macOS 系统偏好 | `modules/darwin/system.nix` |
| 修改镜像源 | `modules/darwin/homebrew-mirror.nix` |
| 修改主机级设置 | `hosts/wyf-macbook/default.nix` |
| 修改用户环境 | 参见 [home.md](home.md)（profile: `macos.nix`） |

## 注意事项

- macOS 的 TouchID sudo 认证在 `hosts/wyf-macbook/default.nix` 中启用
- Darwin 构建是两步过程，参见 [flake.md](flake.md)
- `apps.nix` 中 `onActivation.cleanup = "zap"` 意味着删除 cask 声明等同于卸载
