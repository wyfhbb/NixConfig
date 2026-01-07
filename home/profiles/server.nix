# 完整用户配置（桌面 Linux）
{ config, pkgs, ... }:

{
  # TODO: 导入所有模块
  imports = [
    ../common/cli-apps.nix
    ../gui/terminal.nix
  ];

}
