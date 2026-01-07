# Homebrew 配置
{ config, pkgs, ... }:

{
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
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
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
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
