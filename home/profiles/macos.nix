# macOS 用户配置
{ config, pkgs, ... }:

{
  # 导入通用模块
  imports = [
    ../common/shell.nix
    ../common/cli-apps.nix
    ../gui/terminal.nix
  ];

  # Home Manager 需要知道用户和主目录
  home = {
    username = "wyf";
    homeDirectory = "/Users/wyf";

    # Home Manager 版本管理
    # 这个值决定了 Home Manager 的默认行为
    # 不要随意更改，除非你知道自己在做什么
    #
    # 你可以在不改变此值的情况下更新 Home Manager
    # 详见 Home Manager 的发布说明了解每个版本的变更
    stateVersion = "25.11";
  };

  # 让 Home Manager 管理自身
  programs.home-manager.enable = true;
}
