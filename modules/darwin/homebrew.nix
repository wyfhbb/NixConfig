# Homebrew 配置
{ config, pkgs, ... }:

{
  # Homebrew 安装的应用程序不由 Nix 管理，且不可复现！
  # 但在 macOS 上，Homebrew 拥有比 nixpkgs 多得多的应用程序选择，尤其是对于 GUI 应用程序！
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # 获取 Homebrew git 仓库的最新稳定分支
      upgrade = true; # 升级过时的 casks、formulae 和 App Store 应用
      # 'zap': 卸载所有不在生成的 Brewfile 中列出的 formulae（及相关文件）
      cleanup = "zap";
    };

    # 使用 mas 从 Mac App Store 安装的应用程序。
    # 你需要首先手动安装所有这些应用程序，以便你的 Apple 账户有它们的记录。
    # 否则 Apple Store 将拒绝安装它们。
    # 详情请参阅 https://github.com/mas-cli/mas
    masApps = {
      # Xcode = 497799835;
      onedrive = 823766827;
      # https://apps.apple.com/us/app/microsoft-excel/id462058435?mt=12Microsoft Excel
      microsoft-excel = 462058435;
      # https://apps.apple.com/us/app/microsoft-powerpoint/id462062816?mt=12 Microsoft PowerPoint
      microsoft-powerpoint = 462062816;
      # https://apps.apple.com/us/app/microsoft-word/id462054704?mt=12 Microsoft Word
      microsoft-word = 462054704;
      # https://apps.apple.com/us/app/wechat/id836500024?mt=12WeChat Wechat
      wechat = 836500024;

    };

    brews = [
      "curl" # 不要通过 nixpkgs 安装 curl，它在 macOS 上工作不正常！
    ];

    casks = [
      "google-chrome"
      "visual-studio-code"
      "ghostty"
      "clash-party"
      "qq"
      "termius"
      "localsend"
      "wechatwork"
      "tencent-meeting"
      "mos"
    ];
  };
}
