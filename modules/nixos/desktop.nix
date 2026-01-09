# 桌面环境配置
{ config, pkgs, inputs, ... }:

{
  # TODO: 添加桌面环境配置
  # - 桌面环境（GNOME/KDE/etc）
  # - 显示管理器
  # - GUI 应用

  # 启动引导程序。
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = false;
        grub = { 
          enable = true;
          efiSupport = true;
          # efiInstallAsRemovable = true;
          device = "nodev";
          useOSProber = true;
    };
  };

  # 列出系统环境中已安装的软件包。查询可运行：
  # 示例：$ nix search wget
  environment.systemPackages = with pkgs; [
    # 启用xwayland支持
    xwayland-satellite
    vscode
    google-chrome
    ghostty
    # GNOM
    gnomeExtensions.appindicator  # 托盘图标支持
    file-roller  # 解压缩
    # Noctalia Shell
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    # 网络工具
    networkmanagerapplet
    clash-verge-rev
    termius
    obs-studio
  ];

  # 选择本地化属性。
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 输入法fcitx5配置
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
    ];
  };


  # 字体配置
  fonts.fontconfig.defaultFonts = {
    serif = [ "PingFang SC" "Noto Serif" ];
    sansSerif = [ "PingFang SC" "Noto Sans" ];
    monospace = [ "Noto Sans Mono" "PingFang SC" ];
  };

  # 在 X11 中配置键盘布局
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # 启用 X11 窗口系统。
  services.xserver.enable = true;

  # 启用 CUPS 以打印文档。
  services.printing.enable = true;

  # 启用 PipeWire 声音系统。
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # 如需使用 JACK 应用，取消注释此行
    #jack.enable = true;

    # 使用示例会话管理器（目前没有其他可用软件包，因此默认启用，
    # 暂时无需在配置中重复定义）
    #media-session.enable = true;
  };

  # 启用触控板支持（大多数桌面环境默认已启用）。
  # services.xserver.libinput.enable = true;

  # 启用 GNOME 桌面环境。
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # 启用 Niri 窗口管理器（Wayland compositor）
  programs.niri.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # 某些程序需要 SUID 包装器，可进一步配置，或在用户会话中启动。
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # 在此列出你想启用的服务：

  # 启用 OpenSSH 守护进程。
  # services.openssh.enable = true;

  # 在防火墙中开放端口。
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Mihomo TUN 模式所需的防火墙配置
  # 参考: https://wiki.nixos.org/wiki/Mihomo
  networking.firewall = {
    enable = true;
    # 将 TUN 设备添加到受信任接口，避免被防火墙拦截
    trustedInterfaces = [ "Meta" ];
    # 禁用反向路径过滤，允许 TUN 设备的流量正常路由
    checkReversePath = false;
  };

  # 配置 sudo 免密执行 mihomo
  # 允许用户测试不同版本的 mihomo，不托管给系统
  security.sudo.extraRules = [
    {
      users = [ "wyf" ];
      commands = [
        {
          command = "/home/wyf/Startup/mihomo/mihomo";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # 该值决定了系统中有状态数据（如文件位置和数据库版本）
  # 的默认设置所基于的 NixOS 版本。建议保留为首次安装
  # 该系统时的发行版本。在更改此值前，请先阅读该选项的
  # 文档（例如 man configuration.nix 或 https://nixos.org/nixos/options.html）。
}
