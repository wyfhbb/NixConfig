{ pkgs, lib, ... }:
let
  # 苹方字体包（仅在非 macOS 系统上安装）
  pingfang-fonts = pkgs.stdenv.mkDerivation {
    name = "pingfang-fonts";

    src = pkgs.fetchurl {
      url = "https://github.com/wyfhbb/xiaohe-fcitx5-rime/releases/download/v1.0.0/fonts.tar.gz";
      sha256 = "5a6c969ca81e1cc78a04213d1d7e00d045637288e3927cf14cef0e99724c6d14";
    };

    # 压缩包解压后直接是字体文件，没有目录结构
    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp *.otf $out/share/fonts/opentype/
    '';
  };

  # 根据系统平台决定是否包含苹方字体
  customFonts = lib.optionals (!pkgs.stdenv.isDarwin) [ pingfang-fonts ];
in
{
  fonts = {
    packages = with pkgs; [
      # JetBrains 系列
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      # Maple Mono 系列
      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted

      meslo-lgs-nf

      # 中文字体
      source-han-sans # 思源黑体
      source-han-serif # 思源宋体
      noto-fonts-cjk-sans # Noto Sans CJK
      noto-fonts-cjk-serif # Noto Serif CJK
      wqy_zenhei # 文泉驿正黑

      # 编程字体
      fira-code # Fira Code
      source-code-pro # Source Code Pro

      # Emoji 和符号
      noto-fonts-color-emoji # Emoji 支持

      # 通用字体
      liberation_ttf # Liberation 字体族
      dejavu_fonts # DejaVu 字体族
    ] ++ customFonts; # 在非 macOS 系统上添加苹方字体
  };
}
