# 精简用户配置（服务器和 WSL）
{ config, pkgs, inputs, ... }:

{
  imports = [
    ../common/cli-apps.nix
    ../common/core-tools.nix
    ../gui/terminal.nix
    ../gui/input-method.nix
    inputs.noctalia.homeModules.default
  ];

  home = {
    username = "wyf";
    homeDirectory = "/home/wyf";
    stateVersion = "25.11";
  };

  # 启用 home-manager 和 git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Noctalia Shell 配置
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      # 在此添加您的 Noctalia 配置
    };
  };

  # 更改配置时优雅地重新加载系统单元
  systemd.user.startServices = "sd-switch";
}
