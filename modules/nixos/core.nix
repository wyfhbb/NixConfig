# NixOS 基础配置（所有 Linux 通用）
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
    # 调试工具
    binutils                  # nm, objdump, readelf 等二进制分析工具
    strace                    # 系统调用跟踪
    unzip                     # 解压工具
    lsof                      # 列出打开的文件和网络连接
    just
    fastfetch
    htop
    tree
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
  # mkDefault 允许各主机（如 WSL）覆盖此值
  environment.variables.LD_LIBRARY_PATH = lib.mkDefault "${pkgs.libGL}/lib:/run/opengl-driver/lib";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # PasswordAuthentication = false; # 如果你想仅使用密钥
    };
  };
}
