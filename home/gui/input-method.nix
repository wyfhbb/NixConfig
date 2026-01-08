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
  # - 皮肤主题配置
  # - 其他输入法配置
}
