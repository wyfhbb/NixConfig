# 完整用户配置（桌面 Linux）
{ config, pkgs, ... }:

{
  # TODO: 导入所有模块
  imports = [
    ../common/shell.nix
    ../common/cli-apps.nix
    ../common/core-tools.nix
    ../gui/terminal.nix
  ];
  # TODO: 设置你的用户名
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
