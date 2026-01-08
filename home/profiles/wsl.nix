# 完整用户配置（wsl）
{ config, pkgs, ... }:

{
  imports = [
    ../common/cli-apps.nix
    ../common/core-tools.nix
  ];

  home = {
    username = "wyf";
    homeDirectory = "/home/wyf";
    stateVersion = "25.11";
  };

  # 启用 home-manager 和 git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # 更改配置时优雅地重新加载系统单元
  systemd.user.startServices = "sd-switch";
}
