# 精简用户配置（服务器和 WSL）
{ config, pkgs, inputs, username, ... }:

{
  imports = [
    # 通用
    ../common/cli-apps.nix
    ../common/core-tools.nix
    # 带有 GUI 的配置
    ../gui/terminal.nix
    ../gui/input-method.nix
    ../gui/gnome_usr.nix
    ../gui/stylix.nix
    # Noctalia Shell 用户配置
    inputs.noctalia.homeModules.default
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
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

  # 鼠标指针配置已迁移到 stylix（modules/common/stylix.nix）

  # 导入 niri 配置文件
  xdg.configFile."niri/config.kdl" = {
    source = ../gui/niri/config.kdl;
    force = true;
  };

  # 更改配置时优雅地重新加载系统单元
  systemd.user.startServices = "sd-switch";
}
