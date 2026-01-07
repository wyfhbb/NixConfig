# NixOS 基础配置（所有 Linux 通用）
{ config, pkgs, ... }:

{
  # 从 nix 的官方软件包仓库安装软件包。
  #
  # 这里安装的软件包对所有用户可用，并且在不同机器上是可复现的，也是可回滚的。
  # 但在 macOS 上，它不如 Homebrew 稳定。
  #
  # 相关讨论: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    just
    tmux
    wget
    fastfetch
    htop
    tree
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
