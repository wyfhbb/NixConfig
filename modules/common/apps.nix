{pkgs, ...}:{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    just
    tmux
    wget
    fastfetch
    htop
    tree
  ];
  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;
  fonts = {
    packages = with pkgs; [
      # jetbrains
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted

      meslo-lgs-nf
    ];
  };
}