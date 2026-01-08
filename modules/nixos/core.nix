# NixOS 基础配置（所有 Linux 通用）
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];
  # 允许安装不自由的软件包
  nixpkgs.config.allowUnfree = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # PasswordAuthentication = false; # 如果你想仅使用密钥
    };
  };
}
