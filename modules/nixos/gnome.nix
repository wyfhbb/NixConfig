{ config, pkgs, ... }:

{
  # ────────────────────────────────────────────────
  # 核心：启用 GNOME + GDM（Wayland 默认已开启）
  # ────────────────────────────────────────────────
  services.desktopManager.gnome.enable = true;        # 启用 GNOME 桌面环境

  # ────────────────────────────────────────────────
  # 精简 GNOME：关闭不常用的官方组件（节省空间）
  # ────────────────────────────────────────────────
  # services.gnome = {
  #   # 保留最核心的桌面功能：核心服务、shell、常用工具（含终端）以及文件管理器
  #   core-os-services.enable   = true;   # 必须保留的核心服务
  #   core-shell.enable         = true;   # 必须保留的 shell（如 gnome-shell）
  #   core-utilities.enable     = true;   # 常用工具（计算器、终端等）
  #   # 显式保留文件管理器（Nautilus）以确保桌面导航可用
  #   # 注意：模块的具体字段可能随 nixpkgs 变化，但我们在 systemPackages 中也确保安装 nautilus
  #   # 以下三项按精简目标禁用（默认/预装项中很多人不需要）
  #   core-developer-tools.enable = false;
  #   games.enable                = false;  # 禁用游戏组件
  # };

  # 排除一些 GNOME 自带但几乎没人用的包（进一步精简）
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour          # 新手引导
    gnome-user-docs     # 用户手册
    yelp                # GNOME 帮助
    epiphany            # GNOME Web 浏览器
    xterm               # XTerm 终端（禁用）
    gnome-contacts      # 联系人（禁用）
  ]);

  # ────────────────────────────────────────────────
  # 系统级 GNOME 扩展（少数扩展适合放这里）
  # 常用系统托盘、模糊效果等
  # ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    gnome-tweaks          # GNOME Tweaks（调整隐藏设置）
    gnomeExtensions.appindicator  # 系统托盘图标支持（非常常用）
    gnomeExtensions.blur-my-shell # 窗口/面板模糊效果（美观）
    gnomeExtensions.dash-to-dock  # 如果不喜欢默认 dock，可启用
  ];

  # ────────────────────────────────────────────────
  # 启用 Mutter 实验特性（分数缩放、VRR、可变刷新率等）
  # 2025-2026 年 GNOME 主流做法
  # ────────────────────────────────────────────────
  programs.dconf.enable = true;

  # 系统级 dconf（影响所有用户）
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer"     # 分数缩放（最重要！）
          "variable-refresh-rate"         # 支持 VRR/FreeSync
          "xwayland-native-scaling"       # XWayland 程序更清晰
        ];
      };
    };
  }];

  # ────────────────────────────────────────────────
  # Qt 程序跟随 GNOME 主题（非常推荐）
  # ────────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme = "gnome";          # 让 Qt 用 GNOME 的主题设置
    style = "adwaita-dark";           # 深色 Adwaita（或改成 adwaita）
  };

  # ────────────────────────────────────────────────
  # 其他实用系统选项
  # ────────────────────────────────────────────────
  hardware.sensor.iio.enable = true;    # 自动屏幕旋转（笔记本常用）

  # 如果需要自动登录（开发机/个人机常用）
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "yifan";
}