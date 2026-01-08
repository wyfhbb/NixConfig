{ config, pkgs, ... }:

let
  # 下载小鹤双拼配置文件
  xiaoheFlypy = pkgs.fetchurl {
    url = "https://github.com/wyfhbb/xiaohe-fcitx5-rime/releases/download/v1.0.0/flypy.tar.xz";
    sha256 = "547e39467b7365e7b845c4bac82ca10e1d2afdff88670933feeb79eeca830dfd";
  };

  # 解压并准备配置文件
  xiaoheFcitx5Config = pkgs.runCommand "xiaohe-fcitx5-rime" {} ''
    mkdir -p $out
    tar -xJf ${xiaoheFlypy} -C $out
  '';
in
{
  # Home Manager fcitx5 配置
  home.file = {
    # 将小鹤双拼配置链接到 ~/.local/share/fcitx5
    ".local/share/fcitx5".source = "${xiaoheFcitx5Config}/fcitx5";
  };

  # 单独配置 fcitx5 配置目录，使用 force 选项确保文件被创建
  xdg.configFile = {
    # ClassicUI 配置
    "fcitx5/conf/classicui.conf" = {
      text = ''
      # Vertical Candidate List
      Vertical Candidate List=False
      # Use mouse wheel to go to prev or next page
      WheelForPaging=True
      # Font
      Font="PingFang SC 12"
      # Menu Font
      MenuFont="PingFang SC 12"
      # Tray Font
      TrayFont="PingFang HK Medium Medium 12"
      # Tray Label Outline Color
      TrayOutlineColor=#000000
      # Tray Label Text Color
      TrayTextColor=#ffffff
      # Prefer Text Icon
      PreferTextIcon=False
      # Show Layout Name In Icon
      ShowLayoutNameInIcon=True
      # Use input method language to display text
      UseInputMethodLanguageToDisplayText=True
      # Theme
      Theme=非人哉
      # Dark Theme
      DarkTheme=default-dark
      # Follow system light/dark color scheme
      UseDarkTheme=False
      # Follow system accent color if it is supported by theme and desktop
      UseAccentColor=True
      # Use Per Screen DPI on X11
      PerScreenDPI=False
      # Force font DPI on Wayland
      ForceWaylandDPI=0
      # Enable fractional scale under Wayland
      EnableFractionalScale=True
      '';
      force = true;  # 强制创建文件，即使目录不存在
    };
  };

  # 设置 fcitx5 环境变量
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # 如果使用 Wayland，可能还需要这个
    # SDL_IM_MODULE = "fcitx";
  };

  # TODO: 后续添加其他 fcitx5 相关配置
  # - 输入法切换快捷键
  # - Rime 自定义词库
  # - 确保"非人哉"主题已安装
  # - 其他输入法配置
}
