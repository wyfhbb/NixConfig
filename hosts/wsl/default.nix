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
    ../../modules/common/fonts.nix
    ../../modules/common/nix-settings.nix
    ../../modules/nixos/core.nix
  ];

  networking.hostName = hostname;
  wsl.enable = true;
  wsl.defaultUser = "wyf";

  # 修复WSL上NVIDIA-SMI
  environment.variables.LD_LIBRARY_PATH = "/usr/lib/wsl/lib";

  # 增加WSL对于VSCode的支持
  programs.nix-ld.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    # initialPassword = "password"; # 如果需要，可以设置初始密码
  };
  system.stateVersion = "25.11";
}
