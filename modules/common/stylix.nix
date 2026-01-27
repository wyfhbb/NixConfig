# Stylix 统一主题配置
# 管理系统颜色主题、字体、鼠标指针等
{ pkgs, lib, ... }:

let
  # macOS 风格鼠标指针包
  macos-cursor = pkgs.stdenv.mkDerivation {
    name = "macOS-cursor";
    src = ../../home/gui/macOS-cursor.tar.gz;
    nativeBuildInputs = [ pkgs.gnutar pkgs.gzip ];
    dontBuild = true;
    unpackPhase = ''
      tar -xzf $src
    '';
    installPhase = ''
      mkdir -p $out/share/icons/macOS
      cp -r macOS/* $out/share/icons/macOS/
    '';
  };

  # 苹方字体包（仅在非 macOS 系统上使用）
  pingfang-fonts = pkgs.stdenv.mkDerivation {
    name = "pingfang-fonts";

    src = pkgs.fetchurl {
      url = "https://github.com/wyfhbb/xiaohe-fcitx5-rime/releases/download/v1.0.0/fonts.tar.gz";
      sha256 = "5a6c969ca81e1cc78a04213d1d7e00d045637288e3927cf14cef0e99724c6d14";
    };

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp *.otf $out/share/fonts/opentype/
    '';
  };
in
{
  stylix = {
    enable = true;

    image = ./wallpaper.jpg;


    # 主题极性：深色
    polarity = "light";

    # ────────────────────────────────────────────────
    # 禁用与其他模块冲突的目标
    # ────────────────────────────────────────────────
    targets = {
      # 保留 grub2-themes 的自定义配置
      grub.enable = false;
    };

    # ────────────────────────────────────────────────
    # 鼠标指针配置
    # ────────────────────────────────────────────────
    cursor = {
      package = macos-cursor;
      name = "macOS";
      size = 24;
    };

    # ────────────────────────────────────────────────
    # 字体配置
    # ────────────────────────────────────────────────
    fonts = {
      # 衬线字体
      serif = {
        package = pingfang-fonts;
        name = "PingFang SC";
      };

      # 无衬线字体
      sansSerif = {
        package = pingfang-fonts;
        name = "PingFang SC";
      };

      # 等宽字体（终端、代码编辑器）
      monospace = {
        package = pkgs.meslo-lgs-nf;
        name = "MesloLGS NF";
      };

      # Emoji 字体
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      # 字体大小
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 10;
        terminal = 10;
      };
    };

    # ────────────────────────────────────────────────
    # 透明度设置
    # ────────────────────────────────────────────────
    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.9;
      terminal = 0.95;
    };

  };
}
