{pkgs, ...}:{
  # 允许安装不自由的软件包
  nixpkgs.config.allowUnfree = true;

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
  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;
  fonts = {
    packages = with pkgs; [
      # JetBrains 系列
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted

      meslo-lgs-nf
    ];
  };
}