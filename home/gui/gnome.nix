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
      ];
    };

    # 示例：blur-my-shell 扩展的个性化设置
    "org/gnome/shell/extensions/blur-my-shell" = {
      panel-brightness = 0.8;
      overview-brightness = 0.7;
      panel-blur = true;
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