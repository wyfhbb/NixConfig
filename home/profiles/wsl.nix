# 完整用户配置（wsl）
{ config, pkgs, username, ... }:

{
  imports = [
    ../common/cli-apps.nix
    ../common/core-tools.nix
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  # 启用 home-manager
  programs.home-manager.enable = true;

  # 更改配置时优雅地重新加载系统单元
  systemd.user.startServices = "sd-switch";
}
