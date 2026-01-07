# macOS (Darwin) 主机配置
{ config, pkgs, username, hostname, ... }:

{
  imports = [
    ../../modules/common/nix-settings.nix
    ../../modules/common/fonts.nix
    ../../modules/darwin/system.nix
    ../../modules/darwin/apps.nix
    ../../modules/darwin/homebrew-mirror.nix
  ];

  # ==========================================
  # 主机名配置
  # ==========================================
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  # ==========================================
  # 用户配置
  # ==========================================
  # 声明将运行 `darwin-rebuild` 的用户
  # 这对于 `system.defaults` 中的某些“用户模式”偏好设置是必需的
  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
    description = username;
  };

  # ==========================================
  # Nix 配置
  # ==========================================
  # 将用户添加到 Nix 可信用户列表，允许使用 --option 等特权命令
  nix.settings.trusted-users = [ username ];
}
