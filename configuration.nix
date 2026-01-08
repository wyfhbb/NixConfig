# 编辑此配置文件以定义系统应安装的内容。
# 可用帮助：configuration.nix(5) man 手册页，或运行 ‘nixos-help’ 打开的 NixOS 手册。

{ config, pkgs, ... }:

{
  imports =
    [ # 包含硬件扫描结果。
      ./hardware-configuration.nix
    ];

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



  networking.hostName = "nixos"; # 定义你的主机名。
  # networking.wireless.enable = true;  # 通过 wpa_supplicant 启用无线网络支持。

  # 如需网络代理请在此配置
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 启用网络
  networking.networkmanager.enable = true;

  # 设置时区。
  time.timeZone = "Asia/Shanghai";

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

  # 启用 X11 窗口系统。
  services.xserver.enable = true;

  # 启用 GNOME 桌面环境。
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # 在 X11 中配置键盘布局
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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

  # 定义用户账户。别忘了用“passwd”设置密码。
  users.users.wyf = {
    isNormalUser = true;
    description = "wyf";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # 安装 firefox。
  programs.firefox.enable = true;

  # 允许不自由软件包
  nixpkgs.config.allowUnfree = true;

  # 列出系统环境中已安装的软件包。查询可运行：
  # 示例：$ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # 别忘了添加编辑器以编辑 configuration.nix！Nano 默认已安装。
  #  wget
    vscode
    google-chrome
    git
  ];

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
  # 或者完全禁用防火墙。
  # networking.firewall.enable = false;

  # 该值决定了系统中有状态数据（如文件位置和数据库版本）
  # 的默认设置所基于的 NixOS 版本。建议保留为首次安装
  # 该系统时的发行版本。在更改此值前，请先阅读该选项的
  # 文档（例如 man configuration.nix 或 https://nixos.org/nixos/options.html）。
  system.stateVersion = "25.11"; # 你有阅读上述注释吗？

}
