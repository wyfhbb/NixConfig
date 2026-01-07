# macOS (Darwin) 主机配置
{ config, pkgs, username, hostname, ... }:

{
  imports = [
    ../../modules/common/nix-settings.nix
    ../../modules/common/apps.nix
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
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
