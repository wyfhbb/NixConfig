{ pkgs, ... }:

{
  # ────────────────────────────────────────────────
  # 启用 dconf（必须开启才能设置 GNOME 设置）
  # ────────────────────────────────────────────────
  dconf.enable = true;

  # ────────────────────────────────────────────────
  # 常用界面与行为设置
  # ────────────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme    = "prefer-dark";      # 强制深色模式（GTK4 生效）
      show-battery-percentage = true;       # 显示电池百分比
      clock-show-weekday = true;            # 顶部栏时钟显示星期
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;               # 自然滚动（macOS 风格）
      tap-to-click   = true;               # 轻触点击
    };

    "org/gnome/mutter" = {
      # 如果 configuration.nix 没设,这里也可以再强化
      experimental-features = [ "scale-monitor-framebuffer" ];
      dynamic-workspaces = true;           # 动态工作区(默认推荐)
      edge-tiling = true;                  # 窗口贴边自动半屏
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";  # 插电不休眠（桌面机常用）
    };
  };

  # ────────────────────────────────────────────────
  # 启用 GNOME 扩展（用户级，最常用在这里管理）
  # 需要先在 configuration.nix 或 home.packages 里安装扩展包
  # ────────────────────────────────────────────────
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # 常用扩展 UUID（根据你安装的包替换）
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"     # 系统托盘
        "blur-my-shell@aunetx"                        # 模糊效果
        # "gsconnect@andyholmes.github.io"              # KDE Connect 手机联动
        "dash-to-dock@micxgx.gmail.com"             # 自定义 dock
        "just-perfection.desktop"                    # 更多微调
      ];
    };

    # 示例：blur-my-shell 扩展的个性化设置
    "org/gnome/shell/extensions/blur-my-shell" = {
      panel-brightness = 0.8;
      overview-brightness = 0.7;
      panel-blur = true;
    };

    # 示例：gsconnect 设置（手机互联）
    # "org/gnome/shell/extensions/gsconnect" = {
    #   # name = "My NixOS Laptop";
    # };
  };

  # ────────────────────────────────────────────────
  # 其他 Home Manager 常用 GNOME 相关
  # ────────────────────────────────────────────────
  home.packages = with pkgs; [
    # gnomeExtensions.gsconnect     # 如果没在 configuration.nix 装
  ];

  # # Qt 主题（用户级补充，优先级高于系统）
  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita-dark";
  # };
}