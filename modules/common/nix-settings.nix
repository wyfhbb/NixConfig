# 所有平台通用的 Nix 设置
{
  pkgs,
  lib,
  username,
  ...
}:
{
  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;
  # 允许安装不自由的软件包
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    just
    fastfetch
    htop
    tree
    lazygit
    nodejs_24
  ];
  nix = {
    # Determinate Nix 使用自己的守护进程来管理 Nix 安装,
    # 这会与 nix-darwin 的原生 Nix 管理冲突。
    #
    # 注意: 如果你正在使用 Determinate Nix,请将此项设置为 false。
    # 警告: 关闭此选项将使以下所有 nix 配置失效,
    # 你需要手动修改 /etc/nix/nix.custom.conf 来添加相应的参数。
    enable = true;

    package = pkgs.nix;

    settings = {
      # 全局启用 flakes 和新式 nix 命令
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # 在官方源(https://cache.nixos.org)之前优先考虑的镜像源
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # 将当前用户设置为受信任用户,允许使用自定义的 substituters
      trusted-users = [
        "root"
        username
      ];

      # 禁用自动优化存储,因为存在以下问题:
      #   https://github.com/NixOS/nix/issues/7273
      # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
      auto-optimise-store = false;
    };

    # 每周执行垃圾回收以保持较低的磁盘使用量
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  # 时区设置
  time.timeZone = "Asia/Shanghai";
}
