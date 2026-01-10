# WSL 主机配置
{
  config,
  pkgs,
  username,
  hostname,
  ...
}:

{
  imports = [
    # 通用设置 wsl不需要字体
    ../../modules/common/nix-settings.nix
    # nixos设置
    ../../modules/nixos/core.nix
  ];

  networking.hostName = hostname;
  wsl.enable = true;
  wsl.defaultUser = "wyf";

  # 修复WSL上NVIDIA-SMI
  environment.variables.LD_LIBRARY_PATH = "/usr/lib/wsl/lib";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    # initialPassword = "password"; # 如果需要，可以设置初始密码
  };
  system.stateVersion = "25.11";
}
