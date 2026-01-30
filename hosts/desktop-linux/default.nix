# 桌面 Linux 配置
{
  config,
  pkgs,
  username,
  hostname,
  ...
}:

{
  imports = [
    # 通用设置
    ../../modules/common/fonts.nix
    ../../modules/common/nix-settings.nix
    # nixos设置
    ../../modules/nixos/core.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gnome.nix
    # 系统硬件适配设置
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = hostname;
  # networking.wireless.enable = true;  # 通过 wpa_supplicant 启用无线网络支持。

  # 如需网络代理请在此配置
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 启用网络
  networking.networkmanager.enable = true;

  # Noctalia 必需的系统服务
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # --- Intel Ultra (Meteor Lake) ---
  # 使用最新内核以获得更好的 SoundWire/SOF 支持
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 启用所有非自由固件，并显式加载 SOF 固件
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [
    sof-firmware
  ];

  # 强制使用 SOF 驱动并自动匹配 HDA 模型，并启用 NPU (VPU) 驱动
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=3
    options snd-hda-intel model=auto
  '';

  # Intel NPU (VPU) 支持 - 手动加载内核模块
  boot.kernelModules = [ "intel_vpu" ];
  # ---------------------------------------

  # 定义用户账户。别忘了用"passwd"设置密码。
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.11";
}
