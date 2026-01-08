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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # 增加WSL对于VSCode的支持
  programs.nix-ld.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  system.stateVersion = "25.11";
}
