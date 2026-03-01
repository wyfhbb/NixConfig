{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    nodejs_24
    pnpm
  ];
}
