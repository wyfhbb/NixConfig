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
    ../../modules/common/fonts.nix
    ../../modules/common/nix-settings.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/desktop.nix
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

  # 增加WSL对于VSCode的支持
  programs.nix-ld.enable = true;

  # 定义用户账户。别忘了用“passwd”设置密码。
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.11";
}
