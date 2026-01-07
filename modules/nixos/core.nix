# NixOS 基础配置（所有 Linux 通用）
{ config, pkgs, ... }:

{
  # TODO: 添加 NixOS 基础配置
  # - 基础系统包
  # - 用户配置
  # - SSH 配置
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # PasswordAuthentication = false; # 如果你想仅使用密钥
    };
  };
}
