{ pkgs, lib, ... }:

let
  # 定义通用的配置（不涉及平台差异的部分）
  commonConfig = ''
    font-family = "MesloLGS NF"
    font-size = 14.6

    # 自动复制选中文本到系统剪切板
    copy-on-select = clipboard

    # 确认关闭窗口时不显示确认提示
    confirm-close-surface = false
    
    # 光标轨迹特效（保持你的路径引用）
    custom-shader = ${./cursor_smear.glsl}

    background = #1F1F1F
    foreground = #CCCCCC

    palette = 0=#000000
    palette = 1=#d6181b
    palette = 2=#6A9955
    palette = 3=#e4d201
    palette = 4=#569cd6
    palette = 5=#bc3fbc
    palette = 6=#4EC9B0
    palette = 7=#e5e5e5
    palette = 8=#666666
    palette = 9=#ce9178
    palette = 10=#b5cea8
    palette = 11=#DCDCAA
    palette = 12=#9cdcfe
    palette = 13=#d670d6
    palette = 14=#9cdcfe
    palette = 15=#e5e5e5

    window-padding-x = 5
    window-padding-y = 5
    background-opacity = 0.7
  '';

  # 根据系统类型定义差异化配置
  specificConfig = if pkgs.stdenv.isDarwin then ''
    # --- macOS 专属 ---
    macos-titlebar-style = transparent
    background-blur = true
  '' else ''
    # --- Linux (Niri/Wayland) 专属 ---
    # 禁用窗口装饰，交给 Niri 处理
    window-decoration = false
    # Linux 下某些合成器需要这个来确保透明生效
    window-theme = dark
  '';

in
{
  xdg.configFile."ghostty/config" = {
    text = commonConfig + specificConfig;
    force = true;
  };
}