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
        "dash-to-dock@micxgx.gmail.com"             # 自定义 dock
        "tophat@fflewddur.github.io" # 系统监视器扩展
        "compiz-alike-magic-lamp-effect@hermes83.github.com"
        "transparent-window-moving@noobsai.github.com"
      ];
    };

    # 示例：blur-my-shell 扩展的个性化设置
    "org/gnome/shell/extensions/blur-my-shell" = {
      panel-brightness = 0.8;
      overview-brightness = 0.7;
      panel-blur = true;
    };

    # ────────────────────────────────────────────────
    # Dash to Dock 扩展配置
    # ────────────────────────────────────────────────
    "org/gnome/shell/extensions/dash-to-dock" = {
      # ──── 位置与可见性 ────
      dock-position = "BOTTOM";           # 位置: LEFT, RIGHT, TOP, BOTTOM
      dock-fixed = false;                 # 是否固定显示（false 为自动隐藏）
      autohide = true;                    # 自动隐藏
      intellihide = true;                 # 智能隐藏（窗口接近时隐藏）
      extend-height = false;              # 是否延伸到屏幕边缘

      # ──── 动画与时间 ────
      animation-time = 0.2;               # 动画时长（秒）
      show-delay = 0.25;                  # 显示延迟（秒）
      hide-delay = 0.20;                  # 隐藏延迟（秒）

      # ──── 外观 ────
      dash-max-icon-size = 48;            # 最大图标大小（16-64）
      transparency-mode = "DYNAMIC";      # 透明度模式: DEFAULT, FIXED, DYNAMIC
      background-opacity = 0.8;           # 背景不透明度（0.0-1.0）
      # apply-custom-theme = false;       # 应用自定义主题
      # custom-theme-shrink = false;      # 缩小自定义主题

      # ──── 点击行为 ────
      click-action = "cycle-windows";     # 点击: cycle-windows, minimize, launch 等
      middle-click-action = "launch";     # 中键点击行为
      shift-click-action = "minimize";    # Shift+点击行为

      # ──── 显示选项 ────
      show-running = true;                # 显示正在运行的应用
      show-favorites = true;              # 显示收藏的应用
      show-trash = true;                  # 显示回收站图标
      show-mounts = true;                 # 显示挂载的卷
      show-show-apps-button = true;       # 显示应用程序按钮
      show-apps-at-top = false;           # 将应用程序按钮放在顶部

      # ──── 多显示器 ────
      # multi-monitor = false;            # 在所有显示器上显示
      # preferred-monitor = -1;           # 首选显示器（-1 为主显示器）

      # ──── 快捷键 ────
      hot-keys = false;                    # 启用 Super+(0-9) 快捷键

      # ──── 工作区 ────
      # isolate-workspaces = false;       # 仅显示当前工作区的应用
      # isolate-monitors = false;         # 仅显示当前显示器的应用
    };

    # ────────────────────────────────────────────────
    # TopHat 系统监视器扩展配置
    # ────────────────────────────────────────────────
    "org/gnome/shell/extensions/tophat" = {
      # 面板位置（生效）
      position-in-panel = "left";  # 可选: leftedge, left, center, right, rightedge

      # ──── 显示模式 ────
      # cpu-display = "chart";        # CPU 显示模式: chart, numeric, both
      # mem-display = "chart";        # 内存显示模式: chart, numeric, both
      # fs-display = "chart";         # 文件系统显示模式: chart, numeric, both

      # ──── 显示开关 ────
      # show-icons = true;            # 显示监视器图标
      # show-menu-actions = true;     # 显示菜单操作按钮
      # show-cpu = true;              # 显示 CPU 监视器
      # show-mem = true;              # 显示内存监视器
      # show-net = true;              # 显示网络监视器
      # show-disk = false;            # 显示磁盘 I/O 监视器
      # show-fs = true;               # 显示文件系统监视器

      # ──── 外观设置 ────
      # meter-fg-color = "#1dacd6";   # 进度条和图表颜色（十六进制或 RGBA）
      # use-system-accent = true;     # 使用系统主题色（GNOME 47+）

      # ──── 性能设置 ────
      # refresh-rate = "medium";      # 刷新频率: slow, medium, fast

      # ──── CPU 相关 ────
      # cpu-show-cores = true;        # 显示各个 CPU 核心
      # cpu-sort-cores = true;        # 按使用率排序 CPU 核心
      # cpu-normalize-proc-use = true; # 按核心数归一化进程 CPU 使用率

      # ──── 内存相关 ────
      # mem-abs-units = false;        # 使用绝对单位显示内存（而非百分比）

      # ──── 网络相关 ────
      # network-device = "";          # 指定监视的网络设备（空则自动选择）
      # network-usage-unit = "bytes"; # 网络流量单位: bytes, bits

      # ──── 文件系统相关 ────
      # mount-to-monitor = "";        # 指定监视的挂载点（空则自动选择）
      # fs-hide-in-menu = "";         # 在菜单中隐藏的挂载点（逗号分隔）

      # ──── 进程设置 ────
      # group-procs = true;           # 对进程分组显示
    };

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