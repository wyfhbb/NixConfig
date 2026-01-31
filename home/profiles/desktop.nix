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
    ../gui/gnome.nix
    # Noctalia Shell 用户配置
    inputs.noctalia.homeModules.default
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  # 启用 home-manager
  programs.home-manager.enable = true;

  # Noctalia Shell 配置
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      # 在此添加您的 Noctalia 配置
    };
  };

  home.pointerCursor = {
    package = pkgs.stdenv.mkDerivation {
      name = "macOS-cursor";
      src = ../gui/macOS-cursor.tar.gz;
      nativeBuildInputs = [ pkgs.gnutar pkgs.gzip ];
      dontBuild = true;
      unpackPhase = ''
        tar -xzf $src
      '';
      installPhase = ''
        mkdir -p $out/share/icons/macOS
        cp -r macOS/* $out/share/icons/macOS/
      '';
    };
    name = "macOS";
    gtk.enable = true;
    x11.enable = true;
  };

  # 导入 niri 配置文件
  xdg.configFile."niri/config.kdl" = {
    source = ../gui/niri/config.kdl;
    force = true;
  };

  # 更改配置时优雅地重新加载系统单元
  systemd.user.startServices = "sd-switch";
}
