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

  # 全局库路径
  # programs.nix-ld 只对通过 ld-linux 加载的程序生效；
  # 对于 dlopen() 动态加载（如 Electron/ANGLE 加载 libGL），需要 LD_LIBRARY_PATH
  environment.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.libGL}/lib:/run/opengl-driver/lib";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # PasswordAuthentication = false; # 如果你想仅使用密钥
    };
  };
}
