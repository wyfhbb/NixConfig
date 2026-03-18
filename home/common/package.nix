# 核心命令行工具（所有平台通用）
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_24
    pnpm
  ];
}