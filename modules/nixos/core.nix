# NixOS 基础配置（所有 Linux 通用）
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];

  # 添加vscode后端以及opencv等各种库的支持
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      libGL
      libGLU
      glib
      xorg.libX11
      xorg.libXext
      zlib
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # PasswordAuthentication = false; # 如果你想仅使用密钥
    };
  };
}
